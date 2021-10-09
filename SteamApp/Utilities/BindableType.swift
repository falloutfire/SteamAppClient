//
//  BindableType.swift
//  Pokedex
//
//  Created by Ilya Manny on 17.09.2021.
//

import Foundation
import UIKit

protocol BindableType: AnyObject {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }

    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension BindableType where Self: UITableViewCell {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

extension BindableType where Self: UICollectionViewCell {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

public class Bindable<T> {
    
    typealias Listener = ((T) -> Void)
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
}

