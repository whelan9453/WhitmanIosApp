//
//  IntroductionViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/6/19.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let timer = Timer(timeInterval: 5.0, repeats: false) { [weak self] (timer) in
            self?.performSegue(withIdentifier: SegueIdentifier.toMain.rawValue, sender: nil)
            timer.invalidate()
        }
        timer.fire()
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
