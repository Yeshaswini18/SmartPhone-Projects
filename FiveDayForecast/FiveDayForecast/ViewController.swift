//
//  ViewController.swift
//  FiveDayForecast
//
//  Created by Sankeerth V S on 3/15/21.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import PromiseKit

class ViewController: UIViewController, CLLocationManagerDelegate,UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var lblCurrTemp: UILabel!
    @IBOutlet weak var lblCurrCond: UILabel!
    @IBOutlet weak var imageCurrentCondition: UIImageView!
    
    @IBOutlet weak var tblForecast: UITableView!
    @IBOutlet weak var imageLow: UIImageView!
    @IBOutlet weak var imageHigh: UIImageView!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    let locationManager = CLLocationManager();
    
    var DailyForecastArr: [DailyForecast] = [DailyForecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tblForecast.delegate = self
        tblForecast.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DailyForecastArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.lblDay.text = " " + DailyForecastArr[indexPath.row].dayOfWeek
        cell.lblHigh.text = String(DailyForecastArr[indexPath.row].maximumTemp) + "°" + DailyForecastArr[indexPath.row].highUnit
        cell.lblLow.text = String(DailyForecastArr[indexPath.row].minimumTemp) + "°" + DailyForecastArr[indexPath.row].lowUnit
        cell.imageHigh.image = UIImage(named: DailyForecastArr[indexPath.row].highImage)
        cell.imageLow.image = UIImage(named: DailyForecastArr[indexPath.row].lowImage)
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currLocation = locations.last {
            let lat = currLocation.coordinate.latitude;
            let lng = currLocation.coordinate.longitude;
            
            let url = generateLocationURL(lat, lng)
            
            getLocationData(url)
            .done{
                (key, city) in
                self.lblCity.text = city
                let currentConditionURL = self.generateCurrentConditionURL(key)
                self.getCurrentCondition(currentConditionURL)
                let fiveDayForecastURL = self.generateFiveDayForecastURL(key)
                self.getTemperatures(fiveDayForecastURL)
            }
            .catch{ error in
                print("Error in getting the city \(error.localizedDescription)")
            }
            
        }
    }
    
    func getTemperatures(_ url: String) {
        getData(url)
            .done { (arr) in
                self.DailyForecastArr = [DailyForecast]()
                for DailyForecast in arr{
                    self.DailyForecastArr.append(DailyForecast)
                }
                self.lblLow.text = "L: \(self.DailyForecastArr[0].minimumTemp) °F"
                self.lblHigh.text = "H: \(self.DailyForecastArr[0].maximumTemp) °F"
                self.imageHigh.image = UIImage(named: self.DailyForecastArr[0].highImage)
                self.imageLow.image = UIImage(named: self.DailyForecastArr[0].lowImage)
                self.tblForecast.reloadData()
            }
            .catch { (error) in
                            print("Error in getting all the temperature values \(error)")
                        }
        
    }
    
    func getCurrentCondition(_ url: String) {
        getCurrentData(url)
            .done {
                (currentCondition, currentIcon, currentTemperature) in
                self.lblCurrTemp.text = String(currentTemperature) + "°F"
                self.lblCurrCond.text = currentCondition
                self.imageCurrentCondition.image = UIImage(named: currentIcon)
            }
            .catch{ error in
                print("Error in getting the Current Condition \(error.localizedDescription)")
            }
    }

}

// generating URLs
extension ViewController {
    
    func generateLocationURL(_ lat: CLLocationDegrees, _ lng: CLLocationDegrees) -> String{
        var url = locationURL
        url.append("?apikey=\(apiKey)")
        url.append("&q=\(lat),\(lng)")
        return url
    }
    
    func generateFiveDayForecastURL(_ cityKey: String) -> String{
        var url = foreCastURL
        url.append(cityKey)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
    func generateCurrentConditionURL(_ cityKey: String) -> String{
        var url = currTempURL
        url.append(cityKey)
        url.append("?apikey=\(apiKey)")
        return url
    }
    
}

//Promises
extension ViewController {
    
    func getLocationData(_ url: String) -> Promise<(String, String)> {
        
        return Promise<(String, String)> { seal -> Void in
            
            AF.request(url).responseJSON{ response in
                if response.error != nil {
                    seal.reject(response.error!)
                }
                let locationJSON: JSON = JSON(response.data as Any)
                let key = locationJSON["Key"].stringValue
                let city = locationJSON["LocalizedName"].stringValue
                seal.fulfill((key, city))
            }
        }
        
    }
    
    func getCurrentData(_ url: String) -> Promise<(String, String, Int)> {
        return Promise<(String, String, Int)> { seal -> Void in
            
            AF.request(url).responseJSON{response in
                if response.error != nil {
                    seal.reject(response.error!)
                }
                let currentConditionJSON: JSON = JSON(response.data as Any)
                let currentCondition = currentConditionJSON[0]["WeatherText"].stringValue
                let currentIcon = String(currentConditionJSON[0]["WeatherIcon"].intValue)
                let currentTemperature = currentConditionJSON[0]["Temperature"]["Imperial"]["Value"].intValue
                
                seal.fulfill((currentCondition, currentIcon, currentTemperature))
            }
            
        }
    }
    
    func getData(_ url: String) -> Promise<[DailyForecast]> {
        return Promise<[DailyForecast]> { seal -> Void in
            AF.request(url).responseJSON { response in
                if response.error == nil{
                    var arr = [DailyForecast]()
                    guard let data = response.data else{return seal.fulfill(arr)}
                    guard let temperatures = JSON(data)["DailyForecasts"].array else{return seal.fulfill(arr)}
                    
                    for temperature in temperatures {
                        let timeStamp = temperature["Date"].stringValue
                        let f = DateFormatter()
                        let dateFormatter = ISO8601DateFormatter()
                        let date = dateFormatter.date(from:timeStamp)!
                        let dayOfTheWeek = f.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
                        let minTemperature = temperature["Temperature"]["Minimum"]["Value"].intValue
                        let maxTemperature = temperature["Temperature"]["Maximum"]["Value"].intValue
                        let lowUnit = temperature["Temperature"]["Maximum"]["Unit"].stringValue
                        let highUnit = temperature["Temperature"]["Maximum"]["Unit"].stringValue
                        let highImage = String(temperature["Day"]["Icon"].intValue)
                        let lowImage = String(temperature["Night"]["Icon"].intValue)
                        
                        let data = DailyForecast(dayOfWeek: dayOfTheWeek, minimumTemp: minTemperature, maximumTemp: maxTemperature, highImage: highImage, lowImage: lowImage, lowUnit:lowUnit, highUnit:highUnit)
                        
                        data.dayOfWeek = dayOfTheWeek
                        data.minimumTemp = minTemperature
                        data.maximumTemp = maxTemperature
                        data.highImage = highImage
                        data.lowImage = lowImage
                        data.lowUnit = lowUnit
                        data.highUnit = highUnit
                        arr.append(data)
                    }
                    seal.fulfill(arr)
                                        
                }else {
                    seal.reject(response.error!)
                }
                
            }
            
        }
        
    }
    
}

