//
//  Helper.swift
//  A small collection of quick helpers to avoid repeating the same old code.
//
//  Created by Paul Hudson on 23/06/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

/**

 * __Midterm Project__
 * Jim Mittler
 * 17 October 2025

 
Helper functions go here
    
 _Italic text_
 __Bold text__
 ~~Strikethrough text~~

 */

import UIKit
import SwiftUI

// this will import the json into a swift data structure
// not too bad, but nothing beats javascript for this

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        
        
        // load our pokemon json from the asset catalog 
    guard let dataAsset = NSDataAsset(name: file) else {
          fatalError("Failed to find data asset named '\(file)' in the asset catalog.")
       }
        let data = dataAsset.data
        
    
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}


// the urls in the json file are "http" but IOS complains if you don't provide HTTPS
// so we have a little function to swizzle the URL to HTTPS (thankfully that works)
private func normalizedHTTPS(from url: URL) -> URL {
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    if components?.scheme?.lowercased() == "http" {
        components?.scheme = "https"
    }
    return components?.url ?? url
}

/// A reusable SwiftUI view builder for loading remote images with placeholder/failure handling.
/// - Parameters:
///   - url: The remote image URL (will be normalized to https if needed).
///   - contentSize: Optional explicit size for the loaded image (applies a frame if provided).
///   - maxSize: Optional maximum size for the loaded image (applies a max frame if provided).
///   - placeholderSize: Size for the placeholder/failure boxes.
/// - Returns: A SwiftUI view rendering the async image.
@ViewBuilder
func RemoteAsyncImage(
    url: URL,
    contentSize: CGSize? = nil,
    maxSize: CGSize? = nil,
    placeholderSize: CGSize
) -> some View {
    
    // get an HTTPS url
    let imageURL = normalizedHTTPS(from: url)

    // load the image - quite easy but you have to deal with the phases because of async
    
    AsyncImage(url: imageURL) { phase in
        switch phase {
        case .empty:
            Group {
                ProgressView()
                    .frame(width: placeholderSize.width, height: placeholderSize.height)
            }
            .frame(maxWidth: maxSize?.width, maxHeight: maxSize?.height)
        case .success(let image):
            let base = image
                .resizable()
                .scaledToFit()

            Group {
                if let contentSize {
                    base
                        .frame(width: contentSize.width, height: contentSize.height)
                } else {
                    base
                }
            }
            .frame(maxWidth: maxSize?.width, maxHeight: maxSize?.height)
        case .failure:
            Group {
                Color.gray
                    .frame(width: placeholderSize.width, height: placeholderSize.height)
            }
            .frame(maxWidth: maxSize?.width, maxHeight: maxSize?.height)
        @unknown default:
            EmptyView()
        }
    }
}

// a couple of helper functions to size the images
// we were asked to make the detail image larger

/// Convenience for the 80x80 grid thumbnail.
@ViewBuilder
func PokemonGridImage(url: URL) -> some View {
    RemoteAsyncImage(
        url: url,
        contentSize: CGSize(width: 80, height: 80),
        placeholderSize: CGSize(width: 80, height: 80)
    )
}

/// Convenience for the detail image (up to 300x300, centered).
@ViewBuilder
func PokemonDetailImage(url: URL) -> some View {
    RemoteAsyncImage(
        url: url,
        maxSize: CGSize(width: 300, height: 300),
        placeholderSize: CGSize(width: 300, height: 300)
    )
}
