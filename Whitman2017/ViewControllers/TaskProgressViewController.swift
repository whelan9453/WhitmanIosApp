//
//  TaskProgressViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/6/19.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class TaskProgressViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TaskProgressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskRegionCell", for: indexPath) as! TaskRegionCell
        switch indexPath.row {
        case 0:
            cell.setup(with: "W")
        case 1:
            cell.setup(with: "H")
        case 2:
            cell.setup(with: "N")
        default:
            break
        }
        return cell
    }
}
