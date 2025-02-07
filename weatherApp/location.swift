//
//  location.swift
//  weatherApp
//
//  Created by MacBook on 2025-02-04.
//

import Foundation
import CoreLocation
import Observation
@Observable
class LocationManager : NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager ()
    private let geocoder = CLGeocoder()
    var location : CLLocation?
    var address: CLPlacemark?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
        
    }
    func reverseGeocodeLocation(_ location: CLLocation) {
           Task {
               let placemarks = try? await geocoder.reverseGeocodeLocation(location)
               address = placemarks?.last
           }
       }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            // This function will be called when the `authorizationStatus` is changed and you can react on it
        if locationManager.authorizationStatus != .denied {
                 locationManager.requestLocation()
             }
         
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        if let location{
            reverseGeocodeLocation( location)
        }
            // This function will be called when there is an updated location
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // Do something in case of error
        }
}
