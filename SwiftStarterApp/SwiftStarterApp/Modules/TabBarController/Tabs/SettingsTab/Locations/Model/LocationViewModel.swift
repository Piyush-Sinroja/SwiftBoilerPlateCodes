//
//  LocationViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/23/23.
//

import AVFAudio
import CoreLocation
import Foundation

class LocationViewModel {
    // MARK: - Properties

    typealias LocationClosure = (_ location: CLLocation?, _ error: NSError?) -> Void
    typealias ReverseGeoLocationClosure = (_ location: CLLocation?, _ placemark: CLPlacemark?, _ error: NSError?) -> Void
    typealias LocationEnaleMessage = (_ locationMessage: String?) -> Void
}

extension LocationViewModel {
    // MARK: - GET CURRENT LOCATION
    
    func getCurrentLocations(completionHandler: @escaping LocationClosure) {
        LocationManager.shared.getLocation { location, error in
            completionHandler(location, error)
        }
    }
    
    // MARK: - GET CURRENT ADDRESS

    func getCurrentAddress(completionHandler: @escaping ReverseGeoLocationClosure) {
        LocationManager.shared.getCurrentReverseGeoCodedLocation { location, placemark, error in
            completionHandler(location, placemark, error)
        }
    }
       
    // MARK: - DISOPLAY LOCATION ON MAP

    func displayLocationOnMap(completionHandler: @escaping LocationClosure) {
        LocationManager.shared.getLocation { location, error in
            completionHandler(location, error)
        }
    }
    
    // MARK: - LOCATION SERVICE ENABLE OR DISABLE

    func locationServiceEnable(completionHandler: @escaping LocationEnaleMessage) {
        Task {
            if await LocationManager.shared.isLocationEnabled() {
                completionHandler("Location Services are enabled")
            } else {
                completionHandler("Location Services are disabled")
            }
        }
    }
}
