/**
 
 * __Midterm Project__
 * Jim Mittler
 * 17 October 2025
 
 
 For this project I found a json containing a list of the original 151 Pokémon. The json contains the name, a url to the image and some basic details.
 
 Instead of loading each image into the asset catalog I decided to just load the images dynamically.
 
 The rest of the project was very similar to the food menu homework.
 
 There was a little extra data about what Pokémon evolve into what so I added that as an additional navigation link.
 
 This is the main grid view.
    
 _Italic text_
 __Bold text__
 ~~Strikethrough text~~
 
 */

import SwiftUI

struct ContentView: View {
    // our pokedex data structure
    
    @State private var pokedex: Pokedex?
    
    // we are going to allow filtering by type so store that
    @State private var selectedType: String? = nil
    
    // Adaptive grid: minimum item width, will flow to fit screen
    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 12)
    ]
    
   // get an array of types
    private var allTypes: [String] {
        guard let pokedex else { return [] }
        let set = Set(pokedex.pokemon.flatMap { $0.type })
        return set.sorted()
    }
    
    // Apply filtering based on selectedType
    private var filteredPokemon: [Pokemon] {
        guard let pokedex else { return [] }
        guard let selectedType else { return pokedex.pokemon } // All
        return pokedex.pokemon.filter { $0.type.contains(selectedType) }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                // we load the pokedex to start so I guess check if it's ok
                if let pokedex {
                    VStack(spacing: 8) {
                        // keep a drop down of types and add "All"
                        FilterControl(
                            allTypes: allTypes,
                            selectedType: Binding(
                                get: { selectedType ?? "All" },
                                set: { newValue in
                                    selectedType = (newValue == "All") ? nil : newValue
                                }
                            )
                        )
                        .padding(.horizontal, 12)
                        .padding(.top, 8)
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                // the foreach as requested to loop through our pokemon
                                ForEach(filteredPokemon) { pokemon in
                                    NavigationLink {
                                        // our nav sends us to the detail
                                        PokemonDetailView(pokemon: pokemon, allPokemon: pokedex.pokemon)
                                    } label: {
                                        VStack(spacing: 8) {
                                            
                                            // heres the image (small) via helper function
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
                    }
                } else {
                    ProgressView("Loading Pokédex…")
                }
            }
            .navigationTitle("Pokédex")
        }
        .onAppear {
            // load the json from the asset catalog onAppear
            let decoded: Pokedex = Bundle.main.decode(Pokedex.self, from: "pokedex")
            self.pokedex = decoded
        }
    }
}

// here's the dropdown list. Surprised there's so much code here
private struct FilterControl: View {
    let allTypes: [String]
    @Binding var selectedType: String // "All" or an actual type
    
    private var options: [String] {
        ["All"] + allTypes
    }
    
    var body: some View {
        
            // For a larger list, use a Menu to avoid crowding.
            HStack {
                Text("Type:")
                Menu {
                    Picker("Type", selection: $selectedType) {
                        ForEach(options, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedType)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Spacer()
            }
        
    }
}

// do a preview
#Preview {
    ContentView()
}
