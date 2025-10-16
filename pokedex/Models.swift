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

struct Pokemon: Decodable, Identifiable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case num
        case name
        case img
        case type
        case height
        case weight
        case candy
        case candyCount = "candy_count"
        case egg
        case spawnChance = "spawn_chance"
        case avgSpawns = "avg_spawns"
        case spawnTime = "spawn_time"
        case multipliers
        case weaknesses
        case prevEvolution = "prev_evolution"
        case nextEvolution = "next_evolution"
    }
}

struct Evolution: Decodable {
    let num: String
    let name: String
}
