//
//  AlbumBrowserTests.swift
//  AlbumBrowserTests
//
//  Created by John Endres on 11/9/21.
//

import Combine
import XCTest
import Hippolyte
import SwiftUI
@testable import AlbumBrowser

class AlbumBrowserTests: XCTestCase {
//    @StateObject var subject = AlbumResults()
    
    var cancelable: AnyCancellable? = nil
    var data: Data {
        """
        {
          "resultCount": 1,
          "results": [
            {
              "wrapperType": "collection",
              "collectionType": "Album",
              "artistId": 487143,
              "collectionId": 1067444712,
              "amgArtistId": 76669,
              "artistName": "Pink Floyd",
              "collectionName": "A Foot In the Door: The Best of Pink Floyd",
              "collectionCensoredName": "A Foot In the Door: The Best of Pink Floyd",
              "artistViewUrl": "https://music.apple.com/us/artist/pink-floyd/487143?uo=4",
              "collectionViewUrl": "https://music.apple.com/us/album/a-foot-in-the-door-the-best-of-pink-floyd/1067444712?uo=4",
              "artworkUrl60": "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/88/2b/90/882b9089-e081-8c5e-6ce0-5a30285a56e9/source/60x60bb.jpg",
              "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/88/2b/90/882b9089-e081-8c5e-6ce0-5a30285a56e9/source/100x100bb.jpg",
              "collectionPrice": 11.99,
              "collectionExplicitness": "notExplicit",
              "trackCount": 17,
              "copyright": "℗ 2016 The copyright in this compilation is owned by Pink Floyd Music Ltd. / Pink Floyd (1987) Ltd., marketed and distributed by Sony Music Entertainment.",
              "country": "USA",
              "currency": "USD",
              "releaseDate": "2011-11-08T08:00:00Z",
              "primaryGenreName": "Rock"
            }
          ]
        }
        """
            .data(using: .utf8)!
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        var response = StubResponse()
        var request = StubRequest(method: .GET, url: URL(string: "https://itunes.apple.com/search?term=Pink+Floyd&entity=album")!)
        
        response.body = data
        request.response = response

        Hippolyte.shared.add(stubbedRequest: request)
        Hippolyte.shared.start()
        
//        subject = AlbumResults()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Hippolyte.shared.stop()
    }

    func testDataIsGood() throws {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let result = try decoder.decode(SearchResult.self, from: data)

        XCTAssertEqual(result.resultCount, 1)
    }

    func testFetchAlbums() async throws {
        let subject = await AlbumResults()
        let result = try await subject.fetchAlbums(term: "Pink Floyd")
        
        XCTAssertEqual(result.count, 1)
    }
    
    func testFetch() async throws {
        let subject = await AlbumResults()

        await subject.fetch(term: "Pink Floyd")
        
        switch await subject.result {
        case .success(let albums):
            XCTAssertEqual(albums.count, 1)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFetchPublisher() async throws {
        let subject = await AlbumResults()
        let changed = expectation(description: name)
        
        changed.expectedFulfillmentCount = 2
        
        cancelable = subject.objectWillChange.sink { something in
            changed.fulfill()
        }
        
        await subject.fetch(term: "Pink Floyd")
        await waitForExpectations(timeout: 1.0)

        let results = await subject.result

        switch results {
        case .success(let albums):
            XCTAssertEqual(albums.count, 1)
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
}
