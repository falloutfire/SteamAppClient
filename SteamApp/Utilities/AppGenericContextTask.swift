//
//  AppGenericContextTask.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import RouteComposer
import UIKit

struct AppGenericContextTask<VC: UIViewController, C>: ContextTask {

    func perform(on viewController: VC, with context: C) throws {
        print("View controller name is \(String(describing: viewController))")
    }

}
