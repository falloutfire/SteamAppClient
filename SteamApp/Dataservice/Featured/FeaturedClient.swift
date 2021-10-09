//
//  FeaturedClient.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import UIKit

class FeaturedClient: APIClient {
    
    var session: URLSession
    
    var imageSession: URLSession
    
    // MARK: - Initializers
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
        self.imageSession = ImageURLProtocol.urlSession()
    }
    
    convenience init() {
        let configuration: URLSessionConfiguration = .default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil

        self.init(configuration: configuration)
    }
    
    func getFeaturedItems(completion: @escaping (Result<FeaturedApiCollection, APIError>) -> Void) {
        let request = FeaturedProvider.getFeaturedItem.request
        
        fetch(with: request, decode: { json -> FeaturedApiCollection? in
            guard let balance = json as? FeaturedApiCollection else { return  nil }
            return balance
        }, completion: completion)
    }
    
    func getFeaturedImageItem(url: URL, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        let request = FeaturedProvider.getImageForFeaturedItem(url: url).request
        
        fetchImage(with: request, completion: completion)
    }
    
}
