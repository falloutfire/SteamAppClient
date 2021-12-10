//
//  FeaturedProvider.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import UIKit

enum FeaturedProvider {
    case getFeaturedItem
    case getImageForFeaturedItem(url: URL)
    case getItemsByCategory(category: String)
}

extension FeaturedProvider: Endpoint {
    var base: URL {
        switch self {
        case .getFeaturedItem, .getItemsByCategory: return URL(string: "https://store.steampowered.com")!
        case .getImageForFeaturedItem(let url): return url
        }
    }
    
    var path: String? {
        switch self {
        case .getFeaturedItem: return "api/featured"
        case .getImageForFeaturedItem: return nil
        case .getItemsByCategory(let category): return "api/getappsincategory/?category=\(category)"
        }
    }
    
    var params: [String : Any]? {
        nil
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var contentType: ContentType {
        switch self {
        case .getFeaturedItem, .getItemsByCategory: return .json
        case .getImageForFeaturedItem: return .image
        }
    }
    
    var image: UIImage? {
        nil
    }
}
