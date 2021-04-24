//
//  ServiceViewController.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/21/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class ServiceViewController: UIViewController {
    
    
    var db: Firestore!
    let organizationID = CategorySelect.organizationID
    var pickerViewDate = UIDatePicker()
    var pickerViewFrom = UIDatePicker()
    var pickerViewTo = UIPickerView()
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var lblOrgName: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgHappy: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getOrganizationDetails()
        createDatePicker()
        createFromTime()
        createToTime()
        self.lblStatus.text = ""

    }
    
    func createFromTime() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedFrom))
        toolBar.setItems([doneBtn], animated: true)
        txtTime.inputAccessoryView = toolBar
        txtTime.inputView = pickerViewFrom
        pickerViewFrom.datePickerMode = .time
    }
    
    @objc func donePressedFrom() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        txtTime.text = "\(formatter.string(from: pickerViewFrom.date))"
        self.view.endEditing(true)
    }
    
    func createToTime() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedTo))
        toolBar.setItems([doneBtn], animated: true)
        txtEndTime.inputAccessoryView = toolBar
        txtEndTime.inputView = pickerViewFrom
        pickerViewFrom.datePickerMode = .time
    }
    
    @objc func donePressedTo() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        txtEndTime.text = "\(formatter.string(from: pickerViewFrom.date))"
        self.view.endEditing(true)
    }
    
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneBtn], animated: true)
        txtDate.inputAccessoryView = toolBar
        
        txtDate.inputView = pickerViewDate
        
        pickerViewDate.datePickerMode = .date
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        txtDate.text = "\(formatter.string(from: pickerViewDate.date))"
        self.view.endEditing(true)
    }
    
    func getOrganizationDetails(){
        db.collection("onganizations").whereField("organizationID", isEqualTo: self.organizationID)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting organization's details")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? "None"
                    self.lblOrgName.text = "Thanks for helping \(name)"
                    let address = data["address"] as? String ?? "None"
                    self.lblAddress.text = "Address: \(address)"
                    
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
    @IBAction func bookingAction(_ sender: Any) {
        if self.txtDate.text == "" || self.txtTime.text == "" || self.txtEndTime.text == "" {
            lblStatus.text = "Please select date and time"
        } else {
            addServiceToDB()
            self.lblStatus.text = "Booking Confirmed!!"
            self.imgHappy.image = UIImage(named: "Happy")
        }
    }
    
    func addServiceToDB() {
        let newService = db.collection("services").document()
        let serviceId = newService.documentID
        let uid = Auth.auth().currentUser?.uid
        
        newService.setData(["userId": uid!,
                             "orgName": CategorySelect.orgName,
                             "address": CategorySelect.address,
                             "date": txtDate.text!,
                             "from": txtTime.text!,
                             "to": txtEndTime.text!,
                             "serviceId": serviceId
        ])
    }
    
}
