//
//  LocationViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/21/23.
//

import CoreLocation
import UIKit

class LocationViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: LocationViewModel = .init()
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var getCurrentLocationButton: ReusableButton! {
        didSet {
            getCurrentLocationButton.viewModel = ReusableButtonViewModel(
                title: "Get Current Location",
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 8,
                font: .openSans(of: 16, in: .semiBold)
            )
            getCurrentLocationButton.tapped = { [weak self] in
                self?.getCurrentLocationButtonAction()
            }
        }
    }
    
    @IBOutlet var getCurrentAddressButton: ReusableButton! {
        didSet {
            getCurrentAddressButton.viewModel = ReusableButtonViewModel(
                title: "Get Current Address",
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 8,
                font: .openSans(of: 16, in: .semiBold)
            )
            getCurrentAddressButton.tapped = { [weak self] in
                self?.getCurrentAddressButtonAction()
            }
        }
    }
    
    @IBOutlet var showCurrentLocationOnMapButton: ReusableButton! {
        didSet {
            showCurrentLocationOnMapButton.viewModel = ReusableButtonViewModel(
                title: "Show Current Location on Map",
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 8,
                font: .openSans(of: 16, in: .semiBold)
            )
            showCurrentLocationOnMapButton.tapped = { [weak self] in
                self?.showCurrentLocationOnMapButtonAction()
            }
        }
    }

    @IBOutlet var locationServiceEnableButton: ReusableButton! {
        didSet {
            locationServiceEnableButton.viewModel = ReusableButtonViewModel(
                title: "Location Service Enable?",
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 8,
                font: .openSans(of: 16, in: .semiBold)
            )
            locationServiceEnableButton.tapped = { [weak self] in
                self?.locationServiceEnableButtonAction()
            }
        }
    }
    
    var name: String? = nil
}

// MARK: - View Life Cycle

extension LocationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = name
        resetLabels()
    }
    
    private func resetLabels() {
        self.latitudeLabel.text = "Latitude:"
        self.longitudeLabel.text = "Longitude:"
        self.addressLabel.text = "Address:"
    }
}

// MARK: Button Actions
extension LocationViewController {
    func getCurrentLocationButtonAction() {
        resetLabels()
        
        viewModel.getCurrentLocations { [weak self] location, error in
            if let error = error {
                self?.showAlert(andMessage: error.localizedDescription)
                return
            }
            
            guard let location = location else {
                self?.showAlert(andMessage: "Unable to fetch location")
                return
            }
            self?.latitudeLabel.text = "Latitude: \(location.coordinate.latitude)"
            self?.longitudeLabel.text = "Longitude: \(location.coordinate.longitude)"
        }
        
    }
    
    func getCurrentAddressButtonAction() {
        resetLabels()
        
        viewModel.getCurrentAddress { [weak self] location, placemark, error in
            if let error {
                self?.showAlert(andMessage: error.localizedDescription)
                return
            }
            
            guard let location,
                  let placemark
            else {
                return
            }
            print(placemark.administrativeArea ?? "")
            print(placemark.name ?? "")
            print(placemark.country ?? "")
            print(placemark.areasOfInterest ?? "")
            print(placemark.isoCountryCode ?? "")
            print(placemark.location ?? "")
            print(placemark.locality ?? "")
            print(placemark.subLocality ?? "")
            print(placemark.postalCode ?? "")
            print(placemark.timeZone ?? "")
            
            self?.addressLabel.text = "The address fetched is: \n\n" + placemark.description
            
            self?.latitudeLabel.text = "Latitude: \(location.coordinate.latitude)"
            self?.longitudeLabel.text = "Longitude: \(location.coordinate.longitude)"
        }
    }
    
    func showCurrentLocationOnMapButtonAction() {
        resetLabels()
        
        viewModel.displayLocationOnMap {  [weak self] location, error in
            
            if let error = error {
                self?.showAlert(andMessage: error.localizedDescription)
                return
            }
            
            guard let location = location else {
                return
            }
            self?.goToMapScreen(location: location)
        }
    }
    
    private func locationServiceEnableButtonAction() {
        viewModel.locationServiceEnable { [weak self] locationMessage in
            self?.showAlert(andMessage: locationMessage ?? "")
        }
    }
    
    private func goToMapScreen(location: CLLocation) {
        let vc: MapViewController = MapViewController.instantiate(appStoryboard: .locations)
        vc.location = location
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
