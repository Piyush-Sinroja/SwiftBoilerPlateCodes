//
//  MapViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/22/23.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var mapView: MKMapView!
    var location: CLLocation?
}

// MARK: View LifeCycle

extension MapViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

// MARK: - Private Methods

extension MapViewController {
    private func setUI() {
        self.title = "Map"
        // Setting Region
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        self.mapView.setRegion(region, animated: true)

        self.addPin()
    }

    private func addPin() {
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "My Location"
        self.mapView.addAnnotation(objectAnnotation)
    }
}
