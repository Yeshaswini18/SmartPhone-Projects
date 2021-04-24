//
//  QuestionnaireViewController.swift
//  Charity_App
//
//  Created by Sankeerth V S on 4/21/21.
//

import UIKit
import Firebase

class QuestionnaireViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
