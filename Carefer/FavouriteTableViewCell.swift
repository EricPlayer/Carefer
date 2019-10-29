//
//  FavouriteTableViewCell.swift
//  Carefer
//
//  Created by Fatoo on 4/12/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    @IBOutlet weak var lblShopName:UILabel!
    @IBOutlet weak var imageviewThumbNail:UIImageView!
    @IBOutlet weak var backgroundImage:UIImageView!
    @IBOutlet weak var imageHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraint:NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
