//
//  DonationViewController.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/21/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class DonationViewController: UIViewController {
    var db: Firestore!
    let organizationID = CategorySelect.organizationID
    var serviceFee = 0
    var sum: Int = 0
    

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblOrgName: UILabel!
    @IBOutlet weak var imgOrg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getOrganizationDetails()
        self.lblStatus.text = " "
    }
    
    
    func getOrganizationDetails() {
        db.collection("onganizations").whereField("organizationID", isEqualTo: self.organizationID)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting organization's details")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let imageURL = data["image"] as? String ?? "None"
                    var url = NSURL(string: imageURL)
                    var urlData = NSData(contentsOf : url as! URL)
                    self.imgOrg.image = UIImage(data : urlData as! Data)
                    let name = data["name"] as? String ?? "None"
                    self.lblOrgName.text = name
                    CategorySelect.orgName = name
                    let organizationID = data["organizationID"] as? String ?? "None"
                    let address = data["address"] as? String ?? "None"
                    CategorySelect.address = address
                    let description = data["description"] as? String ?? "None"
                    self.lblDescription.text = description
                    let serviceFee = data["serviceFee"] as? Int ?? 0
                    self.lblServiceFee.text = "Service Fee: \(serviceFee)"
                    self.serviceFee = serviceFee
                    
                }
        }
    }

    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            KeychainService().keyChain.delete("uid")
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        if self.txtAmount.text == "" || Int(self.txtAmount.text!) == nil {
            self.lblStatus.text = "Enter a valid number"
            return
        }
        self.sum = Int(self.txtAmount.text!) ?? 0
        CategorySelect.total = serviceFee + self.sum
        self.performSegue(withIdentifier: "ReviewSegue", sender: self)
        self.txtAmount.text = ""
        self.lblStatus.text = " "
    }
}
