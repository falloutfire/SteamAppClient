//
//  PokemonCollections.swift
//  Pokedex
//
//  Created by Ilya Manny on 26.09.2021.
//

import Foundation

struct PokemonCollections: Hashable {
    var id: Int
    var title: String
    var imageName: String
}

extension PokemonCollections {
    static func testData() -> [PokemonCollections] {
        let banner1 = PokemonCollections(id: 1, title: "BulbaZavr", imageName: "scribble")
        let banner2 = PokemonCollections(id: 2, title: "Pikachu", imageName: "scribble")
        let banner3 = PokemonCollections(id: 3, title: "Cahrmander", imageName: "scribble")
        let banner4 = PokemonCollections(id: 4, title: "Pikachu", imageName: "scribble")
        let banner5 = PokemonCollections(id: 5, title: "BulbaZavr", imageName: "scribble")
        return [banner1, banner2, banner3, banner4, banner5]
    }
}
