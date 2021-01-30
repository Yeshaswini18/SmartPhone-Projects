//
//  ViewController.swift
//  DiceGame
//
//  Created by Sankeerth V S on 1/29/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var lblWinLoose: UILabel!
    
    @IBOutlet weak var lblBalance: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    let image1Array = ["One", "Two", "Three", "Four", "Five", "Six"]
    
    let image2Array = ["Dice1", "Dice2", "Dice3", "Dice4", "Dice5", "Dice6"]
    
    var rand1 = Int.random(in: 0...5)
    var rand2 = Int.random(in: 0...5)
    
    var balance = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeImages()
        lblWinLoose.text = "Please tap Roll Dice button"
        lblBalance.text = "Your Balance = \(balance)$"
    }
    
    func changeImages() {
        rand1 = Int.random(in: 0...5)
        rand2 = Int.random(in: 0...5)
        
        image1.image = UIImage(named: image1Array[rand1])
        image2.image = UIImage(named: image2Array[rand2])
        
    }
    
    @IBAction func RollDice(_ sender: UIButton) {
        changeImages()
        let result = (rand1+1) + (rand2+1)
        
        if result == 7 {
            balance += 3
            lblWinLoose.text = "You won 3$"
        }
        else if result < 7 {
            balance -= 1
            lblWinLoose.text = "You lost 1$"
        }
        else {
            balance += 1
            lblWinLoose.text = "You won 1$"
        }
        
        lblBalance.text = "Your Balance = \(balance)$"
        
        if balance <= 0 {
            playButton.isEnabled = false
            lblWinLoose.text = "Please Restart your App"
        }
        
        
    }
    
}

