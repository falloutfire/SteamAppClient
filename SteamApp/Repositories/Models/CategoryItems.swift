//
//  CategoryItems.swift
//  SteamApp
//
//  Created by Ilya Manny on 01.11.2021.
//

import Foundation

// MARK: - CategoryCollection
struct CategoryCollection: Codable, Hashable {
    let id, name: String
    let tabs: [String: CategoryTabsItems]
    let status: Int
}

// MARK: - CategoryTabsItems
struct CategoryTabsItems: Codable, Hashable {
    let uuid: UUID = UUID()
    let name: String
    let totalItemCount: Int
    let items: [CategoryItem]

    enum CodingKeys: String, CodingKey {
        case name
        case totalItemCount = "total_item_count"
        case items
    }
}

// MARK: - Item
struct CategoryItem: Codable, Hashable {
    let type, id: Int
}
