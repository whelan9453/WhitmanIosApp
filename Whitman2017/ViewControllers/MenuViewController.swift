//
//  MenuViewController.swift
//  Whitman2017
//
//  This View Controller is for the side bar.
//
//  Created by Toby Hsu on 2017/4/9.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cellTitles: [Caption] = [.story, .task, .about, .restart, .publish]
    var cellImages: [Asset] = [.storyIcon, .taskIcon, .aboutIcon, .restartIcon, .submitIcon]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let target = SegueIdentifier(rawValue: identifier) else {
            return
        }
        
        //Set up destination page's title
        //FIXME multiple clicks would open duplicate new pages
        let VC = segue.destination
        switch target {
        case .toStory:
            VC.navigationItem.title = Caption.story.rawValue
        case .toTask:
            VC.navigationItem.title = Caption.task.rawValue + " PROGRESS"
        case .toAbout:
            VC.navigationItem.title = Caption.about.rawValue
        case .toPublish:
            VC.navigationItem.title = Caption.publish.rawValue
        case .toRestart:
            break
        default:
            break
        }
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.iconImageView.image = UIImage(asset: cellImages[indexPath.row])
        cell.descLabel.text = cellTitles[indexPath.row].rawValue
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    //OnClickListeners: We need a delegate for these table view items to transfer between pages
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case cellTitles.index(of: Caption.story)!:
            performSegue(withIdentifier: SegueIdentifier.toStory.rawValue, sender: nil)
        case cellTitles.index(of: Caption.task)!:
            performSegue(withIdentifier: SegueIdentifier.toTask.rawValue, sender: nil)
        case cellTitles.index(of: Caption.about)!:
            performSegue(withIdentifier: SegueIdentifier.toAbout.rawValue, sender: nil)
        case cellTitles.index(of: Caption.restart)!:
            performSegue(withIdentifier: SegueIdentifier.toRestart.rawValue, sender: nil)
        case cellTitles.index(of: Caption.publish)!:
            performSegue(withIdentifier: SegueIdentifier.toPublish.rawValue, sender: nil)
        default:
            break
        }
    }
}
