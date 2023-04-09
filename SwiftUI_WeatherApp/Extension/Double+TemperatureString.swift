//
//  Double+TemperatureString.swift
//  SwiftUI_WeatherApp
//
//  Created by 이명진 on 2023/04/09.
//

import Foundation

fileprivate let formatter: MeasurementFormatter = {
    let f = MeasurementFormatter()
    f.numberFormatter.maximumFractionDigits = 0
    f.unitOptions = .temperatureWithoutUnit
    return f
}()

extension Double {
    var temperatureString: String {
        let temperature = Measurement<UnitTemperature>(value: self, unit: .celsius)
        return formatter.string(from: temperature)
    }
    
    static var randomTemperatureString: String {
        return Double.random(in: -10...30).temperatureString
    }
}
