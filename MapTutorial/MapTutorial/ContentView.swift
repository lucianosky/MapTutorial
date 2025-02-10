//
//  ContentView.swift
//  MapTutorial
//
//  Created by Luciano Sclovsky on 10/02/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PlaceViewModel()

    var body: some View {
        NavigationStack {
            TabView {
                AppleMapsView(viewModel: viewModel)
                    .tabItem {
                        Image(systemName: "apple.logo")
                        Text("Apple")
                    }
                
                GoogleMapsView(viewModel: viewModel)
                    .tabItem {
                        Image("google-maps")
                        Text("Google")
                    }
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Porto Alegre").font(.headline)
                }
            }
        }
    }
}
