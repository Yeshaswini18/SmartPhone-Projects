//
//  ComodityTableViewController.swift
//  NetworkCallAndPromises
//
//  Created by Sankeerth V S on 2/24/21.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import PromiseKit

class ComodityTableViewController: UITableViewController {
    
    @IBOutlet var tblComodity: UITableView!
    
    var comodityArr: [Comodity] = [Comodity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comodityArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ComodityTableViewCell", owner: self, options: nil)?.first as! ComodityTableViewCell
        
        cell.lblName.text = comodityArr[indexPath.row].name
        cell.lblPrice.text = String(comodityArr[indexPath.row].price)


        return cell
    }
    
    func getData() {
        let url = "https://financialmodelingprep.com/api/v3/quotes/commodity?apikey=512a8dce1224f8d13a07db51d1f27602"
        
        getQuickShortQuote(url)
            .done{ (comodities) in
                self.comodityArr = [Comodity]()
                for comodity in comodities{
                    self.comodityArr.append(comodity)
                }
                self.tblComodity.reloadData()
            }
            .catch { (error) in
                            print("Error in getting all the comodity values \(error)")
                        }
        
    }
    
    func getQuickShortQuote(_ url: String) -> Promise<[Comodity]>{
        return Promise<[Comodity]> { seal -> Void in
            AF.request(url).responseJSON { response in
                if response.error == nil {
                    var arr  = [Comodity]()
                    guard let data = response.data else {return seal.fulfill( arr ) }
                    guard let comodities = JSON(data).array else { return  seal.fulfill( arr ) }
                    
                    for comodity in comodities{
                        let name = comodity["name"].stringValue
                        let price = comodity["price"].floatValue
                        
                        let comodity = Comodity(name: name, price:price)
                        comodity.name = name
                        comodity.price = price
                        arr.append(comodity)
                    }
                    
                    seal.fulfill(arr)
                }
                else {
                    seal.reject(response.error!)
                }
            }
        }
    }
}
