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
    @State private var pokedex: Pokedex?

    // Adaptive grid: minimum item width, will flow to fit screen
    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            Group {
                // we load the pokedex to start so I guess check if it's ok
                if let pokedex {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            // the foreach as requested to loop through our pokemon
                            ForEach(pokedex.pokemon) { pokemon in
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

// do a preview
#Preview {
    ContentView()
}
