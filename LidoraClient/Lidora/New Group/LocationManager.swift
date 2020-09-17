//
//  LocationManager.swift
//  Lidora
//
//  Created by Kerby Jean on 9/7/20.
//


import UIKit 
import CoreLocation

class LocationService: NSObject {
    
    var locationView: LocationView?

    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    
    func requestLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            displayLocationServicesDisabledAlert()
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        guard status != .denied else {
            displayLocationServicesDeniedAlert()
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func enableLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func disableLocationServices() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Authorized")
        case .denied, .restricted:
            print("Not Authorize")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let geocoder = CLGeocoder()
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,  completionHandler: {
                (placemarks, error) in
                    if error == nil {
                        if let firstLocation = placemarks?[0], let address = firstLocation.name, let postalCode = firstLocation.postalCode, let state = firstLocation.administrativeArea, let city = firstLocation.locality {
                            
                            print("ADDRESS: \(address) \(postalCode) \(state) \(city)")
                            
//                            DataService.shared.updateUserLocation(line1: address, postalCode: <#T##String#>, state: <#T##String#>)
                            self.locationView?.updateViews(address)
                        }
                    }
                })
            }
        disableLocationServices()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager did fail: ", error)
    }
}


extension LocationService {
    
    private func displayLocationServicesDisabledAlert() {
        let message = NSLocalizedString("LOCATION_SERVICES_DISABLED", comment: "Location services are disabled")
        let alertController = UIAlertController(title: NSLocalizedString("LOCATION_SERVICES_ALERT_TITLE", comment: "Location services alert title"),
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("BUTTON_OK", comment: "OK alert button"), style: .default, handler: nil))
        displayAlert(alertController)
    }
    
    private func displayLocationServicesDeniedAlert() {
        let message = NSLocalizedString("LOCATION_SERVICES_DENIED", comment: "Location services are denied")
        let alertController = UIAlertController(title: NSLocalizedString("LOCATION_SERVICES_ALERT_TITLE", comment: "Location services alert title"),
                                                message: message,
                                                preferredStyle: .alert)
        let settingsButtonTitle = NSLocalizedString("BUTTON_SETTINGS", comment: "Settings alert button")
        let openSettingsAction = UIAlertAction(title: settingsButtonTitle, style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                // Take the user to the Settings app to change permissions.
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelButtonTitle = NSLocalizedString("BUTTON_CANCEL", comment: "Location denied cancel button")
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(openSettingsAction)
        displayAlert(alertController)
    }
    
    private func displayAlert(_ controller: UIAlertController) {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
            fatalError("The key window did not have a root view controller")
        }
        viewController.present(controller, animated: true, completion: nil)
    }
}

