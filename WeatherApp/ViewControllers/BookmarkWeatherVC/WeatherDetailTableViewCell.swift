//
//  WeatherDetailTableViewCell.swift
//  WeatherApp
//
//  Created by Narayan Singh, Dhruv on 15/05/21.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
