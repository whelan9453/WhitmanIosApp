//
//  RegisterViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/30.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var mailView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameView.bordering(with: UIColor(hex: "#3e3935"), size: 1)
        mailView.bordering(with: UIColor(hex: "#3e3935"), size: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    @IBAction func startAction(_ sender: UIButton) {
        
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
