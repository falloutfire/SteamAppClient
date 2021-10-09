//
//  Router.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import UIKit
import RouteComposer

/// Simple extension to support `Destination` instance directly by the `Router`.
extension Router {
    
    func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>, with context: Context) throws {
        try navigate(to: step, with: context, animated: true, completion: nil)
    }
    
}
