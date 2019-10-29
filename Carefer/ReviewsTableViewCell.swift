//
//  ReviewsTableViewCell.swift
//  Carefer
//
//  Created by Fatoo on 6/17/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import Cosmos
class ReviewsTableViewCell: UITableViewCell {
    @IBOutlet weak var priceRatingView:CosmosView!
    @IBOutlet weak var QualityRatingView:CosmosView!
    @IBOutlet weak var TimeRatingView:CosmosView!
    @IBOutlet weak var lblComment:UILabel!
    @IBOutlet weak var lblDateAdded:UILabel!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var nameView:UIView!
    @IBOutlet weak var lblAverage:UILabel!
    @IBOutlet weak var sepratorView:UIView!
    @IBOutlet weak var backGroundView:UIView!
    @IBOutlet weak var imageViewBeyondAverage:UIImageView!
    @IBOutlet weak var lblNameFirstCharacter:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
