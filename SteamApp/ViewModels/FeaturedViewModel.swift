//
//  FeaturedViewModel.swift
//  SteamApp
//
//  Created by Ilya Manny on 09.10.2021.
//

import UIKit
import RouteComposer
import SwiftUI
import Combine

protocol FeaturedViewModelProtocol {
    var errorPublisher: Published<Error?>.Publisher { get }
    var loadPublisher: Published<Bool>.Publisher { get }
    var featuredItemsPublisher: Published<[FeaturedHashableSection]?>.Publisher { get }
    
    func getFeaturedItems()
}

class FeaturedViewModel: NSObject, FeaturedViewModelProtocol {
    
    @Published private var errorValue: Error? = nil
    @Published private var loading: Bool = true
    @Published private var featuredItems: [FeaturedHashableSection]? = nil
    
    var errorPublisher: Published<Error?>.Publisher { $errorValue }
    var loadPublisher: Published<Bool>.Publisher { $loading }
    var featuredItemsPublisher: Published<[FeaturedHashableSection]?>.Publisher { $featuredItems }
    
    private var router: Router!
    private var featuredRepository: FeaturedUseCaseProtocol!
    
    private var subscribitions = Set<AnyCancellable>()
    
    init(router: Router, featuredRepository: FeaturedUseCaseProtocol) {
        super.init()
        self.router = router
        self.featuredRepository = featuredRepository
    }
    
    func getFeaturedItems() {
        let currentThread = Thread.current.number
        print("\n current thread \(currentThread)\n")
        featuredRepository.getFeaturedItems()
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .receive(on: DispatchQueue.main)
            .map { result -> Result<FeaturedCollection, Error> in
                print("Beginning expensive computation on thread \(Thread.current.number)")
                return result
            }.sink { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.featuredItems = [FeaturedHashableSection(type: .largeCapsulesItems, items: data.largeCapsules),
                                      FeaturedHashableSection(type: .featuredWinItems, items: data.featuredWin),
                                      FeaturedHashableSection(type: .featuredMACItems, items: data.featuredMAC),
                                      FeaturedHashableSection(type: .featuredLinuxItems, items: data.featuredLinux)]
            case .failure(let error):
                self.errorValue = error
                print(error)
            }
        }.store(in: &subscribitions)
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

extension Thread {
  public var number: Int {
    let desc = self.description
    if let numberMatches = Regexes.threadNumber.firstMatch(in: desc, range: NSMakeRange(0, desc.count)) {
      let s = NSString(string: desc).substring(with: numberMatches.range(at: 1))
      return Int(s) ?? 0
    }
    return 0
  }
}

fileprivate enum Regexes {
  static let threadNumber = try! NSRegularExpression(pattern: "number = (\\d+)", options: .caseInsensitive)
}


