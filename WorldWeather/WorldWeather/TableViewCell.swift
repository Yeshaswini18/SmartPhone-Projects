//
//  TableViewCell.swift
//  WorldWeather
//
//  Created by Sankeerth V S on 3/7/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let nibName = "TableViewCell"
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(forecast: DailyForecast) {
        self.lblDay.text = " " + forecast.dayOfWeek
        self.lblLow.text = String(forecast.minimumTemp) + "°F"
        self.lblHigh.text = String(forecast.maximumTemp) + "°F"
        
        self.stackView.pinEdges(to: self)
    }
    
}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
