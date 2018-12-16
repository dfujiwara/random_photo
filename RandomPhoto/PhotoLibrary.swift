//
//  PhotoLibrary.swift
//  RandomPhoto
//
//  Created by Daisuke Fujiwara on 12/15/18.
//  Copyright © 2018 dfujiwara. All rights reserved.
//

import Foundation
import Photos

enum Result<T> {
    case success(T)
    case error(Error)
}

enum PhotoAccessError: Error {
    case noAlbum
    case noPhoto
    case imageFetchError
}

protocol PhotoAccess: AnyObject {
    func getRandomPhoto(completionHandler: @escaping (Result<UIImage>) -> Void)
}

protocol AlbumAccess: AnyObject {
    typealias AlbumTuple = (image: UIImage, title: String)
    func getAlbums(completionHandler: @escaping (Result<[AlbumTuple]>) -> Void)
}

class PhotoLibrary: PhotoAccess, AlbumAccess {
    let dispatchQueue: DispatchQueue
    let serialQueue: DispatchQueue
    let manager: PHImageManager
    let albumTitle: String = "Sherlock"

    init(dispatchQueue: DispatchQueue = DispatchQueue.global(qos: .userInteractive),
         serialQueue: DispatchQueue = DispatchQueue.main,
         manager: PHImageManager = PHImageManager.default()) {
        self.dispatchQueue = dispatchQueue
        self.serialQueue = serialQueue
        self.manager = manager
    }

    func getRandomPhoto(completionHandler: @escaping (Result<UIImage>) -> Void) {
        dispatchQueue.async {
            do {
                let albums = self.retrieveSelectedAlbum(self.albumTitle)
                guard let album = albums.first else {
                    throw PhotoAccessError.noAlbum
                }
                let assets = self.retrievePhotoMetadataFromAlbum(album)
                try self.retrieveRandomPhoto(from: assets, completionHandler: completionHandler)
            } catch {
                completionHandler(Result<UIImage>.error(error))
            }
        }
    }

    private func retrieveSelectedAlbum(_ albumName: String) -> [PHAssetCollection] {
        let albums = retrieveAlbums()
        return albums.filter { $0.localizedTitle == albumName }
    }

    private func retrieveAlbums() -> [PHAssetCollection] {
        let fetchResults = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                   subtype: .any,
                                                                   options: nil)
        return (0..<fetchResults.count).map { fetchResults.object(at: $0) }
    }

    private func retrievePhotoMetadataFromAlbum(_ album: PHAssetCollection) -> [PHAsset] {
        let fetchResults = PHAsset.fetchAssets(in: album, options: nil)
        return (0..<fetchResults.count).map { fetchResults.object(at: $0) }
    }

    private func retrieveRandomPhoto(from assets: [PHAsset],
                                     completionHandler: @escaping (Result<UIImage>) -> Void) throws {
        guard let randomAsset = assets.randomElement() else {
            throw PhotoAccessError.noPhoto
        }
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        manager.requestImage(for: randomAsset,
                             targetSize: PHImageManagerMaximumSize,
                             contentMode: .aspectFill,
                             options: requestOptions) { image, _ in
                                if let image = image {
                                    completionHandler(Result.success(image))
                                } else {
                                    completionHandler(Result<UIImage>.error(PhotoAccessError.imageFetchError))
                                }

        }
    }

    func getAlbums(completionHandler: @escaping (Result<[AlbumTuple]>) -> Void) {
        dispatchQueue.async {
            let albums = self.retrieveAlbums()
            let albumPhotoAssets = albums.compactMap { album -> (PHAssetCollection, PHAsset)? in
                guard let asset = self.retrievePhotoMetadataFromAlbum(album).first else {
                    return nil
                }
                return (album, asset)
            }
            let dispatchGroup = DispatchGroup()
            var results: [AlbumTuple] = []
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true

            albumPhotoAssets.forEach { album, asset in
                dispatchGroup.enter()
                self.manager.requestImage(for: asset,
                                          targetSize: PHImageManagerMaximumSize,
                                          contentMode: .aspectFill,
                                          options: requestOptions) { image, _ in
                                            self.serialQueue.async {
                                                if let image = image {
                                                    results.append((image, album.localizedTitle ?? ""))
                                                }
                                                dispatchGroup.leave()
                                            }
                }
            }
            dispatchGroup.wait()
            completionHandler(Result.success(results))
        }
    }
}
