//
//  FeaturedItem.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import Foundation
import UIKit

// MARK: - FeaturedCollection
struct FeaturedCollection {
    let largeCapsules, featuredWin, featuredMAC, featuredLinux: [FeaturedItem]
    let layout: String
    let status: Int
}

// MARK: - FeaturedItem
struct FeaturedItem: Hashable {
    let uuid = UUID()
    let id, type: Int
    let name: String
    let discounted: Bool
    let discountPercent: Int?
    let originalPrice: Int
    let finalPrice: Int?
    let currency: String
    let largeCapsuleImage, smallCapsuleImage: String
    let windowsAvailable, macAvailable, linuxAvailable, streamingvideoAvailable: Bool
    let headerImage: String
    let controllerSupport: String?
    let discountExpiration: Int?
    var image: UIImage?
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: FeaturedItem, rhs: FeaturedItem) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.image == rhs.image
    }
    
    
}

