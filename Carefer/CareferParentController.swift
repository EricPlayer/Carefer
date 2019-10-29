//
//  CareferParentController.swift
//  Carefer
//
//  Created by Muzammal Hussain on 9/19/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit


class CareferParentController : UIViewController
{
    var isToUpdateNativeTabBar = true;
    override func viewDidLoad() {
        super.viewDidLoad();
        if isToUpdateNativeTabBar {
            self.updateTabbarAppearance();
        }
    }
    
    func updateTabbarAppearance()
    {
        self.updateTabBarIcon(image: "mydetails_tab", selectedImage: "mydetails_tab_color", scaledImage: "tab_bar_profile", scaledSelectedImage: "tab_bar_profile_selected", index: 0);
        
        self.updateTabBarIcon(image: "myorder_tab", selectedImage: "myorder_tab_color", scaledImage: "tab_bar_order", scaledSelectedImage: "tab_bar_order_selected", index: 1);
        
        self.updateTabBarIcon(image: "favorite_tab_shop", selectedImage: "favorite_tab_shop_color", scaledImage: "tab_bar_favorite", scaledSelectedImage: "tab_bar_favorite_selected", index: 2)
        
        self.updateTabBarIcon(image: "share_tab", selectedImage: "share_tab_color", scaledImage: "tab_bar_share", scaledSelectedImage: "tab_bar_share_selected", index: 3)
        
        self.updateTabBarIcon(image: "about_tab", selectedImage: "about_tab_color", scaledImage: "tab_bar_about", scaledSelectedImage: "tab_bar_about_selected", index: 4)
    }
    
    func updateTabBarIcon(image : String, selectedImage: String, scaledImage: String, scaledSelectedImage : String, index: Int)
    {
        if(UIScreen.main.bounds.width > 320)
        {
            self.tabBarController?.tabBar.items?[index].image = UIImage(named: scaledImage)!;
            self.tabBarController?.tabBar.items?[index].selectedImage = UIImage(named: scaledSelectedImage)!;
        }
        else
        {
            self.tabBarController?.tabBar.items?[index].image = UIImage(named: image)!;
            self.tabBarController?.tabBar.items?[index].selectedImage = UIImage(named: selectedImage)!;
        }
    }
}
