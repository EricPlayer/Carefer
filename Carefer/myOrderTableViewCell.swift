//
//  myOrderTableViewCell.swift
//  Carefer
//
//  Created by Fatoo on 4/12/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit

class myOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var shortView:UIView!
    @IBOutlet weak var detailView:UIView!
    @IBOutlet weak var lblOrderNumber:UILabel!
    @IBOutlet weak var lblOrderDate:UILabel!
    @IBOutlet weak var lblShopName:UILabel!
    @IBOutlet weak var lblOrderType:UILabel!
    @IBOutlet weak var lblShopRating:UILabel!
    @IBOutlet weak var lblOrderStatus:UILabel!
    
    
    @IBOutlet weak var lblOrderNumberForShort:UILabel!
    @IBOutlet weak var lblOrderDateForShort:UILabel!
   
    @IBOutlet weak var btnRateShop:UIButton!
    
    
    
    @IBOutlet weak var shortViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var detailViewHeightConstraint:NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
