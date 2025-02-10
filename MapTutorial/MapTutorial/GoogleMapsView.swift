//
//  GoogleMapsView.swift
//  MapTutorial
//
//  Created by Luciano Sclovsky on 10/02/25.
//

import SwiftUI

struct GoogleMapsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Google Maps will be here.")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Google Maps").font(.headline)
                }
            }
        }
    }
}
