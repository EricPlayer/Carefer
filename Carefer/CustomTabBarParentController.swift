//
//  CustomTabBarParentController.swift
//  Carefer
//
//  Created by Muzammal Hussain on 9/19/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarParentController : ReqRegParentController
{
    @IBOutlet weak var btnMyDeals:UIButton!
    @IBOutlet weak var btnMyOrders:UIButton!
    @IBOutlet weak var btnMyFavorites:UIButton!
    @IBOutlet weak var btnShare:UIButton!
    @IBOutlet weak var btnAboutCarefer:UIButton!
    
    
    override func viewDidLoad() {
        tabBarController?.tabBar.backgroundImage=UIImage(named:"1x-shadow-bg")
        self.addReqRegViewOnDemand = true;
        self.isToUpdateNativeTabBar = false;
        super.viewDidLoad();
        self.updateCustomTabBarAppearance();
    }
    
    func updateCustomTabBarAppearance()
    {
        self.updateTabBarIcon(image: "mydetails_tab", scaledImage: "tab_bar_profile", tabBarItem: self.btnMyDeals);
        
        self.updateTabBarIcon(image: "myorder_tab", scaledImage: "tab_bar_order", tabBarItem: self.btnMyOrders);
        
        self.updateTabBarIcon(image: "favorite_tab_shop", scaledImage: "tab_bar_favorite", tabBarItem: self.btnMyFavorites)
        
        self.updateTabBarIcon(image: "share_tab", scaledImage: "tab_bar_share", tabBarItem: self.btnShare)
        
        self.updateTabBarIcon(image: "about_tab", scaledImage: "tab_bar_about", tabBarItem: self.btnAboutCarefer)
    }
    
    func updateTabBarIcon(image : String, scaledImage: String, tabBarItem : UIButton)
    {
        if(UIScreen.main.bounds.width > 320)
        {
            tabBarItem.setImage(UIImage(named: scaledImage)!, for: .normal);
        }
        else
        {
            tabBarItem.setImage(UIImage(named: image)!, for: .normal);
        }
    }
}
