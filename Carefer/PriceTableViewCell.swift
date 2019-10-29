//
//  PriceTableViewCell.swift
//  Carefer
//
//  Created by Apple on 12/14/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var img_box: UIImageView!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_priceDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
