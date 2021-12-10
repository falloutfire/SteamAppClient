//
//  FeaturedClient.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import UIKit
import Alamofire
import Combine

class FeaturedClient: APIClient {
    var session: Session
    
    // MARK: - Initializers
    
    init(session: Session) {
        self.session = session
    }
    
    convenience init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        let retryPolicy = RetryPolicy()
        let eventMonitor = NetworkLogger()
        let session = Session(configuration: configuration, interceptor: retryPolicy, eventMonitors: [eventMonitor])
        
        self.init(session: session)
    }
    
    func getFeaturedItems() -> AnyPublisher<Result<FeaturedApiCollection, APIError>, Never> {
        let request = FeaturedProvider.getFeaturedItem.request
        return fetch(with: request).eraseToAnyPublisher()
    }
    
    func getFeaturedItems(completion: @escaping (Result<FeaturedApiCollection, APIError>) -> Void) {
        let request = FeaturedProvider.getFeaturedItem.request
        
        fetchNoNetwork(with: request, decode: { json -> FeaturedApiCollection? in
            guard let balance = json as? FeaturedApiCollection else { return  nil }
            return balance
        }, completion: completion)
    }
    
    func getFeaturedImageItem(url: URL, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        let request = FeaturedProvider.getImageForFeaturedItem(url: url).request
        
        //fetchImage(with: request, completion: completion)
    }
    
    func getItemsByCategory() -> AnyPublisher<Result<CategoryApiCollection, APIError>, Never> {
        let request = FeaturedProvider.getItemsByCategory(category: "cat_topsellers").request
        return fetch(with: request).eraseToAnyPublisher()
    }
    
}
