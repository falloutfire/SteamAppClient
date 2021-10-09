//
//  FeaturedCellViewModel.swift
//  SteamApp
//
//  Created by Ilya Manny on 09.10.2021.
//

import UIKit
import RouteComposer

protocol FeaturedCellViewModelProtocol {
    var loading: Bindable<Bool> { get }
    var errorValue: Bindable<Error?> { get }
    var imageCell: Bindable<UIImage> { get }
    var featuredItem: Bindable<FeaturedItem?> { get }
    
    func getImageForFeaturedItem()
}

class FeaturedCellViewModel: NSObject, FeaturedCellViewModelProtocol {

    private(set) var loading: Bindable<Bool> = Bindable(false)
    private(set) var errorValue: Bindable<Error?> = Bindable(nil)
    private(set) var imageCell: Bindable<UIImage> = Bindable(UIImage())
    private(set) var featuredItem: Bindable<FeaturedItem?> = Bindable(nil)
    
    private var router: Router!
    private var featuredRepository: FeaturedUseCaseProtocol!
    
    init(featuredItem: FeaturedItem, router: Router, featuredRepository: FeaturedUseCaseProtocol) {
        super.init()
        self.featuredItem.value = featuredItem
        self.router = router
        self.featuredRepository = featuredRepository
    }
    
    func getImageForFeaturedItem() {
        if let value = featuredItem.value {
            featuredRepository.getFeaturedImageItem(item: value, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.featuredItem.value?.image = data
                    self.imageCell.value = data
                case .failure(let error):
                    self.errorValue.value = error
                    print(error)
                }
            })
        }
    }
}
