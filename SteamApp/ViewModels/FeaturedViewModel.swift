//
//  FeaturedViewModel.swift
//  SteamApp
//
//  Created by Ilya Manny on 09.10.2021.
//

import UIKit
import RouteComposer
import SwiftUI

protocol FeaturedViewModelProtocol {
    var loading: Bindable<Bool> { get }
    var errorValue: Bindable<Error?> { get }
    
    var items: Bindable<[FeaturedHashableSection]?> { get }
    
    func getFeaturedItems()
}

class FeaturedViewModel: NSObject, FeaturedViewModelProtocol {
    
    private(set) var loading: Bindable<Bool> = Bindable(false)
    private(set) var errorValue: Bindable<Error?> = Bindable(nil)
    
    private(set) var items: Bindable<[FeaturedHashableSection]?> = Bindable(nil)
    
    private var featuredItems: [FeaturedHashableSection]? = nil {
        didSet {
            self.items.value = self.featuredItems
        }
    }
    
    private var router: Router!
    private var featuredRepository: FeaturedUseCaseProtocol!
    
    init(router: Router, featuredRepository: FeaturedUseCaseProtocol) {
        super.init()
        self.router = router
        self.featuredRepository = featuredRepository
    }
    
    func getFeaturedItems() {
        featuredRepository.getFeaturedItems(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                //                self.items.value = [.largeCapsulesItems(data.largeCapsules),
                //                                    .featuredWinItems(data.featuredWin),
                //                                    .featuredMACItems(data.featuredMAC),
                //                                    .featuredLinuxItems(data.featuredLinux)]
                
                self.featuredItems = [FeaturedHashableSection(type: .largeCapsulesItems, items: data.largeCapsules),
                                      FeaturedHashableSection(type: .featuredWinItems, items: data.featuredWin),
                                      FeaturedHashableSection(type: .featuredMACItems, items: data.featuredMAC),
                                      FeaturedHashableSection(type: .featuredLinuxItems, items: data.featuredLinux)]
                
                //self.getImages()
                
            case .failure(let error):
                self.errorValue.value = error
                print(error)
            }
        })
    }
    
    private func getImages() {
        if let values = items.value {
            for featuredItemsId in 0..<values.count {
                if let items = values[featuredItemsId].items {
                    for id in 0..<items.count {
                        featuredRepository.getFeaturedImageItem(item: items[id], completion: { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let data):
                                self.items.value?[featuredItemsId].items?[id].image = data
                            case .failure(let error):
                                self.errorValue.value = error
                                print(error)
                            }
                        })
                    }
                }
            }
        }
    }
    
}

class FeaturedHashableSection: Hashable {
    var id = UUID()
    // 2
    var type: FeaturedSection
    var items: [FeaturedItem]?
    
    init(type: FeaturedSection, items: [FeaturedItem]?) {
        self.type = type
        self.items = items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FeaturedHashableSection, rhs: FeaturedHashableSection) -> Bool {
        lhs.id == rhs.id
    }
}

enum FeaturedSection: Int, CaseIterable {
    case largeCapsulesItems
    case featuredWinItems
    case featuredMACItems
    case featuredLinuxItems
}
