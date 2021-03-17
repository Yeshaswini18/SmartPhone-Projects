//
//  TableViewCell.swift
//  FiveDayForecast
//
//  Created by Sankeerth V S on 3/16/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var imageHigh: UIImageView!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var imageLow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
