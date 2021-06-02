
import UIKit
import BFKit
import Contacts
import CoreLocation

/// 定位管理
public class RxLocateKit: NSObject {
    
    public var currentLocation: CLLocation?
    public var modelLocation: RxModelLocation?
    public var isLocationBackstage: Bool = false
    public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return self.manager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    public var locationManager: CLLocationManager {
        return self.manager
    }
    public var onAuthorizationStatus: ((_ status: CLAuthorizationStatus) -> Void)?
    public var onLocationUpdateCallBack: ((_ locations: [CLLocation]) -> Void)?
    public var onLocationError: ((_ error: Error?) -> Void)?
    public var onReverseGeocodeError: ((_ error: Error?) -> Void)?
    public var onReverseGeocodeSuccess: ((_ model: RxModelLocation?) -> Void)?
    
    public static let shared = RxLocateKit()
    
    public var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    private lazy var manager: CLLocationManager = {
        let item = CLLocationManager()
        item.distanceFilter = 1000
        item.desiredAccuracy = kCLLocationAccuracyBest
        return item
    }()
    public override init() {
        super.init()
        self.manager.delegate = self
    }
    deinit {
        self.manager.stopUpdatingLocation()
        self.manager.delegate = nil
    }
    private func reverseGeocodeLocation() {
        guard let location = self.currentLocation else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let `self` = self else { return }
            guard let marks = placemarks else { return }
            if #available(iOS 11.0, *) {
                if let placemark = marks.first {
                    BFLog.debug("reverseGeocodeLocation: \(placemark)")
                    self.modelLocation = RxModelLocation.init()
                    self.modelLocation?.latitude = placemark.location?.coordinate.latitude ?? 0
                    self.modelLocation?.longitude = placemark.location?.coordinate.longitude ?? 0
                    self.modelLocation?.country = placemark.country ?? ""
                    self.modelLocation?.city = placemark.locality ?? ""
                    self.modelLocation?.state = placemark.thoroughfare ?? ""
                    self.modelLocation?.area = placemark.subLocality ?? ""
                    self.modelLocation?.street = placemark.country ?? ""
                    self.modelLocation?.countryCode = placemark.isoCountryCode ?? ""
                    self.modelLocation?.countryNunber = placemark.subThoroughfare ?? ""
                    self.modelLocation?.postalCode = placemark.postalCode ?? ""
                    self.modelLocation?.address = placemark.name ?? ""
                    self.modelLocation?.addressLines = placemark.areasOfInterest
                    self.modelLocation?.addressDictionary = placemark.addressDictionary
                    
                    self.onReverseGeocodeSuccess?(self.modelLocation)
                } else {
                    self.onReverseGeocodeError?(error)
                }
            } else {
                if let placemark = marks.first, let address = placemark.addressDictionary {
                    BFLog.debug("reverseGeocodeLocation: \(address)")
                    self.modelLocation = RxModelLocation.init()
                    self.modelLocation?.latitude = placemark.location?.coordinate.latitude ?? 0
                    self.modelLocation?.longitude = placemark.location?.coordinate.longitude ?? 0
                    self.modelLocation?.country = (address["Country"] as? String) ?? ""
                    self.modelLocation?.city = (address["City"] as? String) ?? ""
                    self.modelLocation?.state = (address["State"] as? String) ?? ""
                    self.modelLocation?.area = (address["SubLocality"] as? String) ?? ""
                    self.modelLocation?.street = (address["Street"] as? String) ?? ""
                    self.modelLocation?.thoroughfare = (address["Thoroughfare"] as? String) ?? ""
                    self.modelLocation?.countryCode = (address["CountryCode"] as? String) ?? ""
                    self.modelLocation?.postalCode = (address["PostalCode"] as? String) ?? (address["postalCode"] as? String) ?? ""
                    self.modelLocation?.address = (address["Name"] as? String) ?? ""
                    self.modelLocation?.addressLines = (address["FormattedAddressLines"] as? [String])
                    self.modelLocation?.addressDictionary = address
                    
                    self.onReverseGeocodeSuccess?(self.modelLocation)
                } else {
                    self.onReverseGeocodeError?(error)
                }
            }
        }
    }
}
extension RxLocateKit: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        BFLog.debug("didChangeAuthorization: \(status)")
        self.onAuthorizationStatus?(status)
    }
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        BFLog.debug("didUpdateLocations: \(locations.last)")
        self.currentLocation = locations.last
        self.onLocationUpdateCallBack?(locations)
        if !self.isLocationBackstage {
            manager.stopUpdatingLocation()
        }
        self.reverseGeocodeLocation()
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        BFLog.debug("didFailWithError: \(error)")
        self.onLocationError?(error)
    }
}
