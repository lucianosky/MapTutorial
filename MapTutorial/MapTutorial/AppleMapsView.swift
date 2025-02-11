//
//  AppleMapsView.swift
//  MapTutorial
//
//  Created by Luciano Sclovsky on 10/02/25.
//

import SwiftUI
import MapKit

struct AppleMapsView: View {
    @ObservedObject var viewModel: PlaceViewModel
    @State private var showSheet = false
    @State private var selectedPlaceName: String? = nil
    
    var body: some View {
        UIMapView(viewModel: viewModel, showSheet: $showSheet, selectedPlaceName: $selectedPlaceName)
            .sheet(isPresented: $showSheet, onDismiss: {
                selectedPlaceName = nil
            }) {
                VStack {
                    Text("Place Name")
                        .font(.headline)
                    Text(selectedPlaceName ?? "???")
                        .font(.title)
                        .padding()
                }
                .padding()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .onChange(of: selectedPlaceName, {
                if selectedPlaceName != nil {
                    showSheet = true
                }
            })
    }
}

struct UIMapView: UIViewRepresentable  {
    @ObservedObject var viewModel: PlaceViewModel
    @Binding var showSheet: Bool
    @Binding var selectedPlaceName: String?
    var locationManager = CLLocationManager()
    
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        
        let center = viewModel.mapCenter
        let delta = 0.09
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude),
            span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        )
        view.setRegion(region, animated: true)
        
        view.mapType = .standard
        view.showsUserLocation = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLHeadingFilterNone
        locationManager.startUpdatingLocation()
        
        for place in viewModel.places {
            let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let annotation = PlaceAnnotation(coordinate: coordinate, title: place.name)
            view.addAnnotation(annotation)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // map will not be updayed
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer(overlay: overlay)
        }
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    func onSelectedPlaceName(_ placeName: String?) {
        selectedPlaceName = placeName ?? "Unknown Place"
        DispatchQueue.main.async {
            showSheet = false
            showSheet = true
        }
    }
    
}

class MapCoordinator: NSObject, MKMapViewDelegate {
    var parent: UIMapView

    init(_ parent: UIMapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return UserMarkerView(annotation: annotation, reuseIdentifier: BaseMarkerView.reuseID)
        }
        guard let annotation = annotation as? PlaceAnnotation else { return nil }
        return PlaceMarkerView(annotation: annotation, reuseIdentifier: BaseMarkerView.reuseID)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PlaceAnnotation else { return  }
        if control == view.rightCalloutAccessoryView {
            DispatchQueue.main.async { [weak self] in
                self?.parent.onSelectedPlaceName(annotation.title)
            }
        }
    }
}

class PlaceAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
        super.init()
    }
}

class BaseMarkerView: MKMarkerAnnotationView {
    static let reuseID = "placeAnnotation"
    static let clusterID = "clustering"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clusteringIdentifier = BaseMarkerView.clusterID
        self.glyphTintColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.displayPriority = .defaultLow
     }
}

class PlaceMarkerView: BaseMarkerView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.glyphImage = UIImage(systemName: "location.fill")
        self.canShowCallout = true
        self.rightCalloutAccessoryView = UIButton(type: .infoLight)
        self.markerTintColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserMarkerView: BaseMarkerView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        if let coordinate = annotation?.coordinate {
            let userAnnotation = PlaceAnnotation(coordinate: coordinate, title: "My location")
            super.init(annotation: userAnnotation, reuseIdentifier: reuseIdentifier)
        } else {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        self.glyphImage = UIImage(systemName: "person.fill")
        self.canShowCallout = false
        self.markerTintColor = .blue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
