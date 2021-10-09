//
//  PokemonCatalogue.swift
//  Pokedex
//
//  Created by Ilya Manny on 26.09.2021.
//

import Foundation

struct PokemonCatalogue: Hashable {
    var id: Int
    var title: String
    var imageName: String
}

extension PokemonCatalogue {
    static func testData() -> [PokemonCatalogue] {
        let banner1 = PokemonCatalogue(id: 1, title: "BulbaZavr", imageName: "scribble")
        let banner2 = PokemonCatalogue(id: 2, title: "Pikachu", imageName: "scribble")
        let banner3 = PokemonCatalogue(id: 3, title: "Cahrmander", imageName: "scribble")
        let banner4 = PokemonCatalogue(id: 1, title: "Pikachu", imageName: "scribble")
        let banner5 = PokemonCatalogue(id: 1, title: "BulbaZavr", imageName: "scribble")
        return [banner1, banner2, banner3, banner4, banner5]
    }
}
