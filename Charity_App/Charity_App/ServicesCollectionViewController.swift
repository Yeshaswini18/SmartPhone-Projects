//
//  ServicesCollectionViewController.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/23/21.
//

import UIKit
import Firebase
import FirebaseFirestore

private let reuseIdentifier = "Cell"

class ServicesCollectionViewController: UICollectionViewController {
    var db: Firestore!
    var servicesArr: [ServicesModel] = [ServicesModel]()
    
    @IBOutlet var collView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        collectionView.register(UINib.init(nibName: "ServicesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        getServices()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return servicesArr.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ServicesCollectionViewCell
        cell.lblDate.text = "Date : \(servicesArr[indexPath.row].date)"
        cell.lblOrgName.text = "Org Name : \(servicesArr[indexPath.row].orgName)"
        cell.lblFrom.text = "From : \(servicesArr[indexPath.row].from)"
        cell.lblTo.text = "To : \(servicesArr[indexPath.row].to)"
        cell.lblAddress.text = "Address : \(servicesArr[indexPath.row].address)"
    
        return cell
    }
    
    func getServices() {
        print(CategorySelect.userId)
        db.collection("services").whereField("userId", isEqualTo: CategorySelect.userId)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting donations")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let date = data["date"] as? String ?? "None"
                    let orgName = data["orgName"] as? String ?? "None"
                    let from = data["from"] as? String ?? "None"
                    let address = data["address"] as? String ?? "None"
                    let to = data["to"] as? String ?? "None"
                    
                    let out = ServicesModel(orgName: orgName, address: address, from: from, date: date, to: to)
                    self.servicesArr.append(out)
                    
                }
                self.collView.reloadData()
        }
    }
}
