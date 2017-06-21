//
//  TaskRegionCell.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/6/19.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class TaskRegionCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet var taskImageViews: [UIImageView]!
    @IBOutlet var titleLabels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(with type: String) {
        guard let string = UserDefaults.standard.string(forKey: Keys.role), let role = PlayerRole(rawValue: string) else {
            return
        }
        
        switch type {
            case "W":
                requiredLabel.text = role == .dumboTimes ? "2 required" : "3 required"
                locationLabel.text = "CHARACTER LOCATION"
                taskImageViews.forEach({ (imageView) in
                    imageView.image = UIImage(asset: .regionW)
                })
                titleLabels.enumerated().forEach({ (index, label) in
                    switch index {
                    case 0:
                        label.text = TaskRegion.W1.point.title
                    case 1:
                        label.text = TaskRegion.W2.point.title
                    case 2:
                        label.text = TaskRegion.W3.point.title
                    case 3:
                        label.text = TaskRegion.F.point.title
                    default:
                        break
                    }
                })
            case "H":
                requiredLabel.text = role == .dumboTimes ? "1 required" : "0 required"
                locationLabel.text = "HISTORICAL LOCATION"
                taskImageViews.forEach({ (imageView) in
                    imageView.image = UIImage(asset: .regionH)
                })
                titleLabels.enumerated().forEach({ (index, label) in
                    switch index {
                    case 0:
                        label.text = TaskRegion.H4.point.title
                    case 1:
                        label.text = TaskRegion.W1.point.title
                    case 2:
                        label.text = TaskRegion.W2.point.title
                    case 3:
                        label.text = TaskRegion.W3.point.title
                    default:
                        break
                    }
                })
            case "N":
                requiredLabel.text = role == .dumboTimes ? "1 required" : "2 required"
                locationLabel.text = "NEIGHBORHOOD LOCATION"
                taskImageViews.forEach({ (imageView) in
                    imageView.image = UIImage(asset: .regionN)
                })
                titleLabels.enumerated().forEach({ (index, label) in
                    switch index {
                    case 0:
                        label.text = TaskRegion.N1.point.title
                    case 1:
                        label.text = TaskRegion.N2.point.title
                    case 2:
                        label.text = TaskRegion.N3.point.title
                    case 3:
                        label.text = TaskRegion.N4.point.title
                    default:
                        break
                    }
                })
        default:
            break
        }
    }
}
