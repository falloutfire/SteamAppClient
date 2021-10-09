//
//  FeaturedCollection.swift
//  SteamApp
//
//  Created by Ilya Manny on 08.10.2021.
//

import Foundation

// MARK: - FeaturedApiCollection
struct FeaturedApiCollection: Codable {
    let largeCapsules, featuredWin, featuredMAC, featuredLinux: [FeaturedApiItem]
    let layout: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case largeCapsules = "large_capsules"
        case featuredWin = "featured_win"
        case featuredMAC = "featured_mac"
        case featuredLinux = "featured_linux"
        case layout, status
    }
    
    func transformToFeaturedCollection() -> FeaturedCollection {
        var largeCapsules = [FeaturedItem]()
        self.largeCapsules.forEach { item in
            largeCapsules.append(item.transformToFeaturedItem())
        }
        var featuredWin = [FeaturedItem]()
        self.featuredWin.forEach { item in
            featuredWin.append(item.transformToFeaturedItem())
        }
        var featuredMAC = [FeaturedItem]()
        self.featuredMAC.forEach { item in
            featuredMAC.append(item.transformToFeaturedItem())
        }
        var featuredLinux = [FeaturedItem]()
        self.featuredLinux.forEach { item in
            featuredLinux.append(item.transformToFeaturedItem())
        }
        return FeaturedCollection(largeCapsules: largeCapsules, featuredWin: featuredWin, featuredMAC: featuredMAC, featuredLinux: featuredLinux, layout: self.layout, status: self.status)
    }
}
