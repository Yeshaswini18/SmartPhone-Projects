//
//  DonationModel.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/23/21.
//

import Foundation

class DonationModel {
    var orgName : String = ""
    var amount: Int = 0
    var date: String = ""
    var time: String = ""
    
    init(orgName: String, amount: Int, date: String, time: String) {
        self.orgName = orgName
        self.amount = amount
        self.date = date
        self.time = time
    }
}
