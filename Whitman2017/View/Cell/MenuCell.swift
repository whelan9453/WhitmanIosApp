//
//  MenuCell.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/24.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
