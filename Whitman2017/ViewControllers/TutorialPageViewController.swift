//
//  TutorialPageViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/22.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

protocol TutorialPagerDelegate: class {
    func pageNumberChanged(index: Int)
}

class TutorialPageViewController: UIPageViewController {

    private(set) lazy var allViewControllers: [UIViewController] = {
        return [self.getControllerFromStoryboard(with: TutorialIdentifier.page1.rawValue),
                self.getControllerFromStoryboard(with: TutorialIdentifier.page2.rawValue),
                self.getControllerFromStoryboard(with: TutorialIdentifier.page3.rawValue)]
    }()
    weak var pagerDelegate: TutorialPagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self //Set self as DataSource
        delegate = self //Set self as Delegate
        if let firstViewController = allViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
        }
    }
    
    func getControllerFromStoryboard(with name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
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

extension TutorialPageViewController: UIPageViewControllerDelegate {
    //Called after a gesture-driven transition completes.
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //where does this "viewControllers" come from?
        if let firstViewController = viewControllers?.first,
            let index = allViewControllers.index(of: firstViewController) {
            //It's declared here but initialized at HomeViewController? How does this work?
            pagerDelegate?.pageNumberChanged(index: index)
        }
    }
}

extension TutorialPageViewController: UIPageViewControllerDataSource {
    
    //Returns the view controller after the given view controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = allViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = index + 1
        guard 0 ... (allViewControllers.count - 1) ~= nextIndex else {
            return nil
        }
        return allViewControllers[nextIndex]
    }
    
    //Returns the view controller before the given view controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = allViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = index - 1
        guard 0 ... (allViewControllers.count - 1) ~= previousIndex else {
            return nil
        }
        return allViewControllers[previousIndex]
    }
}
