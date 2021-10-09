//
//  UIViewController+Router.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import UIKit
import RouteComposer

extension UIViewController {

    static let router: Router = {
        var defaultRouter = DefaultRouter()
        defaultRouter.add(NavigationDelayingInterceptor(strategy: .wait))
        return defaultRouter
    }()

    var router: Router {
        UIViewController.router
    }

}
