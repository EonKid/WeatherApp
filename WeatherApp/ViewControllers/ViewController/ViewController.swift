//
//  ViewController.swift
//  WeatherApp
//
//  Created by Narayan Singh, Dhruv on 14/05/21.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    //MARK: - Variables
    private let dataManager = DataManager()
    var resultSearchController: UISearchController!
    var currentCity = "Hyderabad"
    var currentWeatherData : WeatherData?

    //MARK: - IBOutlets
   
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    //MARK: - Helper methods
    
    func initialSetup(){
        if let city = Utility.shared.getObjectFromUserDefault(UserDefaultKeys.currentCity){
            self.currentCity = city
            self.fetchCurrentSavedWeather()
        }
        self.getWeatherData(self.currentCity)
    }
    
    func fetchCurrentSavedWeather(){
        do {
            let realm = try Realm()
            if let data = realm.object(ofType: WeatherData.self, forPrimaryKey: self.currentCity){
                self.currentWeatherData = data
                self.updateWeatherUI(data)
            }
        } catch  {
            Utility.shared.displayStatusCodeAlert("Failed to check user details")
        }
    }
   
    func getWeatherData(_ city: String){
        dataManager.weatherDataForLocation(city: city) { (responseData, error) in
            if let errorDetails = error {
                print("Error: \(errorDetails.localizedDescription)")
                DispatchQueue.main.async {
                    Utility.shared.displayStatusCodeAlert("Error: \(errorDetails.localizedDescription)")

                }
            
            }else{
                print("Response: \(responseData)")
                self.parseWeatherData(responseData)
            }
        }
    }
    
    func parseWeatherData(_ responseData: Dictionary<String, AnyObject>? ){
        var weatherModel = WeatherData()
        if let weatherData = responseData?["weather"] as? [Dictionary<String, AnyObject>]{
            if let details = weatherData[0] as? Dictionary<String, AnyObject> {
                if let name = details["name"] as? String{
                    weatherModel.city = name
                }
                if let weather = details["main"] as? String{
                    weatherModel.weather = weather
                }
                if let weatherDescription = details["description"] as? String{
                    weatherModel.weatherDescription = weatherDescription
                }
                if let icon = details["icon"] as? String{
                    weatherModel.icon = icon
                }
            }
            
         
            if let temperatureData = responseData?["main"] as? Dictionary<String, AnyObject>?{
                if let temperature = temperatureData?["temp"] as? Double{
                    weatherModel.temperature = temperature
                }
            }
            
            if let windDetails = responseData?["wind"] as?  Dictionary<String, AnyObject>?{
                if let windSpeed = windDetails?["speed"] as? Double{
                    weatherModel.windSpeed = windSpeed
                }
            }
            
            if let city = responseData?["name"] as? String{
                weatherModel.city = city
            }
            
            self.currentWeatherData = weatherModel
           
            self.updateWeatherUI(weatherModel)
            
            
        }
    }
    
    func updateWeatherUI(_ weatherData: WeatherData){
        DispatchQueue.main.async {
            self.cityLabel.text = weatherData.city
            self.mainLabel.text = weatherData.weather
            self.descriptionLabel.text = weatherData.weatherDescription
            self.temperatureLabel.text = String(format: "%.1f °C", weatherData.temperature.toCelcius())
            self.windSpeedLabel.text = String(format: "%.f KPH", weatherData.windSpeed.toKPH())
        }
        self.loadImageURL(weatherData)
    }
    
    func loadImageURL(_ weatherData: WeatherData){
        // Create URL
        let url = URL(string: API.imageIconBaseURL + "\(weatherData.icon)@2x.png")!

         DispatchQueue.global().async {
             // Fetch Image Data
             if let data = try? Data(contentsOf: url) {
                 DispatchQueue.main.async {
                     // Create Image and Update Image View
                     self.iconImageView.image = UIImage(data: data)
                 }
             }
         }
    }
    
    func checkAlreadyExistWeatherData(_ city: String) -> Bool{
         var isExists = false
        do {
            let realm = try Realm()
            if let data = realm.object(ofType: WeatherData.self, forPrimaryKey: city){
                if data.city == city {
                    isExists = true
                }
            }
        } catch  {
            Utility.shared.displayStatusCodeAlert("Failed to check user details")
        }
        return isExists
    }
    
    //MARK: - Actions
    
    @IBAction func btnActionSearchCity(_ sender: Any) {
        let searchControllerVC = Utility.shared.getUIStoryBoard(name: "Main").instantiateViewController(identifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        searchControllerVC.handleMapSearchDelegate = self
        self.navigationController?.pushViewController(searchControllerVC, animated: true)
    }
    
    @IBAction func btnActionRefresh(_ sender: Any) {
        self.getWeatherData(self.currentCity)
    }
    
    @IBAction func btnActionAddToFavorites(_ sender: Any) {
        
        if !self.checkAlreadyExistWeatherData(self.currentCity) {
            do {
                currentWeatherData?.isFavorite = true
                let realm = try Realm()
                try? realm.write {
                    realm.add(currentWeatherData!)
                }
            } catch  {
                debugPrint("Failed to add weather details")
                Utility.shared.displayStatusCodeAlert("Failed to add weather details")
            }
        } else {
            do {
                let realm = try Realm()
                try? realm.write {
                    currentWeatherData?.isFavorite = true
                }
            } catch  {
                debugPrint("Failed to update weather details")
                Utility.shared.displayStatusCodeAlert("Failed to to update weather  details")
            }
           
        }

    }
    
    @IBAction func barItemActionOpenFavorites(_ sender: Any) {
        
        let favoritesVC = Utility.shared.getUIStoryBoard(name: "Main").instantiateViewController(identifier: "BookmarkWeatherVC") as! BookmarkWeatherVC
        favoritesVC.bookmarkDelegate = self
        self.navigationController?.pushViewController(favoritesVC, animated: true)
        
    }
    
    
}

extension ViewController : HandleMapSearch {
    
    func selectedCity(city: String){
        print("Selected city: \(city)")
        self.currentCity = city
        Utility.shared.saveToUserDefault(UserDefaultKeys.currentCity, city)
        self.getWeatherData(currentCity)
        
    }
    
}

extension ViewController : BookmarkWeatherDelegate {
    func selectedWeatherData(_ weather: WeatherData) {
        self.updateWeatherUI(weather)
    }
    
    
    
    
}

