//
//  orgNameModel.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/21/21.
//

import Foundation

class OrgNameModel {
    var orgName : String = ""
    var categoryID: String = ""
    var organizationID: String = ""
    var address: String = ""
    
    init(orgName: String, categoryID: String, organizationID: String, address: String) {
        self.orgName = orgName
        self.categoryID = categoryID
        self.organizationID = organizationID
        self.address = address
    }
}
