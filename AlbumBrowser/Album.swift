//
//  Album.swift
//  AlbumBrowser
//
//  Created by John Endres on 11/5/21.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    let resultCount: Int
    let results: [Album]
}

// MARK: - Album
struct Album: Codable {
    let wrapperType: String
    let collectionType: String
    let artistId: Int
    let collectionId: Int
    let amgArtistID: Int?
    let artistName: String
    let collectionName: String
    let collectionCensoredName: String
    let artistViewUrl: String?
    let collectionViewUrl: String
    let artworkUrl60: String
    let artworkUrl100: String
    let collectionPrice: Double?
    let collectionExplicitness: String
    let trackCount: Int
    let copyright: String
    let country: String
    let currency: String
    let releaseDate: Date
    let primaryGenreName: String
    let contentAdvisoryRating: String?
}
