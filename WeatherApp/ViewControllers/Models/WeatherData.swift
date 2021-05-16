//
//  WeatherDetails.swift
//  WeatherApp
//
//  Created by Narayan Singh, Dhruv on 16/05/21.
//

import Foundation
import RealmSwift

class WeatherData : Object {
    
    @objc dynamic var windSpeed: Double = 0.0
    @objc dynamic var temperature: Double = 0.0

    @objc dynamic var icon: String = ""
    @objc dynamic var weatherDescription: String = ""
    @objc dynamic var city : String = ""
    @objc dynamic var weather : String = ""
    @objc dynamic var isFavorite : Bool = false
    
    override class func primaryKey() -> String? {
        return "city"
    }
    
}


