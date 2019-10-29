//
//  PopupModle.swift
//  Carefer
//
//  Created by Muzammal Hussain on 11/6/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation


class PopupModle : NSObject
{
    
    var popupType : PopupViewType = .brand;
    var id : String? = nil;
    var brandId : Int? = 0;
    var dateAdded : String? = nil;
    var name : String? = "";
    
    convenience init(type: PopupViewType, info: [String : Any])
    {
        self.init();
        self.dateAdded = info["dateAdded"] as? String;
        self.id = info["ID"] as? String;
        switch type
        {
            case .brand:
                self.name = info["brandName"] as? String;
                break;
            case .modle:
                self.name = info["modelName"] as? String;
                self.brandId = info["brandID"] as? Int;
                break;
            case .serviceType:
                self.name = info["serviceTypeName"] as? String;
                break;
        }
    }
    
    override init() {
        super.init();
    }
    
}
