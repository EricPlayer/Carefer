//
//  ShopListTableViewCell.swift
//  Carefer
//
//  Created by Fatoo on 4/24/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import Cosmos
class ShopListTableViewCell: UITableViewCell {
    @IBOutlet weak var ratingView:CosmosView!
    @IBOutlet weak var ratingViewForLargeView:CosmosView!
    @IBOutlet weak var btnDetail:UIButton!
    @IBOutlet weak var smallView:UIView!
    @IBOutlet weak var largeView:UIView!
    @IBOutlet weak var largeViewBackgroungImageView:UIImageView!
    @IBOutlet weak var imageViewLarge:UIImageView!
    @IBOutlet weak var btnCollapsed:UIButton!
    @IBOutlet weak var btnCollapsedForLargeView:UIButton!
    @IBOutlet weak var lblDetail:UILabel!
    @IBOutlet weak var lblShopName:UILabel!
    @IBOutlet weak var lblShopNameForLargeView:UILabel!
    @IBOutlet weak var lblServiceType:UILabel!
    @IBOutlet weak var lblShopType:UILabel!
    @IBOutlet weak var lblDistanceForSmallView:UILabel!
    @IBOutlet weak var lblDistanceForLargeView:UILabel!
    @IBOutlet weak   var smallViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak   var btnDetailHeight:NSLayoutConstraint!
    @IBOutlet weak   var detailLabelHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak   var discountedImageView: UIImageView!
    @IBOutlet weak   var trustedImageView: UIImageView!
    
    
   @IBOutlet weak   var lblDetailHeightConstraint:NSLayoutConstraint!
   @IBOutlet weak   var lblDistanceWidthConstraint:NSLayoutConstraint!
   @IBOutlet weak  var bntDetailConstraint:NSLayoutConstraint!

    override init(style : UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        let color = UIColor(red: 246/255, green: 245/255, blue: 245/255, alpha: 1.0)
        self.largeView.layer.borderColor = color.cgColor
        self.largeView.layer.borderWidth = 1.0
        self.largeView.layer.shadowOpacity = 0.5
        self.largeView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.largeView.layer.shadowRadius = 2.0
        self.largeView.layer.shadowColor = UIColor.black.cgColor
        self.largeView.backgroundColor =  color
        self.largeView.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        let color = UIColor(red: 246/255, green: 245/255, blue: 245/255, alpha: 1.0)
        self.largeView.layer.borderColor = color.cgColor
        self.largeView.layer.borderWidth = 1.0
        self.largeView.layer.shadowOpacity = 0.5
        self.largeView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.largeView.layer.shadowRadius = 2.0
        self.largeView.layer.shadowColor = UIColor.black.cgColor
        self.largeView.backgroundColor =  color
        self.largeView.layer.cornerRadius = 5.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
    }
    
}
