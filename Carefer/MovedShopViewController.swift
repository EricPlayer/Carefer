//
//  MovedShopViewController.swift
//  Carefer
//
//  Created by Muzammal Hussain on 11/1/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD

class MovedShopViewController : MoveShopReceiveCarBaseController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var priceLabelHide: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var priceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceTypeContainer : UIView!
    @IBOutlet weak var priceContainer : UIView!
    @IBOutlet weak var serviceTypeTextField : UITextField!
    @IBOutlet weak var priceTextField : UITextField!
    
    var priceData = NSArray()
    var priceModle : Any! = nil;
    var priceSelectedData = NSMutableArray()
    
    override var isMovedShop: Bool {
        get {
            return true;
        }
    }
    
    override var textFields: [UITextField] {
        get {
            var fileds : [UITextField]! = [self.serviceTypeTextField, self.priceTextField];
            fileds = fileds + super.textFields;
            return fileds;
        }
    }
    
    override var parameters: [String : Any] {
        get {
            var params = [String : Any]();
            params["orderServiceType"] = "movedShop";
            params["serviceTypeID"] = self.serviceType!.id;
            //if self.priceSelectedData.count > 0{
            do{
                var dict : NSDictionary = ["PriceDetail":self.priceSelectedData]
             
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(JSONString)
                     params["price"] = JSONString ;
                }
                
                    self.addCommonParameters(params: &params);
                    return params;
                }
                catch {
                   // print(error.description)
                }
//            }else{
//                 params["price"] = nil ;
//                    //self.addCommonParameters(params: &params);
//                 return params;
//            }
            
            
            
            return params;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.isScrollEnabled=false
        self.tableView.delegate=self
        //self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.getDescription(url: Constants.kGetMovedShopDescriptionUrl);
        self.registerNotifications();
        self.updateAppearance();
        
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Moved Shop Screen")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    override func updateAppearance()
    {
        super.updateAppearance();
        self.priceLabelHide.text="الرجاء اختيار ماركة السيارة وموديلها ونوع الخدمة للحصول على السعر"
        self.serviceTypeContainer.backgroundColor = UIColor.clear;
        self.priceContainer.backgroundColor = UIColor.clear;
        //this call must be placed to get orange color for first responder
        self.updateAllTextFieldsAppearance();
    }
    
    override func didSelectBrand(brand: PopupModle) {
        super.didSelectBrand(brand: brand);
        self.serviceType = nil;
        self.serviceTypeTextField.text = "";
        self.carModle = nil;
        self.modelTextField.text = ""
        self.priceLabelHide.text="الرجاء اختيار ماركة السيارة وموديلها ونوع الخدمة للحصول على السعر"
        self.priceData=[]
        self.tableView.reloadData();
        getPrice();
    }
    
    override func didSelectModle(modle: PopupModle) {
        super.didSelectModle(modle: modle);
        getPrice();
    }
    
    override func didSelectServiceType(serviceType: PopupModle)
    {
        self.serviceType = serviceType;
        self.serviceTypeTextField.text = serviceType.name;
        getPrice();
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.priceData.count > 0{
            self.priceLabelHide.isHidden=true
        }else{
            
            self.priceLabelHide.isHidden=false
            self.tableViewHeight.constant = CGFloat((self.priceData.count * 20)+40)
            
        self.priceContainer.frame=CGRect(x:self.priceContainer.frame.origin.x,y:self.priceContainer.frame.origin.y,width:self.priceContainer.frame.size.width,height:self.tableView.frame.size.height)
            
            
            self.priceViewHeight.constant = CGFloat((self.priceData.count * 20)+45)
            
        }
        
        return self.priceData.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:PriceTableViewCell=self.tableView.dequeueReusableCell(withIdentifier: "CellData")  as! PriceTableViewCell
        cell.selectionStyle = .none
        let dataDic=self.priceData[indexPath.row] as! NSDictionary
        
        cell.lbl_Price.text = dataDic.object(forKey: "price") as! String
        cell.lbl_priceDescription.text = (dataDic.object(forKey: "priceDesc") as! String)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let temp = UIScreen.main.nativeBounds.height
        if temp == 1136{
            //return UITableViewAutomaticDimension
            return 44;
        }else if temp == 960{
            return 35;
        }else{
            return 30.0;//Choose your custom row height
        }
    }
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let temp = UIScreen.main.nativeBounds.height
        if temp == 1136{
            //return UITableViewAutomaticDimension 960
            return 44;
        }else if temp == 960{
            return 35;
        }
        else{
            return 30.0;//Choose your custom row height
        }
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var check=true
        let currentCell = tableView.cellForRow(at: indexPath) as! PriceTableViewCell
        let data=self.priceData[indexPath.row] as! NSDictionary
        if self.priceSelectedData.count == 0 {
            currentCell.img_box.image=UIImage(named:"checkbox")
            self.priceSelectedData.add(data)
        }else{
            for index in self.priceSelectedData{
                
                let dataDic=index as! NSDictionary
                if currentCell.lbl_Price.text == dataDic.object(forKey: "price") as! String{
                    currentCell.img_box.image=UIImage(named:"uncheckbox")
                    self.priceSelectedData.remove(dataDic)
                    check=false
                    
                }
                
            }
            
            if(check){
                    currentCell.img_box.image=UIImage(named:"checkbox")
                    self.priceSelectedData.add(data)
                
            }
            
        }
        
        
    }
    
    func getPrice()
    {
//        let alert = UIAlertController(title: "Alert", message: "Brand = \(self.carBrand?.id) model \(self.carModle?.id) service = \(self.serviceType?.id)", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        if let brand = self.carBrand, let modle = self.carModle, let type = self.serviceType {
            //this delay ensures that progress hud displays
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5){
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
                hud.label.text = "جاري التحميل";
            }
            
            //hit webservice for data
            Alamofire.request(Constants.kMovedShopPriceUrl, method: .post, parameters:["brand":Int64(brand.id!)!,"model":Int64(modle.id!)!,"servicetype":Int64(type.id!)!], headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    var showValidityAlert = false;
                    if response.result.value != nil {
                        
                        if let data = response.result.value as? [String : Any]
                        {
                            if let isValidPrice = data["price"] as? Bool, !isValidPrice {
                                showValidityAlert = true;
                            } else if let price = data["price"] as? NSArray, price.count > 0 {
                                
                                self.priceData = (data["price"] as? NSArray)!
                                if !(self.priceData.count > 0){
                                    self.priceLabelHide.text="عفواً.. لم يتم تحديد السعر لهذه الخدمة،، اطلب ونخدمك بعيوننا"
                                }
                                self.tableView.reloadData()
                                
                                let temp = UIScreen.main.nativeBounds.height
                                if temp == 1136{
                                    //self.tableView.layoutIfNeeded()
                                    self.tableViewHeight.constant = self.tableView.contentSize.height
                                    print(self.tableView.contentSize.height);
                                self.priceContainer.frame=CGRect(x:self.priceContainer.frame.origin.x,y:self.priceContainer.frame.origin.y,width:self.priceContainer.frame.size.width,height:self.tableView.contentSize.height)
                                    
                                    
                                    self.priceViewHeight.constant = CGFloat(self.tableView.contentSize.height+45)
                                    
                                    
                                }else if temp==960{
                                    self.tableViewHeight.constant = CGFloat((self.priceData.count * 35)+20)
                                    self.priceContainer.frame=CGRect(x:self.priceContainer.frame.origin.x,y:self.priceContainer.frame.origin.y,width:self.priceContainer.frame.size.width,height:self.tableView.frame.size.height)
                                    
                                    
                                    self.priceViewHeight.constant = CGFloat((self.priceData.count * 35)+25)
                                }
                                else{
                                self.tableViewHeight.constant = CGFloat((self.priceData.count * 25)+40)
                                self.priceContainer.frame=CGRect(x:self.priceContainer.frame.origin.x,y:self.priceContainer.frame.origin.y,width:self.priceContainer.frame.size.width,height:self.tableView.frame.size.height)
                                
                                
                                self.priceViewHeight.constant = CGFloat((self.priceData.count * 25)+45)
                                }
                                self.scrollView.translatesAutoresizingMaskIntoConstraints = true
                                self.priceTextField.text = "\(price)";
                                self.orderButton.isEnabled = true;
                                self.orderButton.isSelected = true;
                            } else {
                                //showValidityAlert = true;
                                self.priceLabelHide.text="عفواً.. لم يتم تحديد السعر لهذه الخدمة،، اطلب ونخدمك بعيوننا"
                                self.orderButton.isEnabled = true;
                                self.orderButton.isSelected = true;
                                self.priceData = []
                                self.tableView.reloadData()
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                        if showValidityAlert {
                            self.orderButton.isEnabled = false;
                            self.orderButton.isSelected = false;
                            let alert = UIAlertController(title: "كوت نوت أفايلابل", message: "لهذه العلامة التجارية ونموذج لم نتمكن من العثور على أي اقتباس.", preferredStyle: .alert);
                            alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: {(action) -> Void in
                                //_ = self.navigationController?.popViewController(animated: true);
                            }));
                            self.present(alert, animated: true, completion: nil);
                        }
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.tableView.reloadData()
                    });
                    break
                    
                case .failure(_):
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:{
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                        MBProgressHUD.hide(for: self.view, animated: true);
                        self.tableView.reloadData()
                    });
                    print(response.result.error as Any)
                    break
                    
                }
            }
        }
    }
    
}




