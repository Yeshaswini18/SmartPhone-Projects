//
//  OrganizationModel.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/20/21.
//

import Foundation

class OrganizationModel{
    var categoryID : String = ""
    var category: String = ""
    var description : String = ""
    var image : String = ""
    var orgName : String = ""
    var organizationID: String = ""
    
    init(categoryID: String, category: String, description: String, image: String, orgName: String, organizationID:String) {
        self.categoryID = categoryID
        self.image = image
        self.orgName = orgName
    }
}
