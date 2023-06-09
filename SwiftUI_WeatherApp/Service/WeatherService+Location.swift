//
//  WeatherService+Location.swift
//  SwiftUI_WeatherApp
//
//  Created by 이명진 on 2023/04/16.
//

import Foundation
import CoreLocation

extension WeatherService: CLLocationManagerDelegate {
    
    private func updateAddress(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "Ko_kr"))
        
        if let placemark = placemarks.first {
            if let gu = placemark.locality, let dong = placemark.subLocality {
                return "\(gu) \(dong)"
            } else {
                return placemark.name ?? "알 수 없음"
            }
        }
        
        return "알 수 없음"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            lastError = "위치 서비스 사용 권한을 확인할 수 없습니다."
        case .denied, .restricted:
            lastError = "위치 서비스 사용 권한이 없습니다."
        default:
            lastError = "알 수 없는 오류가 발생했습니다."
        }
    }
    
    private func process(location: CLLocation) {
        guard !isPreviewService else { return }
        
        Task {
            currentLocation = try await updateAddress(from: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            process(location: location)
        }
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        lastError = error.localizedDescription
    }
}
