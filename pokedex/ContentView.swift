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
                                        PokemonGridImage(url: pokemon.img)

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

#Preview {
    ContentView()
}
