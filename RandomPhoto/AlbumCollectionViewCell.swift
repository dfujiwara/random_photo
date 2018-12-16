//
//  AlbumCollectionViewCell.swift
//  RandomPhoto
//
//  Created by Daisuke Fujiwara on 12/15/18.
//  Copyright © 2018 dfujiwara. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        return view
    }()
    let titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.numberOfLines = 1
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        return view
    }()
    let selectionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.numberOfLines = 1
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout)
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.text = "⭐️"
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectionLabel)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tuple: (image: UIImage, title: String), selected: Bool) {
        imageView.image = tuple.image
        titleLabel.text = tuple.title
        selectionLabel.isHidden = !selected
    }

    private func setupConstraints() {
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            selectionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            selectionLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            selectionLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            selectionLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
