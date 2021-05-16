//
//  LocationSearchTableViewController.swift
//  WeatherApp
//
//  Created by Narayan Singh, Dhruv on 15/05/21.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func selectedCity(city: String)
}

class LocationSearchTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems: [MKMapItem] = []
    var searchController: UISearchController!

   override func viewDidLoad() {
       super.viewDidLoad()
       self.setup()
   }
    
    func setup(){
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
       tableView.dataSource = self
       tableView.delegate = self
       tableView.estimatedRowHeight = 71
    
       searchController = UISearchController(searchResultsController: nil)
       searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search city"
       
       searchController.dimsBackgroundDuringPresentation = false

       searchController.searchBar.sizeToFit()
       tableView.tableHeaderView = searchController.searchBar

       definesPresentationContext = true
    }
    
    
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
                            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
                    (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
                            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
    func getAddress(_ address: MKMapItem) -> String{
        var details = ""
        if let locality = address.placemark.locality{
            details = details + locality
        }
        if let administrativeArea = address.placemark.administrativeArea{
            details = details + ", \(administrativeArea)"
        }
        if let country = address.placemark.country{
            details = details + ", \(country)"
        }
        if let zipcode = address.placemark.postalCode{
            details = details + ", \(zipcode)"
        }
        return details
    }


 
    
}

extension LocationSearchTableViewController : UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let address = self.matchingItems[indexPath.row]
        var details = ""
        if let locality = address.placemark.locality{
            details = details + locality
        }
        handleMapSearchDelegate?.selectedCity(city: details)
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension LocationSearchTableViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loationSearchCell") as! LocationSearchTableViewCell
        let address = self.matchingItems[indexPath.row]
        cell.city.text = self.getAddress(address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
}


//MARK: - UISearchBarController Delegate
extension LocationSearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        debugPrint(searchBarText)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
        
    }
    
    
}


