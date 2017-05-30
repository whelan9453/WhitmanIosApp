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
        return [self.getControllerFromStoryboard(with: "Tutorial1"),
                self.getControllerFromStoryboard(with: "Tutorial2"),
                self.getControllerFromStoryboard(with: "Tutorial3")]
    }()
    weak var pagerDelegate: TutorialPagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
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
    
}

extension TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = allViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        let orderedViewControllersCount = allViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return allViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = allViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard allViewControllers.count > previousIndex else {
            return nil
        }
        return allViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = allViewControllers.index(of: firstViewController) {
            pagerDelegate?.pageNumberChanged(index: index)
        }
    }
}
