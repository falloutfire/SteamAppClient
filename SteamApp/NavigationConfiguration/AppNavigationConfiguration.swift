//
//  AppNavigationConfiguration.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import UIKit
import RouteComposer

protocol AppScreenNavigationConfiguration {
    
    var mainScreen: DestinationStep<UINavigationController, Any?> { get }
    
    var mainTablePokemonScreen: DestinationStep<MainViewController, Any?> { get }
    
}

extension AppScreenNavigationConfiguration {
    
    var mainScreen: DestinationStep<UINavigationController, Any?> {
        StepAssembly(
            finder: ClassFinder(options: .current, startingPoint: .root),
            factory: MainViewControllerFactory())
            .using(GeneralAction.replaceRoot())
            .from(GeneralStep.root())
            .assemble()
    }
    
    
    var mainTablePokemonScreen: DestinationStep<MainViewController, Any?> {
        StepAssembly(
            finder: ClassFinder<MainViewController, Any?>(),
            factory: NilFactory())
            .adding(AppGenericContextTask<MainViewController, Any?>())
            .from(mainScreen)
            .assemble()
    }
}

struct AppNavigationConfiguration: AppScreenNavigationConfiguration {
}

class AppNavigationConfigurationHolder {
    static var configuration: AppScreenNavigationConfiguration = AppNavigationConfiguration()
}
