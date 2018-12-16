//
//  PhotoViewController.swift
//  RandomPhoto
//
//  Created by Daisuke Fujiwara on 12/15/18.
//  Copyright © 2018 dfujiwara. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    let imageView: UIImageView = UIImageView(frame: .zero)
    let photoLibrary: PhotoAccess

    init(photoLibrary: PhotoAccess) {
        self.photoLibrary = photoLibrary
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        let photoLibrary = PhotoLibrary(dispatchQueue: DispatchQueue.global(qos: .userInteractive))
        self.init(photoLibrary: photoLibrary)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = self.imageView
        view.addSubview(imageView)
        view.backgroundColor = UIColor.white
        setupImageView()
        setupNavigation()
        setupConstraints()
        photoLibrary.getRandomPhoto(albumName: "Sherlock") { result in
            switch result {
            case let .success(image):
                imageView.image = image

            case let .error(error):
                print(error)
            }
        }
    }

    private func setupNavigation() {
        title = "Hello"
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
