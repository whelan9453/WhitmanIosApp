//
//  MenuViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/4/9.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cellTitles: [Caption] = [.story, .task, .about, .restart, .submit]
    var cellImages: [Asset] = [.storyIcon, .taskIcon, .aboutIcon, .restartIcon, .submitIcon]
    weak var segueDelegate: SegueDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let target = SegueIdentifier(rawValue: identifier) else {
            return
        }
        switch target {
        case .toStory:
            let VC = segue.destination
            VC.navigationItem.title = Caption.story.rawValue
        case .toTask:
            let VC = segue.destination
            VC.navigationItem.title = Caption.task.rawValue
        case .toAbout:
            let VC = segue.destination
            VC.navigationItem.title = Caption.about.rawValue
        case .toRestart:
            let VC = segue.destination
        case .toSubmit:
            let VC = segue.destination
            VC.navigationItem.title = Caption.submit.rawValue
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: SegueIdentifier.toStory.rawValue, sender: nil)
        case 1:
            performSegue(withIdentifier: SegueIdentifier.toTask.rawValue, sender: nil)
        case 2:
            performSegue(withIdentifier: SegueIdentifier.toAbout.rawValue, sender: nil)
        case 3:
            performSegue(withIdentifier: SegueIdentifier.toRestart.rawValue, sender: nil)
        case 4:
            performSegue(withIdentifier: SegueIdentifier.toSubmit.rawValue, sender: nil)
        default:
            break
        }
    }
}
