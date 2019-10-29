//
//  ViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/11/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import PhoneNumberKit

class ViewController: ReqRegParentController,UITextFieldDelegate ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var orderYellowBar:UILabel!
    @IBOutlet weak var navigationBar:UIView!
    
    @IBOutlet weak var roundedView :UIView!
    @IBOutlet weak var viewForCarBrand :UIView!
    @IBOutlet weak var viewForName :UIView!
    @IBOutlet weak var viewForPhoneNumber :UIView!
    @IBOutlet weak var viewForCarModel :UIView!
    @IBOutlet weak var viewForLastChangedOil :UIView!
    @IBOutlet weak var viewForKiloMeterAfterChangedOil :UIView!
    @IBOutlet weak var btnSave :UIButton!
    @IBOutlet weak var txtCarBrand:UITextField!
    @IBOutlet weak var txtCarModel:UITextField!
    @IBOutlet weak var txtLastChangedOil:UITextField!
    @IBOutlet weak var txtKilometerAfterChangedOil:UITextField!
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    @IBOutlet weak var lblNavigationItemTitle :UILabel!
    @IBOutlet weak var lblNavigationTitle:UILabel!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblPhone:UILabel!
    @IBOutlet weak var lblmodel:UILabel!
    @IBOutlet weak var lbllastChangeOil:UILabel!
    @IBOutlet weak var lblbrand:UILabel!
    @IBOutlet weak var lblKiloMaterAfterChangedOil:UILabel!
    @IBOutlet weak var lblMapButtonTitle :UILabel!
    
    
    @IBOutlet weak var tblModel:UITableView!
    @IBOutlet weak var tblCarbrand:UITableView!
    
    var arrayCararnd = NSMutableArray()
    var arrayModel = NSMutableArray()
    
    let layerGradient = CAGradientLayer()
    var modelId:String!
    var brandID:String!
    var CustomerID:String!
    var userNumberBeforeUpdate:String!
    var region:String!
    var code:String!
    var isValid = false
    let phoneNumberKit = PhoneNumberKit()
    var phoneNumber:String!
    var kbHeight: CGFloat!
    var CurrentTextFiledTag = 0
    
    let datePickerView:UIDatePicker = UIDatePicker()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let topShadow = EdgeShadowLayer(forView:self.navigationBar, edge:.Bottom)
        //self.navigationBar.layer.addSublayer(topShadow)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.tblModel.tableFooterView = UIView()
        self.tblCarbrand.tableFooterView = UIView()
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.lblName.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblPhone.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblmodel.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lbllastChangeOil.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblbrand.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblKiloMaterAfterChangedOil.font = UIFont(name:Constants.kShahidFont,size:21)
            
            self.btnSave.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:21)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:21)
        case .phone:
            print("iPhone and iPod touch style UI")
            self.lblName.font = UIFont(name:Constants.kShahidFont,size:13)
            self.lblPhone.font = UIFont(name:Constants.kShahidFont,size:13)
            self.lblmodel.font = UIFont(name:Constants.kShahidFont,size:13)
            self.lbllastChangeOil.font = UIFont(name:Constants.kShahidFont,size:13)
            self.lblbrand.font = UIFont(name:Constants.kShahidFont,size:13)
            self.lblKiloMaterAfterChangedOil.font = UIFont(name:Constants.kShahidFont,size:10)
            self.lblMapButtonTitle.font = UIFont(name:Constants.kShahidFont ,size:13)
            self.btnSave.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:14)
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:16)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.locale = NSLocale.init(localeIdentifier: "ar") as Locale
        self.txtLastChangedOil.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        self.modelId  = ""
        self.brandID = ""
        
        if self.isUserDataAccessible
        {
            self.getUserProfile()   
        } else {
            self.addRegistrationFinishedObserver();
        }
        
        self.viewForName.layer.borderWidth = 0.5
        self.viewForName.layer.borderColor = UIColor.lightGray.cgColor
        self.viewForName.layer.cornerRadius = 5
        
        self.viewForKiloMeterAfterChangedOil.layer.borderWidth = 0.5
        self.viewForKiloMeterAfterChangedOil.layer.borderColor = UIColor.lightGray.cgColor
        self.viewForKiloMeterAfterChangedOil.layer.cornerRadius = 5
        
        self.viewForPhoneNumber.layer.borderWidth = 0.5
        self.viewForPhoneNumber.layer.borderColor = UIColor.lightGray.cgColor
        self.viewForPhoneNumber.layer.cornerRadius = 5
        
        
        self.viewForCarBrand.layer.borderWidth = 0.5
        self.viewForCarBrand.layer.borderColor = UIColor.lightGray.cgColor
        self.viewForCarBrand.layer.cornerRadius = 5
        
        self.viewForCarModel.layer.borderWidth = 0.5
        self.viewForCarModel.layer.borderColor = UIColor.lightGray.cgColor
        self.viewForCarModel.layer.cornerRadius = 5
        
        self.viewForLastChangedOil.layer.borderWidth = 0.5
        self.viewForLastChangedOil.layer.borderColor = UIColor.lightGray.cgColor
        self.viewForLastChangedOil.layer.cornerRadius = 5
        
        
        var tabFrame = self.tabBarController?.tabBar.frame
        
        
       // tabFrame?.size.height = 60
    //tabFrame?.origin.y = self.view.frame.size.height - 70
        self.tabBarController?.tabBar.frame = tabFrame!
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
        self.tabBarController?.tabBar.backgroundImage=UIImage(named:"1x-shadow-bg")
        //self.tabBarController?.tabBar.itemPositioning = .fill
        let totalSpace = UIScreen.main.bounds.width / 5
        self.tabBarController?.tabBar.itemWidth = totalSpace - 50
        self.tblCarbrand.isHidden = true
        self.tblModel.isHidden = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = false
        
        
            
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Profile Screen")
            
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
            
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                kbHeight = keyboardSize.height
                self.animateTextField(up: true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateTextField(up: false)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    func animateTextField(up: Bool) {
        if self.CurrentTextFiledTag == 0 || self.CurrentTextFiledTag == 1 || self.CurrentTextFiledTag == 2
        {
            
        }
        else
        {
            let movement = (up ? -kbHeight : kbHeight)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement!)
            })
            
        }
        
    }
    override func viewWillLayoutSubviews() {
        
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
    @IBAction func btnSave(sender:UIButton)
    {
        self.txtName.resignFirstResponder()
        self.txtPhoneNumber.resignFirstResponder()
        self.txtCarBrand.resignFirstResponder()
        self.txtCarModel.resignFirstResponder()
        self.txtLastChangedOil.resignFirstResponder()
        self.txtKilometerAfterChangedOil.resignFirstResponder()
        if self.modelId != ""
        {
            
            
            if userNumberBeforeUpdate == self.txtPhoneNumber.text
            {
                self.UpdateUserProfile()
            }
            else
            {
                
                do {
                    
                    
                    
                    let phoneNumberValidator = self.txtPhoneNumber.text!.isPhoneNumber
                    if phoneNumberValidator == true
                    {
                        isValid = true
                        let phoneNumberthis = "\(self.txtPhoneNumber.text!)"
                        let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(phoneNumberthis)
                        let neumberafterPlus =   phoneNumberKit.format(phoneNumberCustomDefaultRegion, toType: .e164)
                        print(neumberafterPlus)
                        let num = neumberafterPlus.chopPrefix()
                        let trimmedString = num.removingWhitespaces()
                        print(trimmedString)
                        phoneNumber = trimmedString
                        
                    }
                    else
                    {
                        isValid = false
                    }
                }
                catch {
                    print("Generic parser error")
                    isValid = false
                    
                }
                
                if isValid == true
                {
                    
                    let uiAlert = UIAlertController(title:nil, message:"وجدنا أنه تغير رقمك، نحن بحاجة إلى التحقق منه أولا، كل البيانات محفوظة", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    
                    uiAlert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
                        self.postPhoneNumberOnServerToupdate()
                        self.txtPhoneNumber.text = self.phoneNumber
                        
                        
                    }))
                    
                    uiAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { action in
                        //println("Click of cancel button")
                    }))
                    
                    
                    
                    
                }
                else
                {
                    
                    
                    let alert = UIAlertController(title: "Carefer", message: "يرجى إدخال رقم جوال صحيح", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Carefer", message: "الرجاء الاختيار من القائمة المنسدلة", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            
        }
        
        
    }
    @IBAction func dp(_ sender: UITextField) {
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.txtLastChangedOil.text = dateFormatter.string(from: sender.date)
        self.txtLastChangedOil.resignFirstResponder()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 0
        {
            return self.arrayCararnd.count
        }
        else
        {
            return self.arrayModel.count
        }
        //return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView.tag == 0
        {
            let cell:DropDownTableViewCell = self.tblCarbrand.dequeueReusableCell(withIdentifier:"ServiceAndBrandCell") as! DropDownTableViewCell!
            let dic = self.arrayCararnd[indexPath.row] as! NSMutableDictionary
            cell.lblServicetypeOrBrand.text = dic.value(forKey: "brandName")as? String
            
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont , size:21)
            case .phone:
                print("iPhone and iPod touch style UI")
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont , size:16)
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }
            
            
            return cell
        }
        else
        {
            let cell:DropDownTableViewCell = self.tblModel.dequeueReusableCell(withIdentifier:"ServiceAndBrandCell") as! DropDownTableViewCell!
            let dic = self.arrayModel[indexPath.row] as! NSMutableDictionary
            cell.lblServicetypeOrBrand.text = dic.value(forKey: "modelName")as? String
            
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont , size:21)
            case .phone:
                print("iPhone and iPod touch style UI")
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont , size:16)
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }
            
            
            return cell
            
        }
        
        // set the text from the data model
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dic = NSMutableDictionary()
        
        
        
        if tableView.tag == 0
        {
            dic = self.arrayCararnd[indexPath.row]as! NSMutableDictionary
            self.brandID = dic.value(forKey: "ID") as? String
            self.txtCarBrand.text = dic.value(forKey: "brandName") as? String
            UserDefaults.standard.set(self.brandID, forKey:"brandID")
            self.arrayModel = []
            self.getModels()
            
            
        }
        else
        {
            dic = self.arrayModel[indexPath.row]as! NSMutableDictionary
            self.modelId = dic.value(forKey: "ID") as? String
            self.txtCarModel.text = dic.value(forKey: "modelName") as? String
            UserDefaults.standard.set(self.modelId, forKey:"modelId")
            
        }
        self.txtCarModel.resignFirstResponder()
        self.txtCarBrand.resignFirstResponder()
        self.tblCarbrand.isHidden = true
        self.tblModel.isHidden = true
        print("You tapped cell number \(indexPath.row).")
    }
    
    
    func getCarBrand()
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.kBrandData, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let arrayOfService = serviceTypeObject?.value(forKey:"brandsData") as! NSArray
                        for i in 0..<arrayOfService.count {
                            let  dic =  NSMutableDictionary()
                            let serviceObject = arrayOfService[i] as! NSDictionary
                            print(serviceObject)
                            let id = serviceObject.value(forKey: "ID") as! String
                            let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                            let serviceTypeName = serviceObject.value(forKey: "brandName") as! String
                            
                            dic.setValue(id, forKey:"ID")
                            dic.setValue(dateAdded, forKey:"dateAdded")
                            dic.setValue(serviceTypeName, forKey:"brandName")
                            self.arrayCararnd.add(dic)
                        }
                        
                        MBProgressHUD.hide(for:self.view, animated:true)
                        self.tblCarbrand.reloadData()
                        
                        
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
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getModels()
    {
        
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            
            if self.brandID != ""
            {
                
                
                var parameter = [String:Any]()
                parameter = ["brandID":self.brandID]
                self.arrayModel = []
                MBProgressHUD.showAdded(to: self.view, animated:true)
                Alamofire.request(Constants.getbrandmodels, method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
                    
                    switch(response.result) {
                    case .success(_):
                        if response.result.value != nil{
                            print(response.result.value as Any)
                            let  serviceTypeObject = response.result.value as? NSDictionary
                            let arrayOfService = serviceTypeObject?.value(forKey:"models") as! NSArray
                            for i in 0..<arrayOfService.count {
                                let  dic =  NSMutableDictionary()
                                let serviceObject = arrayOfService[i] as! NSDictionary
                                print(serviceObject)
                                let id = serviceObject.value(forKey: "ID") as! String
                                let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                                let serviceTypeName = serviceObject.value(forKey: "modelName") as! String
                                
                                dic.setValue(id, forKey:"ID")
                                dic.setValue(dateAdded, forKey:"dateAdded")
                                dic.setValue(serviceTypeName, forKey:"modelName")
                                self.arrayModel.add(dic)
                            }
                            if self.arrayModel.count == 0
                            {
                                let alert = UIAlertController(title: "Carefer", message: "لم يتم العثور على أي سجل حتى الآن!", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.modelId = ""
                                self.txtCarModel.text = ""
                                self.tblCarbrand.isHidden = true
                                self.tblModel.isHidden = true
                                
                            }
                            else
                            {
                                self.tblCarbrand.isHidden = true
                                self.tblModel.isHidden = true
                                self.tblModel.reloadData()
                            }
                            
                            MBProgressHUD.hide(for:self.view, animated:true)
                            
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
                
                let alert = UIAlertController(title: "Carefer", message: "يرجى اختيار العلامة التجارية", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            self.tblCarbrand.isHidden = true
            self.tblModel.isHidden = true
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    func postPhoneNumberOnServerToupdate()
    {
        
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            
            var parameter = [String:Any]()
            parameter = ["mobileNumber":self.phoneNumber!,"customerID":CustomerID]
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.kchangemobilenumber , method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let meessage = response.result.value as? NSDictionary
                        print(meessage)
                        let customer = meessage?.value(forKey:"customer") as? NSDictionary
                        print(customer)
                        let APIResponse = customer?.value(forKey:"APIResponse") as? String
                        if APIResponse == "SMS sent successfully."
                        {
                            let verificationVc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVc")as! VerifictionViewController
                            verificationVc.isFromMyDetail = "yes"
                            verificationVc.mobileNumberFromDetail = self.phoneNumber
                            UserDefaults.standard.set("no", forKey:"IsVerifyAsRoot")
                            self.navigationController?.pushViewController(verificationVc, animated:true)
                        }
                        else
                        {
                            
                            let alert = UIAlertController(title: "Carefer", message: "رقم الجوال موجودة بالفعل في قاعدة البيانات الخاصة بنا", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        
                        MBProgressHUD.hide(for:self.view, animated:true)
                        MBProgressHUD.hide(for:self.view, animated:true)
                        
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
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func UpdateUserProfile()
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        
        
        if isAvailableNet == true
        {
            //let ModelId = UserDefaults.standard.value(forKey: "modelId") as! String
            // let brandid = UserDefaults.standard.value(forKey: "brandID") as! String
            let id = UserDefaults.standard.value(forKey: "ID") as! String
            var parameter = [String:Any]()
            parameter = ["customerName":self.txtName.text!,"customerMobile":self.txtPhoneNumber.text!,"isVerified":"1","carBrand":self.brandID,"carModel":self.modelId,"lastOilChange":self.txtLastChangedOil.text!,"oilKM":self.txtKilometerAfterChangedOil.text!]
            print(parameter)
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.kUpdateUserProfile + id , method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let serviceObject = serviceTypeObject?.value(forKey:"customerDetails") as! NSDictionary
                        
                        print(serviceObject)
                        //let id = serviceObject.value(forKey: "ID") as! String
                        let customerMobile = serviceObject.value(forKey: "customerMobile") as! String
                        let customerName = serviceObject.value(forKey: "customerName") as! String
                        let isVerified = serviceObject.value(forKey: "isVerified") as! String
                        let lastChangedOil = serviceObject.value(forKey: "lastOilChange") as? String
                        let carBrand = serviceObject.value(forKey: "carBrand") as? String
                        let carModel = serviceObject.value(forKey: "carModel") as? String
                        let oilKm = serviceObject.value(forKey: "oilKM") as? String
                        self.txtKilometerAfterChangedOil.text = oilKm
                        self.txtCarBrand.text = carBrand
                        self.txtCarModel.text = carModel
                        self.txtLastChangedOil.text = lastChangedOil
                        self.txtPhoneNumber.text = customerMobile
                        self.txtName.text = customerName
                        
                        UserDefaults.standard.set(id, forKey:"ID")
                        UserDefaults.standard.set(customerMobile, forKey:"customerMobile")
                        UserDefaults.standard.set(customerName, forKey:"customerName")
                        UserDefaults.standard.set(isVerified, forKey:"isVerified")
                        
                        
                        
                        
                        MBProgressHUD.hide(for:self.view, animated:true)
                        
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
            
        {let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
    }
    
    func getUserProfile()
    {
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            let id = UserDefaults.standard.value(forKey: "ID") as! String
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.kGetUserProfile + id , method: .get, parameters:nil, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let serviceObject = serviceTypeObject?.value(forKey:"customerDetail") as! NSDictionary
                        
                        print(serviceObject)
                        // let id = serviceObject.value(forKey: "ID") as! String
                        let customerMobile = serviceObject.value(forKey: "customerMobile") as! String
                        let customerName = serviceObject.value(forKey: "customerName") as! String
                        let isVerified = serviceObject.value(forKey: "isVerified") as! String
                        let lastChangedOil = serviceObject.value(forKey: "lastOilChange") as? String
                        let carBrand = serviceObject.value(forKey: "carBrand") as? String
                        let carModel = serviceObject.value(forKey: "carModel") as? String
                        let oilKm = serviceObject.value(forKey: "oilKM") as? String
                        self.txtKilometerAfterChangedOil.text = oilKm
                        self.txtCarBrand.text = carBrand
                        self.txtCarModel.text = carModel
                        self.txtLastChangedOil.text = lastChangedOil
                        self.txtPhoneNumber.text = customerMobile
                        self.txtName.text = customerName
                        self.brandID = serviceObject.value(forKey: "carBrandId") as? String
                        self.modelId = serviceObject.value(forKey: "carModelId") as? String
                        self.userNumberBeforeUpdate = customerMobile
                        self.CustomerID = id
                        UserDefaults.standard.set(id, forKey:"ID")
                        UserDefaults.standard.set(customerMobile, forKey:"customerMobile")
                        UserDefaults.standard.set(customerName, forKey:"customerName")
                        UserDefaults.standard.set(isVerified, forKey:"isVerified")
                        
                        MBProgressHUD.hide(for:self.view, animated:true)
                        self.getCarBrand()
                        
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tblCarbrand.isHidden = true
        self.tblModel.isHidden = true
        
        self.txtName.resignFirstResponder()
        self.txtPhoneNumber.resignFirstResponder()
        self.txtCarBrand.resignFirstResponder()
        self.txtCarModel.resignFirstResponder()
        self.txtLastChangedOil.resignFirstResponder()
        self.txtKilometerAfterChangedOil.resignFirstResponder()
    }
    // Mark text field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.CurrentTextFiledTag = textField.tag
        if textField.tag == 2
        {
            self.txtCarModel.resignFirstResponder()
            self.txtName.resignFirstResponder()
            self.txtCarBrand.resignFirstResponder()
            self.txtPhoneNumber.resignFirstResponder()
            self.txtLastChangedOil.resignFirstResponder()
            self.txtKilometerAfterChangedOil.resignFirstResponder()
            self.tblCarbrand.isHidden = false
            self.tblModel.isHidden = true
            
        }
        else
            if textField.tag == 3
            {
                if self.arrayModel.count != 0
                {
                    self.tblCarbrand.isHidden = true
                    self.tblModel.isHidden = false
                }
                self.txtCarModel.resignFirstResponder()
                self.txtName.resignFirstResponder()
                self.txtCarBrand.resignFirstResponder()
                self.txtPhoneNumber.resignFirstResponder()
                self.txtLastChangedOil.resignFirstResponder()
                self.txtKilometerAfterChangedOil.resignFirstResponder()
                
                
            }
                
            else
            {
                self.tblCarbrand.isHidden = true
                self.tblModel.isHidden = true
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 5 ||  textField.tag == 0
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        else
        {
            return true
        }
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.txtName.resignFirstResponder()
        self.txtPhoneNumber.resignFirstResponder()
        self.txtCarBrand.resignFirstResponder()
        self.txtCarModel.resignFirstResponder()
        self.txtLastChangedOil.resignFirstResponder()
        self.txtKilometerAfterChangedOil.resignFirstResponder()
        do {
            
            let phoneNumberValidator = self.txtPhoneNumber.text!.isPhoneNumber
            if phoneNumberValidator == true
            {
                isValid = true
                let phoneNumberthis = "\(self.txtPhoneNumber.text!)"
                let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(phoneNumberthis)
                let neumberafterPlus =   phoneNumberKit.format(phoneNumberCustomDefaultRegion, toType: .e164)
                print(neumberafterPlus)
                let num = neumberafterPlus.chopPrefix()
                let trimmedString = num.removingWhitespaces()
                print(trimmedString)
                phoneNumber = trimmedString
                
            }
            else
            {
                isValid = false
            }
            
            
        }
        catch {
            print("Generic parser error")
            isValid = false
            
        }
        
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtName.resignFirstResponder()
        self.txtPhoneNumber.resignFirstResponder()
        self.txtCarBrand.resignFirstResponder()
        self.txtCarModel.resignFirstResponder()
        self.txtLastChangedOil.resignFirstResponder()
        self.txtKilometerAfterChangedOil.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            self.getUserProfile();
        }
    }
}
class GradientView: UIView {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}
extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 70
        return sizeThatFits
    }
}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
