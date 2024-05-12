//
//  LocationManager.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/22/23.
//

import MapKit
import UIKit

final class LocationManager: NSObject {
    enum LocationErrors: String {
        case denied = "Locations are turned off. Please turn it on in Settings"
        case restricted = "Locations are restricted"
        case notDetermined = "Locations are not determined yet"
        case notFetched = "Unable to fetch location"
        case invalidLocation = "Invalid Location"
        case reverseGeocodingFailed = "Reverse Geocoding Failed"
        case unknown = "Some Unknown Error occurred"
    }
    
    // Singleton Instance
    static let shared: LocationManager = {
        let instance = LocationManager()
        // setup code
        return instance
    }()
    
    override private init() {}
    
    private var locationManager = CLLocationManager()
    
    typealias LocationClosure = (_ location: CLLocation?, _ error: NSError?) -> Void
    private var locationCompletionHandler: LocationClosure?
    
    typealias ReverseGeoLocationClosure = (_ location: CLLocation?, _ placemark: CLPlacemark?, _ error: NSError?) -> Void
    private var geoLocationCompletionHandler: ReverseGeoLocationClosure?
        
    var locationAccuracy = kCLLocationAccuracyBest
    private var lastLocation: CLLocation?
    private var reverseGeocoding = false

    // MARK: - Dinitalizer

    deinit {
        locationManager.delegate = nil
        lastLocation = nil
    }
    
    // MARK: - Private Methods

    private func setupLocationManager() {
        // Setting of location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = locationAccuracy
        if #available(iOS 14.0, *) {
            self.check(status: locationManager.authorizationStatus)
        } else {
            self.check(status: CLLocationManager.authorizationStatus())
        }
    }
          
    @objc private func sendPlacemark() {
        if lastLocation == nil {
            self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                domain: self.classForCoder.description(),
                code: Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey: LocationErrors.notFetched.rawValue,
                 NSLocalizedFailureReasonErrorKey: LocationErrors.notFetched.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey: LocationErrors.notFetched.rawValue]))
                        
            lastLocation = nil
            return
        }
        
        self.reverseGeoCoding(location: lastLocation)
        lastLocation = nil
    }
    
    @objc private func sendLocation() {
        if lastLocation == nil {
            self.didComplete(location: nil, error: NSError(
                domain: self.classForCoder.description(),
                code: Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey: LocationErrors.notFetched.rawValue,
                 NSLocalizedFailureReasonErrorKey: LocationErrors.notFetched.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey: LocationErrors.notFetched.rawValue]))
            lastLocation = nil
            return
        }
        self.didComplete(location: lastLocation, error: nil)
        lastLocation = nil
    }
    
    // MARK: - Public Methods
    
    /// Check if location is enabled on device or not
    ///
    /// - Parameter completionHandler: nil
    /// - Returns: Bool
    func isLocationEnabled() async -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    /// Get current location
    ///
    /// - Parameter completionHandler: will return CLLocation object which is the current location of the user and NSError in case of error
    func getLocation(completionHandler: @escaping LocationClosure) {
        // Resetting last location
        lastLocation = nil
        
        self.locationCompletionHandler = completionHandler
        
        setupLocationManager()
    }
        
    /// Get Reverse Geocoded Placemark address by passing CLLocation
    ///
    /// - Parameters:
    ///   - location: location Passed which is a CLLocation object
    ///   - completionHandler: will return CLLocation object and CLPlacemark of the CLLocation and NSError in case of error
    func getReverseGeoCodedLocation(location: CLLocation, completionHandler: @escaping ReverseGeoLocationClosure) {
        self.geoLocationCompletionHandler = nil
        self.geoLocationCompletionHandler = completionHandler
        if !reverseGeocoding {
            reverseGeocoding = true
            self.reverseGeoCoding(location: location)
        }
    }
    
    /// Get Latitude and Longitude of the address as CLLocation object
    ///
    /// - Parameters:
    ///   - address: address given by the user in String
    ///   - completionHandler: will return CLLocation object and CLPlacemark of the address entered and NSError in case of error
    func getReverseGeoCodedLocation(address: String, completionHandler: @escaping ReverseGeoLocationClosure) {
        self.geoLocationCompletionHandler = nil
        self.geoLocationCompletionHandler = completionHandler
        if !reverseGeocoding {
            reverseGeocoding = true
            self.reverseGeoCoding(address: address)
        }
    }
    
    /// Get current location with placemark
    ///
    /// - Parameter completionHandler: will return Location,Placemark and error
    func getCurrentReverseGeoCodedLocation(completionHandler: @escaping ReverseGeoLocationClosure) {
        if !reverseGeocoding {
            reverseGeocoding = true
            
            // Resetting last location
            lastLocation = nil
            
            self.geoLocationCompletionHandler = completionHandler
            
            setupLocationManager()
        }
    }

    // MARK: - Reverse GeoCoding

    private func reverseGeoCoding(location: CLLocation?) {
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: { placemarks, error in
            if error != nil {
                // Reverse geocoding failed
                self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                    domain: self.classForCoder.description(),
                    code: Int(CLAuthorizationStatus.denied.rawValue),
                    userInfo:
                    [NSLocalizedDescriptionKey: LocationErrors.reverseGeocodingFailed.rawValue,
                     NSLocalizedFailureReasonErrorKey: LocationErrors.reverseGeocodingFailed.rawValue,
                     NSLocalizedRecoverySuggestionErrorKey: LocationErrors.reverseGeocodingFailed.rawValue]))
                return
            }
            if !placemarks!.isEmpty {
                let placemark = placemarks![0]
                if location != nil {
                    self.didCompleteGeocoding(location: location, placemark: placemark, error: nil)
                } else {
                    self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                        domain: self.classForCoder.description(),
                        code: Int(CLAuthorizationStatus.denied.rawValue),
                        userInfo:
                        [NSLocalizedDescriptionKey: LocationErrors.invalidLocation.rawValue,
                         NSLocalizedFailureReasonErrorKey: LocationErrors.invalidLocation.rawValue,
                         NSLocalizedRecoverySuggestionErrorKey: LocationErrors.invalidLocation.rawValue]))
                }
                if !CLGeocoder().isGeocoding {
                    CLGeocoder().cancelGeocode()
                }
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    private func reverseGeoCoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { placemarks, error in
            if error != nil {
                // Reverse geocoding failed
                self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                    domain: self.classForCoder.description(),
                    code: Int(CLAuthorizationStatus.denied.rawValue),
                    userInfo:
                    [NSLocalizedDescriptionKey: LocationErrors.reverseGeocodingFailed.rawValue,
                     NSLocalizedFailureReasonErrorKey: LocationErrors.reverseGeocodingFailed.rawValue,
                     NSLocalizedRecoverySuggestionErrorKey: LocationErrors.reverseGeocodingFailed.rawValue]))
                return
            }
            if !placemarks!.isEmpty {
                if let placemark = placemarks?[0] {
                    self.didCompleteGeocoding(location: placemark.location, placemark: placemark, error: nil)
                } else {
                    self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                        domain: self.classForCoder.description(),
                        code: Int(CLAuthorizationStatus.denied.rawValue),
                        userInfo:
                        [NSLocalizedDescriptionKey: LocationErrors.invalidLocation.rawValue,
                         NSLocalizedFailureReasonErrorKey: LocationErrors.invalidLocation.rawValue,
                         NSLocalizedRecoverySuggestionErrorKey: LocationErrors.invalidLocation.rawValue]))
                }
                if !CLGeocoder().isGeocoding {
                    CLGeocoder().cancelGeocode()
                }
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
       
    // MARK: - Final closure/callback

    private func didComplete(location: CLLocation?, error: NSError?) {
        locationManager.stopUpdatingLocation()
        locationCompletionHandler?(location, error)
        locationManager.delegate = nil
    }
    
    private func didCompleteGeocoding(location: CLLocation?, placemark: CLPlacemark?, error: NSError?) {
        locationManager.stopUpdatingLocation()
        geoLocationCompletionHandler?(location, placemark, error)
        locationManager.delegate = nil
        reverseGeocoding = false
    }
    
    private func check(status: CLAuthorizationStatus?) {
        guard let status = status else { return }
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            
        case .denied:
            let deniedError = NSError(
                domain: self.classForCoder.description(),
                code: Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey: LocationErrors.denied.rawValue,
                 NSLocalizedFailureReasonErrorKey: LocationErrors.denied.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey: LocationErrors.denied.rawValue])
            
            if reverseGeocoding {
                didCompleteGeocoding(location: nil, placemark: nil, error: deniedError)
            } else {
                didComplete(location: nil, error: deniedError)
            }
            
        case .restricted:
            if reverseGeocoding {
                didComplete(location: nil, error: NSError(
                    domain: self.classForCoder.description(),
                    code: Int(CLAuthorizationStatus.restricted.rawValue),
                    userInfo: nil))
            } else {
                didComplete(location: nil, error: NSError(
                    domain: self.classForCoder.description(),
                    code: Int(CLAuthorizationStatus.restricted.rawValue),
                    userInfo: nil))
            }
            
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            didComplete(location: nil, error: NSError(
                domain: self.classForCoder.description(),
                code: Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey: LocationErrors.unknown.rawValue,
                 NSLocalizedFailureReasonErrorKey: LocationErrors.unknown.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey: LocationErrors.unknown.rawValue]))
        }
    }
}

// MARK: - CLLocationManager Delegates

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
        if let location = locations.last {
            let locationAge = -(location.timestamp.timeIntervalSinceNow)
            if locationAge > 5.0 {
                print("old location \(location)")
                return
            }
            if location.horizontalAccuracy < 0 {
                self.locationManager.stopUpdatingLocation()
                self.locationManager.startUpdatingLocation()
                return
            }
            if self.reverseGeocoding {
                self.sendPlacemark()
            } else {
                self.sendLocation()
            }
        }
    }
       
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.check(status: status)
    }
       
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        self.didComplete(location: nil, error: error as NSError?)
    }
}
