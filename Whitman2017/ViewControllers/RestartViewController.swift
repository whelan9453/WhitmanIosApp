//
//  RestartViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/30.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class RestartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func restartAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        appDelegate.resetUserDefault()
        appDelegate.window?.rootViewController?.dismiss(animated: false)
        appDelegate.window?.rootViewController = VC
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
