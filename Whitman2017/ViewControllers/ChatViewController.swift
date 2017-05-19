//
//  ChatViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/4/9.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: ChatViewControllerDelegate?
    var isExpanding: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.rounding()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapViewAction(_ sender: UITapGestureRecognizer) {
        guard let delegate = delegate else {
            return
        }
        isExpanding = !isExpanding
        collectionView.isHidden = !isExpanding
        titleLabel.isHidden = isExpanding
        if isExpanding {
            delegate.reSizeHeight(300.0)
        } else {
            delegate.reSizeHeight(64.0)
        }
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
