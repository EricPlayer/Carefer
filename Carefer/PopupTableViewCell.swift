//
//  PopupTableViewCell.swift
//  Carefer
//
//  Created by Muzammal Hussain on 11/23/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit

class PopupTableViewCell : UITableViewCell
{
    @IBOutlet weak var titleLabel : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
}
