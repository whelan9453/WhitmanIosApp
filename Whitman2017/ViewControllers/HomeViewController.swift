//
//  HomeViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/30.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
    }    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let VC = segue.destination as? TutorialPageViewController {
            VC.pagerDelegate = self
        }
    }

}

extension HomeViewController: TutorialPagerDelegate {
    func pageNumberChanged(index: Int) {
        pageControl.currentPage = index
    }
}
