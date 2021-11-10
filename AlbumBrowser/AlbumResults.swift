//
//  AlbumResults.swift
//  AlbumBrowser
//
//  Created by John Endres on 11/5/21.
//

import Foundation

// 1. the ObservableObject protocol is used with some sort of class that can store data
// 2. the @ObservedObject property wrapper is used inside a view to store an observable
//    object instance
// 3. the @Published property wrapper is added to any properties inside an observed object
//    that should cause views to update when they change.
// 4. @MainActor makes sure marked items happen on the main thread
class AlbumResults: ObservableObject {
    @Published private(set) var result: Result<[Album], Error> = .success([Album]())
    @Published private(set) var term = ""
    
    @MainActor
    func fetch(term: String = "Beatles") async {
        do {
            result = .success(try await fetchAlbums(term: term))
        } catch {
            result = .failure(error)
        }
    }
    
    internal func fetchAlbums(term: String) async throws -> [Album] {
        self.term = term
        
        let searchTerm = term.replacingOccurrences(of: " ", with: "+")
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&entity=album") else {
            return []
        }
        
        // Use the async variant of URLSession to fetch data
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let result = try decoder.decode(SearchResult.self, from: data)
        
        return result.results.sorted { left, right in
            left.collectionName < right.collectionName
        }
    }

}
