//
//  PhotoViewController.swift
//  RandomPhoto
//
//  Created by Daisuke Fujiwara on 12/15/18.
//  Copyright © 2018 dfujiwara. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        return view
    }()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    let photoLibrary: PhotoAccess
    let router: AppRouter
    let dispatchQueue: DispatchQueue

    init(router: AppRouter,
         photoLibrary: PhotoAccess = PhotoLibrary(),
         dispatchQueue: DispatchQueue = DispatchQueue.main) {
        self.photoLibrary = photoLibrary
        self.router = router
        self.dispatchQueue = dispatchQueue
        super.init(nibName: nil, bundle: nil)
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
        setupNavigation()
        setupConstraints()
        loadPhoto()
    }

    private func setupNavigation() {
        title = "Photo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reload",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(reloadTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Album",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(albumTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    @objc
    private func reloadTapped() {
        loadPhoto()
    }

    @objc
    private func albumTapped() {
        router.route(.albumSelection)
    }

    private func setupConstraints() {
        [imageView, activityIndicator].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func loadPhoto() {
        activityIndicator.startAnimating()
        photoLibrary.getRandomPhoto(albumName: "Sherlock") { [weak self] result in
            self?.dispatchQueue.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case let .success(image):
                    self?.imageView.image = image

                case let .error(error):
                    print(error)
                }
            }
        }
    }
}
