//
//  TaskCaptionCell.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/6/19.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class TaskCaptionCell: UITableViewCell {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet var taskImages: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(with role: PlayerRole, _ type: String) {
        if role == .dumboTimes {
            switch type {
            case "W":
                captionLabel.text = "Interview both Whitman and Harrison"
                taskImages.forEach({ (imageView) in
                    imageView.image = UIImage(asset: .regionW)
                    imageView.isHidden = false
                })
            case "H":
                captionLabel.text = "Check out at least 1 locations connected"
                taskImages.forEach({ (imageView) in
                    if imageView.tag == 1 {
                        imageView.image = UIImage(asset: .regionH)
                        imageView.isHidden = false
                    } else {
                        imageView.isHidden = true
                    }
                })
            case "N":
                captionLabel.text = "Check out at least 1 location connected to the neighborhood"
                taskImages.forEach({ (imageView) in
                    if imageView.tag == 0 {
                        imageView.image = UIImage(asset: .regionN)
                        imageView.isHidden = false
                    } else {
                        imageView.isHidden = true
                    }
                })
            default:
                break
            }
        } else {
            switch type {
            case "W":
                captionLabel.text = "Interview both Whitman and Harrison"
                taskImages.forEach({ (imageView) in
                    imageView.image = UIImage(asset: .regionW)
                    imageView.isHidden = false
                })
            case "N":
                captionLabel.text = "Check out at least 1 location connected to the neighborhood"
                taskImages.forEach({ (imageView) in
                    if imageView.tag < 2 {
                        imageView.image = UIImage(asset: .regionN)
                        imageView.isHidden = false
                    } else {
                        imageView.isHidden = true
                    }
                })
            default:
                break
            }
        }
    }

}
