//
//  PlaceViewModel.swift
//  MapTutorial
//
//  Created by Luciano Sclovsky on 10/02/25.
//

import Foundation

class PlaceViewModel: ObservableObject {
    @Published var places: [Place] = [
        Place(latitude: -30.06537, longitude: -51.23592, name: "Estádio Beira-Rio"),
        Place(latitude: -29.97383, longitude: -51.19493, name: "Arena do Grêmio"),
        Place(latitude: -30.02697, longitude: -51.22795, name: "Mercado Público"),
    ]
    @Published var mapCenter = Place(latitude: -30.03297, longitude: -51.20248, name: "")
}
