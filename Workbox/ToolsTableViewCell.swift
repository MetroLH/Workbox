//
//  ToolsTableViewCell.swift
//  Workbox
//
//  Created by 刘海 on 2016/12/13.
//  Copyright © 2016年 刘海. All rights reserved.
//

import UIKit

class ToolsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?;
    @IBOutlet weak var helpLabel: UILabel?;
    @IBOutlet weak var iconImage: UIImageView?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
