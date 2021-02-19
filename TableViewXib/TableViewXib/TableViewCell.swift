//
//  TableViewCell.swift
//  TableViewXib
//
//  Created by Sankeerth V S on 2/18/21.
//

import UIKit
class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblTemperatures: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
