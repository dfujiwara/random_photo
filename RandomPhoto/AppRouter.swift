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
    case albumSelection
}

class AppRouter {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func route(_ route: Route) {
        switch route {
        case .albumSelection:
            let viewController = UIViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
