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
    func getRandomPhoto(albumName: String, completionHandler: @escaping (Result<UIImage>) -> Void)
}

class PhotoLibrary: PhotoAccess {
    let dispatchQueue: DispatchQueue

    init(dispatchQueue: DispatchQueue) {
        self.dispatchQueue = dispatchQueue
    }

    func getRandomPhoto(albumName: String, completionHandler: @escaping (Result<UIImage>) -> Void) {
        dispatchQueue.async {
            do {
                let albums = self.retrieveSelectedAlbum(albumName)
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
        let fetchResults = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                   subtype: .any,
                                                                   options: nil)
        return (0..<fetchResults.count).compactMap { index -> PHAssetCollection? in
            let fetchResult = fetchResults.object(at: index)
            return fetchResult.localizedTitle == albumName ? fetchResult : nil
        }
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
        let manager = PHImageManager.default()
        manager.requestImage(for: randomAsset,
                             targetSize: PHImageManagerMaximumSize,
                             contentMode: .aspectFill,
                             options: nil) { image, _ in
                                if let image = image {
                                    completionHandler(Result.success(image))
                                } else {
                                    completionHandler(Result<UIImage>.error(PhotoAccessError.imageFetchError))
                                }

        }
    }
}
