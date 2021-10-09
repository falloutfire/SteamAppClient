//
//  File.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import UIKit

class InitViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        try? router.navigate(to: AppNavigationConfigurationHolder.configuration.mainScreen, with: nil)
    }
}
