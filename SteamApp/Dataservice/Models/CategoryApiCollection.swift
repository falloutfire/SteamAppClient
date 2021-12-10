//
//  CategoryApiItems.swift
//  SteamApp
//
//  Created by Ilya Manny on 31.10.2021.
//

import Foundation

// MARK: - CategoryApiCollection
struct CategoryApiCollection: Codable {
    let id, name: String?
    let tabs: CategoryApiTabs?
    let status: Int?
}

// MARK: - CategoryApiTabs
struct CategoryApiTabs: Codable {
    let viewall, topsellers, specials, underTen: CategoryTabsApiItems?
    let dlc: CategoryTabsApiItems?

    enum CodingKeys: String, CodingKey {
        case viewall, topsellers, specials
        case underTen = "under_ten"
        case dlc
    }
}

// MARK: - CategoryTabsApiItems
struct CategoryTabsApiItems: Codable {
    let name: String
    let totalItemCount: Int
    let items: [CategoryApiItem]

    enum CodingKeys: String, CodingKey {
        case name
        case totalItemCount = "total_item_count"
        case items
    }
}

// MARK: - Item
struct CategoryApiItem: Codable {
    let type, id: Int
    
    func convertToCategoryItem() -> CategoryItem {
        CategoryItem(type: self.type, id: self.id)
    }
}
