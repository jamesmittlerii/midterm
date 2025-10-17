//
//  PokemonDetailView.swift
//  pokedex
//
//  Created by cisstudent on 10/16/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    let allPokemon: [Pokemon]

    // Build a lookup for quick resolution by 'num'
    private var pokemonByNum: [String: Pokemon] {
        Dictionary(uniqueKeysWithValues: allPokemon.map { ($0.num, $0) })
    }

    // which direction are we evolving
    private enum EvolutionDirection {
        case previous
        case next
    }

    // Choose one evolution based on direction rule
    private func selectedEvolution(for evolutions: [Evolution], direction: EvolutionDirection) -> Evolution? {
        switch direction {
        case .previous:
            // Highest-numbered previous evolution
            return evolutions.max { lhs, rhs in
                (Int(lhs.num) ?? Int.min) < (Int(rhs.num) ?? Int.min)
            }
        case .next:
            // Lowest-numbered next evolution
            return evolutions.min { lhs, rhs in
                (Int(lhs.num) ?? Int.max) < (Int(rhs.num) ?? Int.max)
            }
        }
    }

    // Renders a single navigation section for either previous or next
    @ViewBuilder
    private func evolutionSection(title: String, evolutions: [Evolution]?, direction: EvolutionDirection) -> some View {
        if let evolutions, !evolutions.isEmpty {
            let pick = selectedEvolution(for: evolutions, direction: direction)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)

                if let chosen = pick, let target = pokemonByNum[chosen.num] {
                    NavigationLink {
                        PokemonDetailView(pokemon: target, allPokemon: allPokemon)
                    } label: {
                        HStack {
                            Text("#\(chosen.num) \(chosen.name)")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    HStack {
                        Text("Unavailable")
                        Spacer()
                    }
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                }
            }
            .padding(.top, 8)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PokemonDetailImage(url: pokemon.img)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("#\(pokemon.num)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(pokemon.type.joined(separator: ", "))
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }

                    Divider()

                    // Basic details
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Height: \(pokemon.height)")
                        Text("Weight: \(pokemon.weight)")
                        Text("Egg: \(pokemon.egg)")
                        Text(String(format: "Spawn Chance: %.3f", pokemon.spawnChance))
                        Text(String(format: "Avg Spawns: %.1f", pokemon.avgSpawns))
                        Text("Spawn Time: \(pokemon.spawnTime)")
                        if let multipliers = pokemon.multipliers {
                            Text("Multipliers: \(multipliers.map { String(format: "%.2f", $0) }.joined(separator: ", "))")
                        }
                        Text("Weaknesses: \(pokemon.weaknesses.joined(separator: ", "))")
                    }
                    .font(.body)

                    // Evolution sections combined via helper
                    evolutionSection(title: "Previous Evolution", evolutions: pokemon.prevEvolution, direction: .previous)
                    evolutionSection(title: "Next Evolution", evolutions: pokemon.nextEvolution, direction: .next)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .padding(.top, 20)
        }
        .navigationTitle(pokemon.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PokemonDetailView(
        pokemon: Pokemon(
            id: 1,
            num: "001",
            name: "Bulbasaur",
            img: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!,
            type: ["Grass", "Poison"],
            height: "0.7 m",
            weight: "6.9 kg",
            candy: "Bulbasaur Candy",
            candyCount: 25,
            egg: "2 km",
            spawnChance: 0.69,
            avgSpawns: 69.0,
            spawnTime: "20:00",
            multipliers: [1.58],
            weaknesses: ["Fire", "Ice", "Flying", "Psychic"],
            prevEvolution: nil,
            nextEvolution: [Evolution(num: "002", name: "Ivysaur")]
        ),
        allPokemon: []
    )
}
