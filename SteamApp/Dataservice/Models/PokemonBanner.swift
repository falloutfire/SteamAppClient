//
//  PokemonBanner.swift
//  Pokedex
//
//  Created by Ilya Manny on 26.09.2021.
//

import Foundation

struct PokemonBanner: Hashable {
    var id: Int
    var title: String
    var imageName: String
}

extension PokemonBanner {
    static func testData() -> [PokemonBanner] {
        let banner1 = PokemonBanner(id: 1, title: "BulbaZavr", imageName: "scribble")
        let banner2 = PokemonBanner(id: 1, title: "Pikachu", imageName: "scribble")
        let banner3 = PokemonBanner(id: 1, title: "Cahrmander", imageName: "scribble")
        return [banner1, banner2, banner3]
    }
}
