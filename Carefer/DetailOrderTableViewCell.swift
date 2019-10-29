//
//  DetailOrderTableViewCell.swift
//  Carefer
//
//  Created by Apple on 12/13/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit

class DetailOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_data: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
