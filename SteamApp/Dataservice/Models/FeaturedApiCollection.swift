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
}

