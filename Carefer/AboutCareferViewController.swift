//
//  AboutCareferViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/12/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit

class AboutCareferViewController: CareferParentController {
@IBOutlet weak var roundedView :UIView!
@IBOutlet weak var cirCleView :UIView!
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblPhone:UILabel!
    @IBOutlet weak var lblWebSite:UILabel!
    @IBOutlet weak var lblNavigationTitle:UILabel!
    @IBOutlet weak var orderYellowBar:UILabel!
    @IBOutlet weak var webSite:UILabel!
     @IBOutlet weak var email:UILabel!
     @IBOutlet weak var phoneNumber:UILabel!
     @IBOutlet weak var detail:UILabel!
     @IBOutlet weak var titleYellow:UILabel!
     @IBOutlet weak var detailTitle:UILabel!
    @IBOutlet weak var lblVersionNo:UILabel!
    @IBOutlet weak var lblVersionTitle:UILabel!
    @IBOutlet weak var emailArabic:UILabel!
    @IBOutlet weak var websiteArabic:UILabel!
    @IBOutlet weak var lblMapButtonTitle :UILabel!
    @IBOutlet weak var navigationBar:UIView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let layerGradient = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let topShadow = EdgeShadowLayer(forView:self.navigationBar, edge:.Bottom)
        //self.navigationBar.layer.addSublayer(topShadow)

        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:21)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:21)
            //self.websiteArabic.font = UIFont(name:"HSN_Shahd_Regular",size:14)
            // self.emailArabic.font = UIFont(name:"HSN_Shahd_Regular",size:14)
            self.webSite.font = UIFont(name:Constants.kShahidFont,size:20)
            self.email.font = UIFont(name:Constants.kShahidFont,size:20)
            self.phoneNumber.font = UIFont(name:Constants.kShahidFont,size:20)
            self.detail.font = UIFont(name:Constants.kShahidFont,size:21)
            self.titleYellow.font = UIFont(name:Constants.kShahidFont,size:21)
            self.detailTitle.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblVersionNo.font = UIFont(name:Constants.kShahidFont,size:21)
            
        case .phone:
            print("iPhone and iPod touch style UI")
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:16)
            //self.websiteArabic.font = UIFont(name:"HSN_Shahd_Regular",size:14)
            // self.emailArabic.font = UIFont(name:"HSN_Shahd_Regular",size:14)
            self.webSite.font = UIFont(name:Constants.kShahidFont,size:14)
            self.email.font = UIFont(name:Constants.kShahidFont,size:14)
            self.phoneNumber.font = UIFont(name:Constants.kShahidFont,size:14)
            self.detail.font = UIFont(name:Constants.kShahidFont,size:16)
            self.titleYellow.font = UIFont(name:Constants.kShahidFont,size:16)
            self.detailTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblVersionNo.font = UIFont(name:Constants.kShahidFont,size:16)
            
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }

        
        
        //self.lblVersionTitle.font = UIFont(name:"HSN_Shahd_Regular",size:16)
        // get app version no and set
        self.lblMapButtonTitle.font = UIFont(name:Constants.kShahidFont ,size:13)
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        self.lblVersionNo.text = "الإصدار:\(version)"
       // let build = dictionary["CFBundleVersion"] as! String
        
        var tabFrame = self.tabBarController?.tabBar.frame
       
        //tabFrame?.size.height = 60
        //tabFrame?.origin.y = self.view.frame.size.height - 75
        self.tabBarController?.tabBar.backgroundImage=UIImage(named:"1x-shadow-bg")
        self.tabBarController?.tabBar.frame = tabFrame!
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
        let totalSpace = UIScreen.main.bounds.width / 5
        self.tabBarController?.tabBar.itemWidth = totalSpace - 50
        self.tabBarController?.tabBar.clipsToBounds = true
    }
    
    
    @IBAction func btnBack(sender:UIButton)
    {
        //UserDefaults.standard.set("no", forKey: "isFirstForCity")
        appDelegate.setHomeVc()
    }
    @IBAction func btnBackToMap(sender:UIButton)
    {
        
        // UserDefaults.standard.set("no", forKey: "isFirstForCity")
        appDelegate.setHomeVc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "About Us Screen")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
