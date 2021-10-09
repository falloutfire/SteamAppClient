//
//  FeaturedItem.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import Foundation
import UIKit

// MARK: - FeaturedApiItem
struct FeaturedApiItem: Codable {
    let id, type: Int
    let name: String
    let discounted: Bool
    let discountPercent: Int
    let originalPrice: Int?
    let finalPrice: Int
    let currency: String?
    let largeCapsuleImage, smallCapsuleImage: String
    let windowsAvailable, macAvailable, linuxAvailable, streamingvideoAvailable: Bool
    let discountExpiration: Int?
    let headerImage: String
    let controllerSupport, headline: String?

    enum CodingKeys: String, CodingKey {
        case id, type, name, discounted
        case discountPercent = "discount_percent"
        case originalPrice = "original_price"
        case finalPrice = "final_price"
        case currency
        case largeCapsuleImage = "large_capsule_image"
        case smallCapsuleImage = "small_capsule_image"
        case windowsAvailable = "windows_available"
        case macAvailable = "mac_available"
        case linuxAvailable = "linux_available"
        case streamingvideoAvailable = "streamingvideo_available"
        case discountExpiration = "discount_expiration"
        case headerImage = "header_image"
        case controllerSupport = "controller_support"
        case headline
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FeaturedApiItem, rhs: FeaturedApiItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func transformToFeaturedItem() -> FeaturedItem {
        return FeaturedItem(id: self.id, type: self.type, name: self.name, discounted: self.discounted, discountPercent: self.discountPercent, originalPrice: self.originalPrice ?? 1, finalPrice: self.finalPrice, currency: self.currency ?? "", largeCapsuleImage: self.largeCapsuleImage, smallCapsuleImage: self.smallCapsuleImage, windowsAvailable: self.windowsAvailable, macAvailable: self.macAvailable, linuxAvailable: self.macAvailable, streamingvideoAvailable: self.streamingvideoAvailable, headerImage: self.headerImage, controllerSupport: self.controllerSupport, discountExpiration: self.discountExpiration, image: nil)
    }
}
