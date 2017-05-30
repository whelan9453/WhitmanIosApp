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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let VC = segue.destination as? TutorialPageViewController {
            //设置委托（当页面数量、索引改变时当前视图控制器能触发页控件的改变）
            VC.pagerDelegate = self
        }
    }

}

extension HomeViewController: TutorialPagerDelegate {
    func pageNumberChanged(index: Int) {
        pageControl.currentPage = index
    }
}
