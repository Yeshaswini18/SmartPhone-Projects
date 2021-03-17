//
//  DailyForeCast.swift
//  FiveDayForecast
//
//  Created by Sankeerth V S on 3/16/21.
//

import Foundation


class DailyForecast {
    var dayOfWeek: String = "";
    var minimumTemp: Int = 0;
    var maximumTemp: Int = 0;
    var highImage: String = "";
    var lowImage: String = "";
    var lowUnit: String = "";
    var highUnit: String = "";
    
    init(dayOfWeek: String, minimumTemp:Int, maximumTemp:Int, highImage: String, lowImage:String, lowUnit:String, highUnit:String){
        self.dayOfWeek = dayOfWeek;
        self.minimumTemp = minimumTemp;
        self.maximumTemp = maximumTemp;
        self.highImage = highImage;
        self.lowImage = lowImage;
        self.highUnit = highUnit;
        self.lowUnit = lowUnit;
    }
    
}
