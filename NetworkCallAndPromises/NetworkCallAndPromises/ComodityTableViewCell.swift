//
//  ComodityTableViewCell.swift
//  NetworkCallAndPromises
//
//  Created by Sankeerth V S on 2/24/21.
//

import UIKit

class ComodityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
