//
//  ViewController.swift
//  MyName
//
//  Created by Sankeerth V S on 1/24/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var lblPressMe: UILabel!
    
    var firstNameIsVisible : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func pressMeAction(_ sender: UIButton) {
        
        lblPressMe.text = "Button Pressed"
        
        if firstNameIsVisible == true {
            firstNameIsVisible = false
            imgView.image = UIImage(named: "LastName")
        }
        else {
            firstNameIsVisible = true
            imgView.image = UIImage(named: "FirstName")
        }
    }
}

