//
//  Models.swift
//  pokedex
//
//  Created by cisstudent on 10/16/25.
//

import Foundation

struct Pokedex: Decodable {
    let pokemon: [Pokemon]
}

struct Pokemon: Decodable, Identifiable, Hashable {
    let id: Int
    let num: String
    let name: String
    let img: URL
    let type: [String]
    let height: String
    let weight: String
    let candy: String
    let candyCount: Int?
    let egg: String
    let spawnChance: Double
    let avgSpawns: Double
    let spawnTime: String
    let multipliers: [Double]?
    let weaknesses: [String]
    let prevEvolution: [Evolution]?
    let nextEvolution: [Evolution]?

    

    // Hashable and Equatable based on stable unique id
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Evolution: Decodable, Hashable {
    let num: String
    let name: String
}
