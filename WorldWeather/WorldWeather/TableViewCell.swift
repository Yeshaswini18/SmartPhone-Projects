//
//  TableViewCell.swift
//  WorldWeather
//
//  Created by Sankeerth V S on 3/7/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
