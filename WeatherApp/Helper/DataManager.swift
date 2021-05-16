//
//  DataManager.swift
//  WeatherApp
//
//  Created by Narayan Singh, Dhruv on 15/05/21.
//

import UIKit

import Foundation

enum DataManagerError: Error {

    case Unknown
    case FailedRequest
    case InvalidResponse

}

final class DataManager {

    typealias WeatherDataCompletion =  (Dictionary<String, AnyObject>?, DataManagerError?) -> ()

    // MARK: - Initialization

    init(){ }

    // MARK: - Requesting Data

    func weatherDataForLocation(city: String, completion: @escaping WeatherDataCompletion) {
       
        if Utility.shared.isReachable() {
            let queryItems = [URLQueryItem(name: "q", value: city), URLQueryItem(name: "appid", value: "\(API.API_KEY)")]
            var urlComps = URLComponents(string:API.baseURL)!
            urlComps.queryItems = queryItems
            if let weahterApi = urlComps.url {
                URLSession.shared.dataTask(with: weahterApi) { (data, response, error) in
                    self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
                    }.resume()
            }
        }else{
            Utility.shared.openSettingApp()
        }
        
    }

    // MARK: - Helper Methods

    private func didFetchWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: WeatherDataCompletion) {
    
        if let _ = error {
            completion(nil, .FailedRequest)

        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processWeatherData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }

        } else {
            completion(nil, .Unknown)
        }
    }

    private func processWeatherData(data: Data, completion: WeatherDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject> {
            completion( JSON, nil)
        } else {
            completion( nil, .InvalidResponse)
        }
    }

}

import Foundation

protocol JSONDecodable {

    init?(JSON: Any)

}

