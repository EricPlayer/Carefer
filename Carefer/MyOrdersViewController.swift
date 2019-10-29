//
//  MyOrdersViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/12/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class MyOrdersViewController: ReqRegParentController,UITableViewDelegate,UITableViewDataSource {
@IBOutlet weak var roundedView :UIView!
    @IBOutlet weak var noOrderContainer: UIView!
    @IBOutlet weak var lblDefaultText: UILabel!
@IBOutlet weak var tblMyOrders :UITableView!
@IBOutlet weak var WhiteRoundedView :UIView!
@IBOutlet weak var lblNavigationTitle:UILabel!
@IBOutlet weak var orderYellowBar:UILabel!
@IBOutlet weak var lblMapButtonTitle :UILabel!
@IBOutlet weak var navigationBar:UIView!
    var arrayOfMyOrders = NSMutableArray()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let layerGradient = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
       // let topShadow = EdgeShadowLayer(forView:self.navigationBar, edge:.Bottom)
        //self.navigationBar.layer.addSublayer(topShadow)

        
        self.noOrderContainer.isHidden = true
        var tabFrame = self.tabBarController?.tabBar.frame
       
        //tabFrame?.size.height = 60
       // tabFrame?.origin.y = self.view.frame.size.height - 70
        self.tabBarController?.tabBar.backgroundImage=UIImage(named:"1x-shadow-bg")
        self.tabBarController?.tabBar.frame = tabFrame!
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
        let totalSpace = UIScreen.main.bounds.width / 5
        self.tabBarController?.tabBar.itemWidth = totalSpace - 50
        self.tabBarController?.tabBar.clipsToBounds = true
        
        self.lblMapButtonTitle.font =  UIFont(name:Constants.kShahidFont ,size:13)
        self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:16)
        self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:16)
        self.tblMyOrders.delegate = self
        self.tblMyOrders.dataSource = self
        self.tblMyOrders.estimatedRowHeight = 36
        self.tblMyOrders.rowHeight = UITableViewAutomaticDimension
        self.tblMyOrders.separatorStyle = .none
        
         if !self.isUserDataAccessible {
            self.addRegistrationFinishedObserver();
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated);
        if self.isUserDataAccessible
        {
            self.getOrders()
        }
        
        
       
            
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "My Order Screen")
        
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
        //UserDefaults.standard.set("no", forKey: "isFirstForCity")
        appDelegate.setHomeVc()
    }
    // Mark Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfMyOrders.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "Cell"
        var cell: myOrderTableViewCell! = tblMyOrders.dequeueReusableCell(withIdentifier: identifier) as? myOrderTableViewCell
        if cell == nil
        {
            tblMyOrders.register(UINib(nibName: "myOrderTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? myOrderTableViewCell
        }
        let orderObject = self.arrayOfMyOrders[indexPath.row] as! NSDictionary
        
        let orderID=Int(orderObject.value(forKey: "orderNo")as! String)
        let temp = (String(format: "%07d", orderID!))
        
        let orderNo = temp
        let orderDate = orderObject.value(forKey: "orderDate")as! String
        let shopName = (orderObject.value(forKey: "shopName") as? String) ?? ""
        let orderType = orderObject.value(forKey: "orderType")as! String
        let shopRating = orderObject.value(forKey: "shopRating")as! String
        let orderServiceTypeID = orderObject.value(forKey: "orderServiceTypeID")as! String
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // read input date string as NSDate instance
        if let date = formatter.date(from: orderDate) {
            
            // set locale to "ar_DZ" and format as per your specifications
            formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
            formatter.dateFormat = "yyyy-MM-dd"
            let outputDate = formatter.string(from: date)
            cell.lblOrderDate.text = "تاريخ الطلب:\(outputDate)"
            cell.lblOrderDateForShort.text = "تاريخ :\(outputDate)"
            print(outputDate) // الأربعاء, 9 مارس, 2016 10:33 ص
        }
        
        if orderServiceTypeID == "1" {
            cell.lblShopName.text = "الورشة:\(shopName)"
        }else {
            let brandName = orderObject.value(forKey: "brandName")as! String
            cell.lblShopName.text = "اسم الماركة:\(brandName)"
        }
        
        if orderServiceTypeID == "1"{
        
            if orderType == "navigate"
            {
                cell.lblOrderType.text = "نوع الطلب: ملاحة"
            }
            else
            {
                cell.lblOrderType.text = "نوع الطلب:مكالمة"
            }
        }else if orderServiceTypeID == "2"{
            cell.lblOrderType.text = "نوع الطلب:الورشة المتنقلة"
        }else{
            cell.lblOrderType.text=" نوع الطلب :استلام السيارة"
        }

        if orderServiceTypeID == "1" {
            cell.lblShopRating.text = " تقييم الورشة:\(shopRating)"
        }else {
            var temp = orderObject.value(forKey: "modelName")as? String
            
            if temp != nil {
                let modelName = orderObject.value(forKey: "modelName")as! String
                cell.lblShopRating.text = "اسم نوع السيارة:\(modelName)"
            }else{
               cell.lblShopRating.text = "اسم نوع السيارة: "
            }
            
        }
        
        if orderServiceTypeID == "1" {
           
        }else {
            cell.btnRateShop.setTitle("تفاصيل الطلب", for: .normal)
        }
        
        
        
        cell.lblOrderNumber.text = "رقم الطلب # \(orderNo)"
        cell.lblOrderNumberForShort.text = "رقم الطلب # \(orderNo)"
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.lblDefaultText.font = UIFont(name:Constants.kShahidFont,size:21)
            cell.btnRateShop.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:21)
            cell.lblShopName.font = UIFont(name:Constants.kShahidFont ,size:21)
            cell.lblOrderDate.font = UIFont(name:Constants.kShahidFont ,size:21)
            cell.lblOrderDateForShort.font = UIFont(name:Constants.kShahidFont ,size:21)
            cell.lblOrderType.font = UIFont(name:Constants.kShahidFont ,size:21)
            cell.lblShopRating.font = UIFont(name:Constants.kShahidFont ,size:21)
            
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:21)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:21)
            
            cell.lblOrderNumber.font = UIFont(name:Constants.kShahidFont ,size:21)
            cell.lblOrderNumberForShort.font = UIFont(name:Constants.kShahidFont ,size:21)
        case .phone:
            print("iPhone and iPod touch style UI")
            self.lblDefaultText.font = UIFont(name:Constants.kShahidFont,size:16)
            cell.lblShopName.font = UIFont(name:Constants.kShahidFont ,size:16)
            cell.lblOrderDate.font = UIFont(name:Constants.kShahidFont ,size:16)
            cell.lblOrderDateForShort.font = UIFont(name:Constants.kShahidFont ,size:11)
            cell.lblOrderType.font = UIFont(name:Constants.kShahidFont ,size:16)
            cell.lblShopRating.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:16)
            cell.lblOrderNumber.font = UIFont(name:Constants.kShahidFont ,size:16)
            cell.lblOrderNumberForShort.font = UIFont(name:Constants.kShahidFont ,size:10)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }

       
        
        
        

        if orderObject.value(forKey: "isCollapsed") as! Bool == false
        {
            
            cell.detailView.isHidden = true
            cell.shortView.isHidden = false
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                cell.lblShopName.font = UIFont(name:Constants.kShahidFont ,size:21)
                cell.shortViewHeightConstraint.constant = 80
                cell.detailViewHeightConstraint.constant = 0
            case .phone:
                print("iPhone and iPod touch style UI")
                cell.shortViewHeightConstraint.constant = 49
                cell.detailViewHeightConstraint.constant = 0
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }

           
            
        }
        else
        {
            
            cell.detailView.isHidden = false
            cell.shortView.isHidden = true
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
               
                
                cell.shortViewHeightConstraint.constant = 0
                cell.detailViewHeightConstraint.constant = 300
            case .phone:
                print("iPhone and iPod touch style UI")
                cell.shortViewHeightConstraint.constant = 0
                cell.detailViewHeightConstraint.constant = 188
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }

            
        }
        cell.detailView.layer.cornerRadius = 5
        cell.detailView.clipsToBounds = true
        cell.btnRateShop.layer.cornerRadius = 10
        cell.btnRateShop.addTarget(self, action:#selector(MyOrdersViewController.btnRateShop(sender:)), for:UIControlEvents.touchUpInside)
        cell.btnRateShop.tag = indexPath.row
       

        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dic = self.arrayOfMyOrders[indexPath.row] as! NSDictionary
        if dic.value(forKey: "isCollapsed") as! Bool == true
        {
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                return 300
            case .phone:
                return 188
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
                return 0
            }

        }
        else
        {
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                return 80
            case .phone:
                print("iPhone and iPod touch style UI")
               return 49
            case .tv:
                print("tvOS style UI")
            default:
                return 0
                print("Unspecified UI idiom")
            }

        }
        return UITableViewAutomaticDimension
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let newArray =  NSMutableArray()
        for i in 0..<self.arrayOfMyOrders.count
        {
            let dic = self.arrayOfMyOrders[i]as! NSDictionary
            let newObject = NSMutableDictionary()
            if i == indexPath.row
            {
                
                
                newObject.setValue(dic.value(forKey: "isRated"), forKey:"isRated")
                newObject.setValue(dic.value(forKey: "ID"), forKey:"ID")
                newObject.setValue(dic.value(forKey: "brandName"), forKey:"brandName")
                newObject.setValue(dic.value(forKey: "modelName"), forKey:"modelName")
                newObject.setValue(dic.value(forKey: "orderNo"), forKey:"orderNo")
                newObject.setValue(dic.value(forKey: "orderStatus"), forKey:"orderStatus")
                newObject.setValue(dic.value(forKey: "orderType"), forKey:"orderType")
                newObject.setValue(dic.value(forKey: "orderDate"), forKey:"orderDate")
                newObject.setValue(dic.value(forKey: "serviceTypeName"), forKey:"serviceTypeName")
                newObject.setValue(dic.value(forKey: "shopID"), forKey:"shopID")
                newObject.setValue(dic.value(forKey: "shopName"), forKey:"shopName")
                newObject.setValue(dic.value(forKey: "shopRating"), forKey:"shopRating")
                newObject.setValue(dic.value(forKey: "orderServiceTypeID"), forKey:"orderServiceTypeID")
                if dic.value(forKey: "isCollapsed") as! Bool == true
                {
                    newObject.setValue(false, forKey:"isCollapsed")
                    
                }
                else
                {
                    newObject.setValue(true, forKey:"isCollapsed")
                    
                }
                
                
            }
            else
            {
                newObject.setValue(dic.value(forKey: "isRated"), forKey:"isRated")
                newObject.setValue(dic.value(forKey: "ID"), forKey:"ID")
                newObject.setValue(dic.value(forKey: "brandName"), forKey:"brandName")
                newObject.setValue(dic.value(forKey: "modelName"), forKey:"modelName")
                newObject.setValue(dic.value(forKey: "orderNo"), forKey:"orderNo")
                newObject.setValue(dic.value(forKey: "orderStatus"), forKey:"orderStatus")
                newObject.setValue(dic.value(forKey: "orderType"), forKey:"orderType")
                newObject.setValue(dic.value(forKey: "orderDate"), forKey:"orderDate")
                newObject.setValue(dic.value(forKey: "serviceTypeName"), forKey:"serviceTypeName")
                newObject.setValue(dic.value(forKey: "shopID"), forKey:"shopID")
                newObject.setValue(dic.value(forKey: "shopName"), forKey:"shopName")
                newObject.setValue(dic.value(forKey: "shopRating"), forKey:"shopRating")
                newObject.setValue(dic.value(forKey: "orderServiceTypeID"), forKey:"orderServiceTypeID")
                newObject.setValue(false, forKey:"isCollapsed")
                
                
            }
            
            newArray.add(newObject)
        }
        self.arrayOfMyOrders = []
        self.arrayOfMyOrders = newArray
        //let nindexPath = IndexPath(row: sender.tag, section: 0)
        //self.tblShopList.reloadRows(at:[nindexPath] , with:.automatic)
        self.tblMyOrders.reloadData()
        

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func btnRateShop(sender:UIButton)
    {
       
        
        
        let dic = self.arrayOfMyOrders[sender.tag] as! NSDictionary
        let isRated = dic.value(forKey: "isRated") as! String
        let orderServiceTypeID = dic.value(forKey: "orderServiceTypeID") as! String
        
        if orderServiceTypeID == "1"{
            if isRated == "0"
            {
                let rateVc =  self.storyboard?.instantiateViewController(withIdentifier: "RateVC")as! RateShopViewController
                rateVc.orderId = dic.value(forKey: "ID") as! String!
                rateVc.shopId = dic.value(forKey: "shopID") as! String!
                rateVc.shopName = dic.value(forKey: "shopName") as! String!
                self.navigationController?.pushViewController(rateVc, animated:true)
           }
        else
            {
                let alert = UIAlertController(title: "Carefer", message: "تمت إضافة التعليق من قبل", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            
            let detailOrderVC =  self.storyboard?.instantiateViewController(withIdentifier: "DetailOrderViewController")as! DetailOrderViewController
                detailOrderVC.orderID = dic.value(forKey: "orderNo") as! String!
//            rateVc.shopId = dic.value(forKey: "shopID") as! String!
//            rateVc.shopName = dic.value(forKey: "shopName") as! String!
            self.navigationController?.pushViewController(detailOrderVC, animated:true)
        }
        
        
        
        
        
    }

    
    
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getOrders()
    {
         UserDefaults.standard.set(false, forKey:"isLarge")
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        let id = UserDefaults.standard.value(forKey: "ID") as! String
        let urlString = "\(Constants.kMyOrdersList)\(id)"
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(urlString, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                
                if response.result.value != nil{
                    self.arrayOfMyOrders = []
                    print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let arrayOfService = serviceTypeObject?.value(forKey:"ordersData") as! NSArray
                    for i in 0..<arrayOfService.count {
                        var  dic =  NSMutableDictionary()
                        let serviceObject = arrayOfService[i] as! NSDictionary
                        print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let brandName = serviceObject.value(forKey: "brandName") as? String
                        let modelName = serviceObject.value(forKey: "modelName") as? String
                        let orderDate = serviceObject.value(forKey: "orderDate") as? String
                        let orderNo = serviceObject.value(forKey: "orderNo") as? String
                        let orderStatus = serviceObject.value(forKey: "orderStatus") as? String
                        let orderType = serviceObject.value(forKey: "orderType") as? String
                        let serviceTypeName = serviceObject.value(forKey: "serviceTypeName") as? String
                        let shopID = serviceObject.value(forKey: "shopID") as? String
                        let shopName = serviceObject.value(forKey: "shopName") as? String
                        let shopRating = serviceObject.value(forKey: "shopRating") as? String
                        let isRated = serviceObject.value(forKey: "isRated") as? String
                        let orderServiceTypeID = serviceObject.value(forKey: "orderServiceTypeID") as? String
                        
                        
                        dic.setValue(orderServiceTypeID, forKey:"orderServiceTypeID")
                        dic.setValue(isRated, forKey:"isRated")
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(brandName, forKey:"brandName")
                        if modelName != nil {
                            dic.setValue(modelName, forKey:"modelName")
                        }else{
                             dic.setValue(modelName, forKey:"")
                        }
                        dic.setValue(orderNo, forKey:"orderNo")
                        dic.setValue(orderStatus, forKey:"orderStatus")
                        dic.setValue(orderType, forKey:"orderType")
                        dic.setValue(orderDate, forKey:"orderDate")
                        dic.setValue(serviceTypeName, forKey:"serviceTypeName")
                        dic.setValue(shopID, forKey:"shopID")
                        dic.setValue(shopName, forKey:"shopName")
                        dic.setValue(shopRating, forKey:"shopRating")
                        dic.setValue(false, forKey:"isCollapsed")
                        self.arrayOfMyOrders.add(dic)
                    }
                    MBProgressHUD.hide(for:self.view, animated:true)
                    if self.arrayOfMyOrders.count > 0
                    {
                    self.tblMyOrders.reloadData()
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
            self.getOrders();
        }
    }

}
