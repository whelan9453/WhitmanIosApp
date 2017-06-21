//
//  RoleTaskViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/6/18.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class RoleTaskViewController: UIViewController {
    @IBOutlet weak var roleLogoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!

    var role: PlayerRole = .dumboTimes
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        titleLabel.textAlignment = .center
        titleLabel.text = role == .dumboTimes ? "So you work for the prestigious DUMBO Times? To get your story, you need to:" : "So you work for that cheap rag The DUMBO Enquirer?"
        roleLogoImageView.image = UIImage(asset: role == .dumboTimes ? .timesMessagerLogo : .enquirerMessagerLogo)
        titleLabel.sizeToFit()
        headerView.frame.size.height = titleLabel.frame.maxY + 23
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

extension RoleTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return role == .dumboTimes ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCaptionCell", for: indexPath) as! TaskCaptionCell
            switch indexPath.row {
            case 0:
                cell.setup(with: role, "W")
            case 1:
                cell.setup(with: role, role == .dumboTimes ? "H" : "N")
            case 2:
                cell.setup(with: role, "N")
            default: break
        }
        return cell
    }
}
