//
//  TableViewController.swift
//  TableViewXib
//
//  Created by Sankeerth V S on 2/18/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    let cities = ["Seattle", "Portland", "LA", "LV", "SFO" ]
    let temperatures = ["72","73","74","74","75"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell

        cell.lblCity.text = cities[indexPath.row]
        cell.lblTemperatures.text = "\(temperatures[indexPath.row])°F"

        return cell
    }


    

}
