//
//  WeatherService.swift
//  SwiftUI_WeatherApp
//
//  Created by 이명진 on 2023/04/16.
//

import Foundation
import CoreLocation

class WeatherService: NSObject, ObservableObject {
    let locationManager: CLLocationManager
    
    @Published var currentLocation: String?
    @Published var currentWeather: CurrentWeather?
    @Published var forecastList: [Forecast]?
    
    @Published var lastError: String?
    
    let isPreviewService: Bool
    
    init(preview: Bool = false) {
        isPreviewService = preview
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        super.init()
        
        locationManager.delegate = self
    }
    
    static var preview: WeatherService {
        let service = WeatherService(preview: true)
        service.currentLocation = "강남역"
        service.currentWeather = CurrentWeather.preview
        service.forecastList = Forecast.preview
        
        return service
    }
}
