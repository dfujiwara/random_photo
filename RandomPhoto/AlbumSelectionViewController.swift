//
//  AlbumSelectionViewController.swift
//  RandomPhoto
//
//  Created by Daisuke Fujiwara on 12/15/18.
//  Copyright © 2018 dfujiwara. All rights reserved.
//

import UIKit

class AlbumSelectionViewController: UIViewController {
    static var reuseIdentifier: String {
        return String(describing: AlbumSelectionViewController.self)
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 80, height: 100)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.bounces = true
        view.alwaysBounceVertical = true
        view.register(AlbumColletionViewCell.self,
                      forCellWithReuseIdentifier: AlbumSelectionViewController.reuseIdentifier)
        return view
    }()
    private let albumLibrary: AlbumAccess
    private var albumTuples: [AlbumAccess.AlbumTuple] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var selectionIndexPath: IndexPath?
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumSelectionViewController.reuseIdentifier,
                                                      for: indexPath)
        guard let albumCell = cell as? AlbumColletionViewCell else {
            preconditionFailure("Should be the right collection view cell type")
        }
        let tuple = albumTuples[indexPath.row]
        albumCell.configure(with: tuple, selected: selectionIndexPath == indexPath)
        return albumCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousSelectionIndexPath = selectionIndexPath
        selectionIndexPath = indexPath
        let indexPathsToReload = [previousSelectionIndexPath, indexPath].compactMap { $0 }
        collectionView.reloadItems(at: indexPathsToReload)
    }
}
