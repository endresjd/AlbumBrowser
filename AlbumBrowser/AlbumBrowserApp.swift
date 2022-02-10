//
//  AlbumBrowserApp.swift
//  AlbumBrowser
//
//  Created by John Endres on 11/5/21.
//

import SwiftUI

@main
struct AlbumBrowserApp: App {
    @StateObject var albums = AlbumResults()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(albums)
            }
        }
    }
}
