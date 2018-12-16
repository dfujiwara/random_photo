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
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    let photoLibrary: PhotoAccess
    let dispatchQueue: DispatchQueue

    init(photoLibrary: PhotoAccess,
         dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.photoLibrary = photoLibrary
        self.dispatchQueue = dispatchQueue
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
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        view.backgroundColor = UIColor.white
        setupImageView()
        setupNavigation()
        setupConstraints()
        activityIndicator.startAnimating()
        photoLibrary.getRandomPhoto(albumName: "Sherlock") { [weak self] result in
            switch result {
            case let .success(image):
                self?.dispatchQueue.async {
                    self?.activityIndicator.stopAnimating()
                    self?.imageView.image = image
                }
            case let .error(error):
                print(error)
            }
        }
    }

    private func setupNavigation() {
        title = "Hello"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Album",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(albumTapped))
    }

    @objc
    private func albumTapped() {
        print("tapped")
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
    }

    private func setupConstraints() {
        [imageView, activityIndicator].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
