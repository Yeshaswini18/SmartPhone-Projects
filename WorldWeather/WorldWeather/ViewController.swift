//
//  ViewController.swift
//  WorldWeather
//
//  Created by Sankeerth V S on 3/5/21.
//

import UIKit
import CoreLocation
import SwiftSpinner
import SwiftyJSON
import Alamofire
import PromiseKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var DailyForecastArr: [DailyForecast] = [DailyForecast]()
    
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var tblWorldWeather: UITableView!
    
    let locationManager = CLLocationManager();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        tblWorldWeather.delegate = self
        tblWorldWeather.dataSource = self
        self.registerNib()
    }
    
    public func registerNib() {
        tblWorldWeather.register(UINib(nibName: TableViewCell.nibName, bundle: nil), forCellReuseIdentifier: TableViewCell.nibName)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DailyForecastArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
//        cell.lblDay.text = DailyForecastArr[indexPath.row].dayOfWeek
//        cell.lblLow.text = String(DailyForecastArr[indexPath.row].minimumTemp) + "°F"
//        cell.lblHigh.text = String(DailyForecastArr[indexPath.row].maximumTemp) + "°F"
        cell.setData(forecast: DailyForecastArr[indexPath.row])
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currLocation = locations.last{
            let lat = currLocation.coordinate.latitude;
            let lng = currLocation.coordinate.longitude;
            
            let url = generateLocationURL(lat, lng)
            
            getLocationData(url)
            .done{
                (key, city) in
                self.lblCity.text = city
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
                self.tblWorldWeather.reloadData()
            }
            .catch { (error) in
                            print("Error in getting all the temperature values \(error)")
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
                        
                        let data = DailyForecast(dayOfWeek: dayOfTheWeek, minimumTemp: minTemperature, maximumTemp: maxTemperature)
                        
                        data.dayOfWeek = dayOfTheWeek
                        data.minimumTemp = minTemperature
                        data.maximumTemp = maxTemperature
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

