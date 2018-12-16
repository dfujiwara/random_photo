//
//  AppRouter.swift
//  RandomPhoto
//
//  Created by Daisuke Fujiwara on 12/15/18.
//  Copyright © 2018 dfujiwara. All rights reserved.
//

import Foundation
import UIKit

enum Route {
    case photo
    case albumSelection
}

class AppRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func route(_ route: Route, animated: Bool = true) {
        switch route {
        case .photo:
            let photoViewController = PhotoViewController(router: self)
            navigationController?.pushViewController(photoViewController, animated: animated)
        case .albumSelection:
            let viewController = UIViewController()
            navigationController?.pushViewController(viewController, animated: animated)
        }
    }
}
