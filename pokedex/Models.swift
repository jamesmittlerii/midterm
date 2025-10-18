/**

 * __Midterm Project__
 * Jim Mittler
 * 17 October 2025

 
This is the json data model
    
 _Italic text_
 __Bold text__
 ~~Strikethrough text~~

 */

import Foundation

// main structure is an array of pokemon

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
    // we do this for a little performance boost. id makes a pokemon unique
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// the evolution data structure
struct Evolution: Decodable, Hashable {
    let num: String
    let name: String
}
