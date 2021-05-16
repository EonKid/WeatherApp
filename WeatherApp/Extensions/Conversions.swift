//
//  Conversions.swift
//  WeatherApp
//
//  Created by Narayan Singh, Dhruv on 15/05/21.
//

import Foundation

extension Double {

    func toCelcius() -> Double {
        return (self -  273.15)
    }

    func toKPH() -> Double {
        return (self * 3.6)
    }
    
}
