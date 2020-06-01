//
//  WeatherWeekItemCell.swift
//  TestWeather
//
//  Created by Mephrine on 2020/05/29.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import UIKit

class WeatherWeekItemCell: BaseTableViewCell {
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbHighTemp: UILabel!
    @IBOutlet weak var lbLowTemp: UILabel!
    @IBOutlet weak var ivIcon: UIImageView!
    
    func configuration(item: WeatherWeekModel) {
        self.lbDay.text = item.day
        self.lbHighTemp.text = item.highTemp
        self.lbLowTemp.text = item.lowTemp
        self.ivIcon.imageFromURL(strURL: item.icon, contentMode: UIView.ContentMode.scaleAspectFill)
    }
}

