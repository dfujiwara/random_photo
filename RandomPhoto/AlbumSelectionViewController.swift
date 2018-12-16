//
//  AlbumSelectionViewController.swift
//  RandomPhoto
//
//  Created by Daisuke Fujiwara on 12/15/18.
//  Copyright © 2018 dfujiwara. All rights reserved.
//

import UIKit

class AlbumSelectionViewController: UIViewController {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    private let albumLibrary: AlbumAccess
    private var albumTuples: [AlbumAccess.AlbumTuple] = [] {
        didSet {
            print("set")
            collectionView.reloadData()
        }
    }
    let dispatchQueue: DispatchQueue

    init(albumLibrary: AlbumAccess = PhotoLibrary(),
         dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.albumLibrary = albumLibrary
        self.dispatchQueue = dispatchQueue
        super.init(nibName: nil, bundle: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupNavigation()
        setupConstraints()

        albumLibrary.getAlbums { [weak self] result in
            self?.dispatchQueue.async {
                switch result {
                case let .success(tuples):
                    self?.albumTuples = tuples
                case let .error(error):
                    print(error)
                }
            }
        }
    }

    private func setupNavigation() {
        title = "Albums"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupConstraints() {
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension AlbumSelectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumTuples.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
