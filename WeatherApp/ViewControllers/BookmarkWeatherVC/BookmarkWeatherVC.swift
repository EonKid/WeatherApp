//
//  BookmarkWeatherVC.swift
//  WeatherApp
//
//  Created by Narayan Singh, Dhruv on 16/05/21.
//

import UIKit
import RealmSwift

protocol BookmarkWeatherDelegate : class {
    func selectedWeatherData(_ weather: WeatherData)
}

class BookmarkWeatherVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var weatherTableView: UITableView!
    
    //MARK: - Variables
    var weatherData :  List<WeatherData>?
    weak var bookmarkDelegate : BookmarkWeatherDelegate?

    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK: - Functions
    
    func setup(){
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Favorites"
        fetchData()
    }
    
    func fetchData(){
        do {
            let realm = try Realm()
            weatherData =  List<WeatherData>()
            
           
            let arrData = realm.objects(WeatherData.self).filter { (weather) -> Bool in
                    return weather.isFavorite
                }
                self.weatherData?.append(objectsIn: arrData)
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
                
             
        } catch let error as NSError {
            debugPrint("Failed to fetch user details \(error.description)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UITableViewController Delegate and DataSource
extension BookmarkWeatherVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailTableViewCell", for: indexPath) as! WeatherDetailTableViewCell
        if let weatherDetails = self.weatherData?[indexPath.row]{
            cell.cityLabel.text = weatherDetails.city
            cell.temperatureLabel.text = String(format: "%.1f °C", weatherDetails.temperature.toCelcius())
            cell.weather.text = weatherDetails.weather
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let weatherDetails = self.weatherData?[indexPath.row]{
            self.bookmarkDelegate?.selectedWeatherData(weatherDetails)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
