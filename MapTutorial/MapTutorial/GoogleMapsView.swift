//
//  GoogleMapsView.swift
//  MapTutorial
//
//  Created by Luciano Sclovsky on 10/02/25.
//

import SwiftUI

struct GoogleMapsView: View {
    @ObservedObject var viewModel: PlaceViewModel

    var body: some View {
        VStack {
            Text("Google Maps view")
                .font(.title)
            Spacer()
            ForEach(viewModel.places, id: \.name) { place in
                Text(place.name)
            }
            Spacer()
        }
    }
}
