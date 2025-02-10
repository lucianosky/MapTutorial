//
//  ContentView.swift
//  MapTutorial
//
//  Created by Luciano Sclovsky on 10/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AppleMapsView()
                .tabItem {
                    Image(systemName: "apple.logo")
                    Text("Apple")
                }

            GoogleMapsView()
                .tabItem {
                    Image("google-maps")
                    Text("Google")
                }
        }
    }
}
