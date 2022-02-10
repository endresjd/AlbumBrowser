//
//  Album.swift
//  AlbumBrowser
//
//  Created by John Endres on 11/5/21.
//

import Foundation
import BetterCodable

// MARK: - SearchResult
struct SearchResult: Codable {
    var resultCount: Int
    var results: [Album]
}

// MARK: - Album
struct Album: Codable {
    var wrapperType: String
    var collectionType: String
    var artistId: Int
    var collectionId: Int
    var amgArtistID: Int?
    var artistName: String
    var collectionName: String
    var collectionCensoredName: String
    var artistViewUrl: String?
    var collectionViewUrl: String
    var artworkUrl60: String
    var artworkUrl100: String
    var collectionPrice: Double?
    var collectionExplicitness: String
    var trackCount: Int
    var copyright: String
    var country: String
    var currency: String
    @DateValue<RFC3339Strategy> var releaseDate: Date
    var primaryGenreName: String
    var contentAdvisoryRating: String?
}
