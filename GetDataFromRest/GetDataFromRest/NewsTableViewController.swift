//
//  NewsTableViewController.swift
//  GetDataFromRest
//
//  Created by Sankeerth V S on 2/23/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class NewsTableViewController: UITableViewController {
    
    //let arr = ["Yesh", "Yeshaswini", "Yeshu"]
    @IBOutlet var tblNews: UITableView!
    var newsArr: [News] = [News]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArr.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = "\(newsArr[indexPath.row].title)"
        
        let cell = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?.first as! NewsTableViewCell
        
        cell.lblTitle.text = newsArr[indexPath.row].title

        return cell
    }
    
    func getData(){
        let url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=b9a50cd3c58544c494cf7d6c50e354d8";
        
        AF.request(url).responseJSON { response in
            if response.error == nil{
                guard let data = response.data else{return}
                guard let news = JSON(data)["articles"].array else {return}
                
                if news.count == 0 {
                    return
                }
                    
            self.newsArr = [News]()
            
                for part in news{
                    let title = part["title"].stringValue
                    self.newsArr.append(News(title: title))
                }
                
                self.tblNews.reloadData();
            }
        }
        
    }
    
    
}
