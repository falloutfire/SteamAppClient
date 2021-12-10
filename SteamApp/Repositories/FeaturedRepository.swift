//
//  FeaturedRepository.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import Foundation
import UIKit
import Combine

protocol FeaturedUseCaseProtocol {
    func getFeaturedItems() -> AnyPublisher<Result<FeaturedCollection, Error>, Never>
    
    func getFeaturedImageItem(item: FeaturedItem, completion: @escaping (Result<UIImage, Error>) -> Void)
    
    //func getItemsFromCategory() -> AnyPublisher<Result<[CategoryApiTab], Error>, Never>
}

class FeaturedRepository: FeaturedUseCaseProtocol {
    
    
    private let client: FeaturedClient
    static let shared = FeaturedRepository(client: FeaturedClient())
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(Result<UIImage, Error>) -> Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    private init(client: FeaturedClient) {
        self.client = client
    }
    
    func getFeaturedItems() -> AnyPublisher<Result<FeaturedCollection, Error>, Never> {
        return client.getFeaturedItems()
            .flatMap { result -> AnyPublisher<Result<FeaturedCollection, Error>, Never> in
                switch result {
                case .success(let data):
                    
                    let largeCapsules = data.largeCapsules.publisher.map {
                        $0.transformToFeaturedItem()
                    }.removeDuplicates().collect()
                    
                    let featuredWin = data.featuredWin.publisher.map { $0.transformToFeaturedItem()
                    }.removeDuplicates().collect()
                    
                    let featuredMAC = data.featuredMAC.publisher.map { $0.transformToFeaturedItem() }.removeDuplicates().collect()
                    
                    let featuredLinux = data.featuredLinux.publisher.map { $0.transformToFeaturedItem() }.removeDuplicates().collect()
                    
                    let value = Publishers.Zip4(largeCapsules, featuredWin, featuredMAC, featuredLinux).map { (largeCapsulesApi, featuredWinApi, featuredMACApi, featuredLinuxApi) -> Result<FeaturedCollection, Error> in
                        
                        let collection = FeaturedCollection(largeCapsules: largeCapsulesApi, featuredWin: featuredWinApi, featuredMAC: featuredMACApi, featuredLinux: featuredLinuxApi, layout: data.layout, status: data.status)
                        return Result<FeaturedCollection, Error>.success(collection)
                    }
                    return value.eraseToAnyPublisher()
                case .failure(let error):
                    return Just(Result<FeaturedCollection, Error>.failure(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getFeaturedImageItem(item: FeaturedItem, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let url = NSURL(string: item.headerImage) {
            // Check for a cached image.
            if let cachedImage = image(url: url) {
                DispatchQueue.main.async {
                    completion(.success(cachedImage))
                }
                return
            }
            
            // In case there are more than one requestor for the image, we append their completion block.
            if loadingResponses[url] != nil {
                loadingResponses[url]?.append(completion)
                return
            } else {
                loadingResponses[url] = [completion]
            }
            
            
            client.getFeaturedImageItem(url: url as URL, completion: { result in
                switch result {
                case .success(let data):
                    guard let image = data, let blocks = self.loadingResponses[url] else {
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "IMAGE PARSE ERROR", code: 1, userInfo: nil)))
                        }
                        return
                    }
                    
                    self.cachedImages.setObject(image, forKey: url, cost: image.jpegData(compressionQuality: 1)?.count ?? 0)
                    // Iterate over each requestor for the image and pass it back.
                    for block in blocks {
                        DispatchQueue.main.async {
                            block(.success(image))
                        }
                        return
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
        
    }
    
    
    func getItemsFromCategory() /*-> AnyPublisher<Result<[CategoryApiTab], Error>, Never>*/ {
        let test = client.getItemsByCategory()
            .map { result -> Result<CategoryCollection, Error> in
                switch result {
                case .success(let data):
                    var items: [String: CategoryTabsItems] = [:]
                    
                    let viewAll = data.tabs?.viewall?.items.map({
                        $0.convertToCategoryItem()
                    })
                    let topSellers = data.tabs?.topsellers?.items.map({
                        $0.convertToCategoryItem()
                    })
                    let specials = data.tabs?.specials?.items.map({
                        $0.convertToCategoryItem()
                    })
                    let underTen = data.tabs?.underTen?.items.map({
                        $0.convertToCategoryItem()
                    })
                    let dlc = data.tabs?.dlc?.items.map({
                        $0.convertToCategoryItem()
                    })
                    
                    items[data.tabs?.viewall?.name ?? ""] = CategoryTabsItems(name: data.tabs?.viewall?.name ?? "", totalItemCount: viewAll?.count ?? 0, items: viewAll ?? [])
                    items[data.tabs?.topsellers?.name ?? ""] = CategoryTabsItems(name: data.tabs?.topsellers?.name ?? "", totalItemCount: topSellers?.count ?? 0, items: topSellers ?? [])
                    items[data.tabs?.specials?.name ?? ""] = CategoryTabsItems(name: data.tabs?.specials?.name ?? "", totalItemCount: specials?.count ?? 0, items: specials ?? [])
                    items[data.tabs?.underTen?.name ?? ""] = CategoryTabsItems(name: data.tabs?.underTen?.name ?? "", totalItemCount: underTen?.count ?? 0, items: underTen ?? [])
                    items[data.tabs?.dlc?.name ?? ""] = CategoryTabsItems(name: data.tabs?.dlc?.name ?? "", totalItemCount: dlc?.count ?? 0, items: dlc ?? [])
                    
                    return Result<CategoryCollection, Error>.success(CategoryCollection(id: data.id ?? "", name: data.name ?? "", tabs: items, status: data.status ?? 0))
                case .failure(let error):
                    return Result<CategoryCollection, Error>.failure(error)
                }
            }
    }
    
}
