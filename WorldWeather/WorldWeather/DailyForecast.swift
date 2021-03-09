//
//  DailyForecast.swift
//  WorldWeather
//
//  Created by Sankeerth V S on 3/6/21.
//

import Foundation

class DailyForecast {
    var dayOfWeek: String = "";
    var minimumTemp: Int = 0;
    var maximumTemp: Int = 0;
    
    init(dayOfWeek: String, minimumTemp:Int, maximumTemp:Int){
        self.dayOfWeek = dayOfWeek;
        self.minimumTemp = minimumTemp;
        self.maximumTemp = maximumTemp;
    }
    
}
