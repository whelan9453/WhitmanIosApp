//
//  RoleSelectViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/29.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class RoleSelectViewController: UIViewController {
    @IBOutlet weak var DEButton: UIButton!
    @IBOutlet weak var DTButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var borderLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        borderLayer.frame = DEButton.bounds
        borderLayer.frame.origin.x += 9
        borderLayer.frame.origin.y += 9
        borderLayer.frame.size.width -= 18
        borderLayer.frame.size.height -= 18
        borderLayer.borderWidth = 5
        borderLayer.borderColor = UIColor(hex: "#cc3524").cgColor
        borderLayer.cornerRadius = borderLayer.frame.width / 2
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        sender.layer.addSublayer(borderLayer)
        if sender == DTButton {
            UserDefaults.standard.set(PlayerRole.dumboTimes.rawValue, forKey: Keys.role)
        } else {
            UserDefaults.standard.set(PlayerRole.dumboEnquirer.rawValue, forKey: Keys.role)
        }
        nextButton.isEnabled = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
