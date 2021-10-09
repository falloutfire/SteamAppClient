//
//  ViewController.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try? router.navigate(to: AppNavigationConfigurationHolder.configuration.mainScreen, with: nil)
    }


}

