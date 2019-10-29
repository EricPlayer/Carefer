//
//  FavouriteShopsViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/12/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage
class FavouriteShopsViewController: ReqRegParentController ,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var noOrderContainer: UIView!
    @IBOutlet weak var lblDefaultText: UILabel!
    @IBOutlet weak var navigationBar:UIView!
    @IBOutlet weak var roundedView :UIView!
    @IBOutlet weak var tblFavourite :UITableView!
    @IBOutlet weak var WhiteRoundedView :UIView!
    @IBOutlet weak var lblNavigationTitle:UILabel!
    @IBOutlet weak var orderYellowBar:UILabel!
    @IBOutlet weak var lblMapButtonTitle :UILabel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let layerGradient = CAGradientLayer()
    var arrayOfFavShop = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        //let topShadow = EdgeShadowLayer(forView:self.navigationBar, edge:.Bottom)
        //self.navigationBar.layer.addSublayer(topShadow)

        self.noOrderContainer.isHidden = true
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.lblDefaultText.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:21)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:21)
        case .phone:
            print("iPhone and iPod touch style UI")
            self.lblDefaultText.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:16)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        self.lblMapButtonTitle.font = UIFont(name:Constants.kShahidFont ,size:13)
        var tabFrame = self.tabBarController?.tabBar.frame
        
        //tabFrame?.size.height = 60
        //tabFrame?.origin.y = self.view.frame.size.height - 70
        self.tabBarController?.tabBar.backgroundImage=UIImage(named:"1x-shadow-bg")
        self.tabBarController?.tabBar.frame = tabFrame!
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
        let totalSpace = UIScreen.main.bounds.width / 5
        self.tabBarController?.tabBar.itemWidth = totalSpace - 50
        self.tabBarController?.tabBar.clipsToBounds = true
        
        self.tblFavourite.delegate = self
        self.tblFavourite.dataSource = self
        self.tblFavourite.estimatedRowHeight = 130
        self.tblFavourite.rowHeight = UITableViewAutomaticDimension
        self.tblFavourite.tableFooterView = UIView()
        self.tblFavourite.separatorStyle = .none
        // Do any additional setup after loading the view.
        
        if self.isUserDataAccessible {
            self.GetFavShopList()
        } else {
            self.addRegistrationFinishedObserver();
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = false
        
        
            
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Favourite Screen")
            
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
            
        
    }
    @IBAction func btnBackToMap(sender:UIButton)
    {
        
        // UserDefaults.standard.set("no", forKey: "isFirstForCity")
        appDelegate.setHomeVc()
    }
    @IBAction func btnBack(sender:UIButton)
    {
       // UserDefaults.standard.set("no", forKey: "isFirstForCity")
        appDelegate.setHomeVc()
    }
    // Mark Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFavShop.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FavouriteTableViewCell = self.tblFavourite.dequeueReusableCell(withIdentifier:"FavouriteCell") as! FavouriteTableViewCell!
        let shopObject = self.arrayOfFavShop[indexPath.row] as! NSDictionary
                cell.lblShopName.text = shopObject.value(forKey:"shopName") as? String
        
        cell.selectionStyle = .none
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            cell.lblShopName.font = UIFont(name:Constants.kShahidFont ,size:21)
            cell.imageWidthConstraint.constant = 55
            cell.imageHeightConstraint.constant = 55
        case .phone:
            print("iPhone and iPod touch style UI")
            cell.lblShopName.font = UIFont(name:Constants.kShahidFont ,size:16)
            cell.imageWidthConstraint.constant = 40
            cell.imageHeightConstraint.constant = 40
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }

        if   let imageString = shopObject.value(forKey: "shopImage") as? String
        {
            
            
            let imageFinalString = "\(Constants.kBaseUrlImages)\(shopObject.value(forKey: "ID")as! String)/thumbnails/\(imageString)"
            if let urlString = imageFinalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            {
                print("image url: \(urlString)");
                let url =  URL(string: urlString);
                cell.imageviewThumbNail.sd_setImage(with:url, placeholderImage: UIImage(named: "1x-place-holder"))
                cell.imageviewThumbNail.layer.cornerRadius = cell.imageviewThumbNail.frame.size.width / 2
                cell.imageviewThumbNail.clipsToBounds = true
            }
            
            
        }
        
        // set the text from the data model
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            return 90
        case .phone:
            return 60
            print("iPhone and iPod touch style UI")
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        return 0
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           var dic:NSDictionary!
            dic = self.arrayOfFavShop[indexPath.row]as! NSDictionary
       
        let shopDetailVc = self.storyboard?.instantiateViewController(withIdentifier: "shopDetailVc") as! ShopDetailViewController
        shopDetailVc.shopId = dic.value(forKey: "ID") as! String
        shopDetailVc.isFromFavourite =  "yes"
        self.navigationController?.pushViewController(shopDetailVc, animated: true)
        
        print("You tapped cell number \(indexPath.row).")
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
         let cell:FavouriteTableViewCell = tblFavourite.cellForRow(at: indexPath) as! FavouriteTableViewCell
        //cell!.contentView.backgroundColor = .red
        cell.backgroundImage.image = UIImage(named:"1x-fav-shop-bg")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell:FavouriteTableViewCell = tblFavourite.cellForRow(at: indexPath) as! FavouriteTableViewCell
        cell.backgroundImage.image = UIImage(named:"1x-close-tab")
       // cell!.contentView.backgroundColor = .clear
    }
    func GetFavShopList()
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        let id = UserDefaults.standard.value(forKey: "ID") as! String
        let urlString = "\(Constants.kMyFavouriteShopsList)\(id)"
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(urlString, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                    
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let arrayOfService = serviceTypeObject?.value(forKey:"favouriteShops") as! NSArray
                    for i in 0..<arrayOfService.count {
                        let  dic =  NSMutableDictionary()
                        let serviceObject = arrayOfService[i] as! NSDictionary
                        print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        
                        let shopName = serviceObject.value(forKey: "shopName") as! String
                        let shopImage =   serviceObject.value(forKey: "shopImage") as? String
                        
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(shopName, forKey:"shopName")
                        dic.setValue(shopImage, forKey:"shopImage")
                        
                        self.arrayOfFavShop.add(dic)
                    }
                    MBProgressHUD.hide(for:self.view, animated:true)
                    if self.arrayOfFavShop.count > 0
                    {
                    self.tblFavourite.reloadData()
                    }
                    else
                    {
                      self.noOrderContainer.isHidden = false
                    
                    }
                }
                break
                
            case .failure(_):
                print(response.result.error as Any)
                MBProgressHUD.hide(for:self.view, animated:true)
                break
                
            }
        }
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        
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

    override func didRegister()
    {
        self.postRegisterationFinishedNotfication();
    }
    
    func addRegistrationFinishedObserver()
    {
        if !self.isUserDataAccessible {
            NotificationCenter.default.addObserver(self, selector: #selector(didFinishRegisterLater(notification:)), name: Notification.Name.kNotifRegLaterFinish, object: nil);
        }
    }
    
    func didFinishRegisterLater(notification: Notification)
    {
        DispatchQueue.main.async {
            self.GetFavShopList()
        }
    }
}
