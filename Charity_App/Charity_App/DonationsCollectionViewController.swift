//
//  DonationsCollectionViewController.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/23/21.
//

import UIKit
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "Cell"

class DonationsCollectionViewController: UICollectionViewController {
    var db: Firestore!
    var donationArr: [DonationModel] = [DonationModel]()

    @IBOutlet var collView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        collectionView.register(UINib.init(nibName: "DonationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        getDonations()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return donationArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DonationsCollectionViewCell
        cell.lblOrgName.text = "Org Name : \(donationArr[indexPath.row].orgName)"
        cell.lblTime.text = "Time : \(donationArr[indexPath.row].time)"
        cell.lblDate.text = "Date : \(donationArr[indexPath.row].date)"
        cell.lblAmount.text = "Amount Donated : \(String(donationArr[indexPath.row].amount))"
        
        return cell
    }
    
    func getDonations() {
        
        db.collection("donations").whereField("userId", isEqualTo: CategorySelect.userId)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting donations")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let amount = data["amount"] as? Int ?? 0
                    let date = data["date"] as? String ?? "None"
                    let orgName = data["orgName"] as? String ?? "None"
                    let time = data["time"] as? String ?? "None"
                    
                    let out = DonationModel(orgName: orgName, amount: amount, date: date, time: time)
                    self.donationArr.append(out)
                    
                }
                self.collView.reloadData()
        }
    }
    
    

}
