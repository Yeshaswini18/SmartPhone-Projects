//
//  PaymentViewController.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/21/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class PaymentViewController: UIViewController {
    var db: Firestore!
    var date = ""
    var time = ""

    @IBOutlet weak var imgHappy: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getData()
        self.lblStatus.text = " "
    }
    
    func getData() {
        self.lblName.text = "Organization Name: \(CategorySelect.orgName)"
        self.lblTotal.text = "Amount: \(String(CategorySelect.total))"
        self.lblAddress.text = "Address: \(CategorySelect.address)"
        let formatter : DateFormatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
        date = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        let formatterTime : DateFormatter = DateFormatter()
            formatterTime.dateFormat = "HH:mm"
        time = formatterTime.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        self.lblDate.text = "Date: \(date)"
    }
    
    @IBAction func paymentAction(_ sender: Any) {
        addDonationToDB()
        self.lblStatus.text = "Thank you for the donation!!"
        self.imgHappy.image = UIImage(named: "Happy")
    }
    
    func addDonationToDB () {
        let newDonation = db.collection("donations").document()
        let donationID = newDonation.documentID
        let uid = Auth.auth().currentUser?.uid
        
        newDonation.setData(["userId": uid!,
                             "orgName": CategorySelect.orgName,
                             "amount": CategorySelect.total,
                             "date": date,
                             "time": time,
                             "donationId": donationID
        ])
        
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
    
}
