//
//  ContentView.swift
//  pokedex
//
//  Created by cisstudent on 10/16/25.
//

import SwiftUI

struct ContentView: View {
    @State private var pokedex: Pokedex?

    // Adaptive grid: minimum item width, will flow to fit screen
    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if let pokedex {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(pokedex.pokemon) { pokemon in
                                NavigationLink {
                                    PokemonDetailView(pokemon: pokemon, allPokemon: pokedex.pokemon)
                                } label: {
                                    VStack(spacing: 8) {
                                        // Normalize URL to https if needed
                                        let imageURL: URL? = {
                                            var components = URLComponents(url: pokemon.img, resolvingAgainstBaseURL: false)
                                            if components?.scheme?.lowercased() == "http" {
                                                components?.scheme = "https"
                                            }
                                            return components?.url
                                        }()

                                        AsyncImage(url: imageURL) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 80, height: 80)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 80, height: 80)
                                            case .failure:
                                                Color.gray
                                                    .frame(width: 80, height: 80)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }

                                        Text(pokemon.name)
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .padding(10)
                                    .background(Color(.systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                                }
                                .buttonStyle(.plain) // keep our custom card look without link styling
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                } else {
                    ProgressView("Loading Pokédex…")
                }
            }
            .navigationTitle("Pokédex")
        }
        .onAppear {
            let decoded: Pokedex = Bundle.main.decode(Pokedex.self, from: "pokedex")
            self.pokedex = decoded
        }
    }
}

private struct PokemonDetailView: View {
    let pokemon: Pokemon
    let allPokemon: [Pokemon]

    // Build a lookup for quick resolution by 'num'
    private var pokemonByNum: [String: Pokemon] {
        Dictionary(uniqueKeysWithValues: allPokemon.map { ($0.num, $0) })
    }

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
                // Normalize URL to https if needed
                let imageURL: URL? = {
                    var components = URLComponents(url: pokemon.img, resolvingAgainstBaseURL: false)
                    if components?.scheme?.lowercased() == "http" {
                        components?.scheme = "https"
                    }
                    return components?.url
                }()

                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300, maxHeight: 300)
                            .frame(maxWidth: .infinity)
                    case .failure:
                        Color.gray
                            .frame(width: 300, height: 300)
                    @unknown default:
                        EmptyView()
                    }
                }

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
    ContentView()
}
