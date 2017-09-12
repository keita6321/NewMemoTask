//
//  SampleTableViewCell.swift
//  TableBgImageSample
//
//  Created by Masuhara on 2017/09/12.
//  Copyright © 2017年 Ylab, Inc. All rights reserved.
//

import UIKit

class SampleTableViewCell: UITableViewCell {
    
    @IBOutlet var sampleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
