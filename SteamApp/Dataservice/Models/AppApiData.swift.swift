// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation


// MARK: - The440
struct AppApiResult: Codable {
    let success: Bool?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let type, name: String?
    let steamAppid, requiredAge: Int?
    let isFree: Bool?
    let dlc: [Int]?
    let detailedDescription, aboutTheGame, shortDescription, supportedLanguages: String?
    let headerImage: String?
    let website: String?
    let pcRequirements: PCRequirements?
    let macRequirements, linuxRequirements: Requirements?
    let developers, publishers: [String]?
    let packages: [Int]?
    let packageGroups: [PackageGroup]?
    let platforms: Platforms?
    let metacritic: Metacritic?
    let categories: [Category]?
    let genres: [Genre]?
    let screenshots: [Screenshot]?
    let movies: [Movie]?
    let recommendations: Recommendations?
    let achievements: Achievements?
    let releaseDate: ReleaseDate?
    let supportInfo: SupportInfo?
    let background: String?
    let contentDescriptors: ContentDescriptors?

    enum CodingKeys: String, CodingKey {
        case type, name
        case steamAppid = "steam_appid"
        case requiredAge = "required_age"
        case isFree = "is_free"
        case dlc
        case detailedDescription = "detailed_description"
        case aboutTheGame = "about_the_game"
        case shortDescription = "short_description"
        case supportedLanguages = "supported_languages"
        case headerImage = "header_image"
        case website
        case pcRequirements = "pc_requirements"
        case macRequirements = "mac_requirements"
        case linuxRequirements = "linux_requirements"
        case developers, publishers, packages
        case packageGroups = "package_groups"
        case platforms, metacritic, categories, genres, screenshots, movies, recommendations, achievements
        case releaseDate = "release_date"
        case supportInfo = "support_info"
        case background
        case contentDescriptors = "content_descriptors"
    }
}

// MARK: - Achievements
struct Achievements: Codable {
    let total: Int?
    let highlighted: [Highlighted]?
}

// MARK: - Highlighted
struct Highlighted: Codable {
    let name: String?
    let path: String?
}

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let categoryDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryDescription = "description"
    }
}

// MARK: - ContentDescriptors
struct ContentDescriptors: Codable {
    let ids: [Int]?
    let notes: String?
}

// MARK: - Genre
struct Genre: Codable {
    let id, genreDescription: String?

    enum CodingKeys: String, CodingKey {
        case id
        case genreDescription = "description"
    }
}

// MARK: - Requirements
struct Requirements: Codable {
    let minimum: String?
}

// MARK: - Metacritic
struct Metacritic: Codable {
    let score: Int?
    let url: String?
}

// MARK: - Movie
struct Movie: Codable {
    let id: Int?
    let name: String?
    let thumbnail: String?
    let webm, mp4: Mp4?
    let highlight: Bool?
}

// MARK: - Mp4
struct Mp4: Codable {
    let the480, max: String?

    enum CodingKeys: String, CodingKey {
        case the480 = "480"
        case max
    }
}

// MARK: - PackageGroup
struct PackageGroup: Codable {
    let name, title, packageGroupDescription, selectionText: String?
    let saveText: String?
    let displayType: Int?
    let isRecurringSubscription: String?
    let subs: [Sub]?

    enum CodingKeys: String, CodingKey {
        case name, title
        case packageGroupDescription = "description"
        case selectionText = "selection_text"
        case saveText = "save_text"
        case displayType = "display_type"
        case isRecurringSubscription = "is_recurring_subscription"
        case subs
    }
}

// MARK: - Sub
struct Sub: Codable {
    let packageid: Int?
    let percentSavingsText: String?
    let percentSavings: Int?
    let optionText, optionDescription, canGetFreeLicense: String?
    let isFreeLicense: Bool?
    let priceInCentsWithDiscount: Int?

    enum CodingKeys: String, CodingKey {
        case packageid
        case percentSavingsText = "percent_savings_text"
        case percentSavings = "percent_savings"
        case optionText = "option_text"
        case optionDescription = "option_description"
        case canGetFreeLicense = "can_get_free_license"
        case isFreeLicense = "is_free_license"
        case priceInCentsWithDiscount = "price_in_cents_with_discount"
    }
}

// MARK: - PCRequirements
struct PCRequirements: Codable {
    let minimum, recommended: String?
}

// MARK: - Platforms
struct Platforms: Codable {
    let windows, mac, linux: Bool?
}

// MARK: - Recommendations
struct Recommendations: Codable {
    let total: Int?
}

// MARK: - ReleaseDate
struct ReleaseDate: Codable {
    let comingSoon: Bool?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case comingSoon = "coming_soon"
        case date
    }
}

// MARK: - Screenshot
struct Screenshot: Codable {
    let id: Int?
    let pathThumbnail, pathFull: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pathThumbnail = "path_thumbnail"
        case pathFull = "path_full"
    }
}

// MARK: - SupportInfo
struct SupportInfo: Codable {
    let url: String?
    let email: String?
}
