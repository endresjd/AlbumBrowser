//
//  ContentView.swift
//  AlbumBrowser
//
//  Created by John Endres on 11/5/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var albums: AlbumResults

    var body: some View {
        switch albums.result {
        case .success(let albumsArray):
            List(albumsArray, id: \.collectionId) { album in
                HStack {
                    AsyncImage(url: URL(string: album.artworkUrl100)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        ProgressView()
                    }
                        .frame(width: 100, height: 100)

                    Text(album.collectionName)
                }
                .onTapGesture {
                    if let url = URL(string: album.collectionViewUrl) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(albums.term)
            .task {
                await albums.fetch(term: "Pink Floyd")
            }
        case .failure(let error):
            Text(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(albums: AlbumResults())
        }
    }
}
