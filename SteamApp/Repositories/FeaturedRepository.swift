//
//  FeaturedRepository.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import Foundation
import UIKit

protocol FeaturedUseCaseProtocol {
    func getFeaturedItems(completion: @escaping (Result<FeaturedCollection, Error>) -> Void)
    
    func getFeaturedImageItem(item: FeaturedItem, completion: @escaping (Result<UIImage, Error>) -> Void)
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
    
    func getFeaturedItems(completion: @escaping (Result<FeaturedCollection, Error>) -> Void) {
        client.getFeaturedItems(completion: { result in
            switch result {
            case .success(let data):
                completion(.success(data.transformToFeaturedCollection()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
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
    
    
}
