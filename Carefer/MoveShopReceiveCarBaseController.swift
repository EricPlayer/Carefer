//
//  MoveShopReceiveCarBaseController.swift
//  Carefer
//
//  Created by Muzammal Hussain on 11/3/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Alamofire
import MBProgressHUD

class MoveShopReceiveCarBaseController : ReqRegParentController
{
    
    @IBOutlet weak var brandContainer : UIView!
    @IBOutlet weak var modleContainer : UIView!
    @IBOutlet weak var brandTextField : UITextField!
    @IBOutlet weak var modelTextField : UITextField!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var orderButton : UIButton!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate;
    var firstResponder : UITextField? = nil;
    var contentInsets : UIEdgeInsets? = nil;
    var timer : Timer! = nil;
    lazy var popupView : PopupTableView = {
        var view = PopupTableView(frame: self.view.bounds);
        view.popupDelegate = self;
        return view;
    }();
    var carBrand : PopupModle? = nil;
    var carModle : PopupModle? = nil;
    var serviceType : PopupModle? = nil;
    //this property must be override by child class
    var parameters : [String : Any] {
        get {
            return [String : Any]();
        }
    }
    var textFields : [UITextField] {
        get {
            return [self.brandTextField, self.modelTextField];
        }
    }
    var location : CLLocation! = nil;
    var isMovedShop : Bool {
        get {
            return false;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.registerNotifications();
        self.updateAppearance();
        self.getLocation();
        if UIScreen.main.traitCollection.userInterfaceIdiom == .phone {
            orderButton.titleLabel?.font = UIFont(name: Constants.kShahidFont, size: 16)
        } else {
            orderButton.titleLabel?.font = UIFont(name: Constants.kShahidFont, size: 21)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let temp = UIScreen.main.nativeBounds.height
        if temp == 960{
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 80, 0.0)
        }
        self.contentInsets = self.scrollView.contentInset;
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = true
       // self.scrlMain.contentSize = CGSize(width: self.scrlMain.frame.width, height: 60.0 + 5 * (self.scrlMain.frame.width / 16.0 * 5.0));
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        timer?.invalidate();
        timer = nil;
    }
    
    func getLocation()
    {
        func recurviseGetLocation() {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getLocation), userInfo: nil, repeats: false);
        }
        
        DispatchQueue.global().async {
            if let location = self.appDelegate.locationManager.location
            {
                self.location = location;
                self.getAddress();
                /*self.location = location;
                _ = CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
                    if let mark = placeMarks?.first {
                        if let address = mark.addressDictionary?["FormattedAddressLines"] as? [String] {
                            DispatchQueue.main.async {
                                self.addressLabel.text = address.joined(separator: ", ");
                            }
                        }
                    } else {
                        recurviseGetLocation();
                    }
                })*/
            }
            else
            {
                recurviseGetLocation();
            }
        }
    }
    
    func registerNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotificaiton(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil);
        
    }
    
    func keyboardWillShowNotificaiton(notification: NSNotification)
    {
        if let info = notification.userInfo, let frame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect, let insets = self.contentInsets {
            scrollView.contentInset = UIEdgeInsets(top: insets.top, left: insets.left, bottom: frame.height-50.0, right: insets.right);
            
        }
    }
    
    func keyboardWillhide(notification: NSNotification)
    {
        self.scrollView.contentInset = self.contentInsets!;
       
    }

    
    func updateAppearance()
    {
        self.brandContainer.backgroundColor = UIColor.clear;
        self.modleContainer.backgroundColor = UIColor.clear;
        //below call must be placed by inherting class at the end of function
        //self.updateAllTextFieldsAppearance();
    }
    
    func addLeftViewToTextField(textField: UITextField)
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30));
        textField.leftView = view;
        textField.leftViewMode = .always;
    }
    
    func addRightViewToTextField(textField: UITextField)
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30));
        textField.rightView = view;
        textField.rightViewMode = .always;
    }
    
    func updateAllTextFieldsAppearance()
    {
        let fields = self.textFields;
        for field in fields {
            self.updateTextFieldApparance(textField: field);
            self.addLeftViewToTextField(textField: field);
            self.addRightViewToTextField(textField: field);
            field.backgroundColor = UIColor.clear;
        }
    }
    
    func updateTextFieldApparance(textField : UITextField)
    {
        textField.layer.cornerRadius = 3.0;
        textField.layer.borderWidth = 1.0;
        if textField.isFirstResponder {
            textField.layer.borderColor = UIColor.orange.cgColor;
        } else {
            textField.layer.borderColor = UIColor.lightGray.cgColor;
        }
    }
    
    @IBAction func backAction(sender: Any)
    {
        if let nav = self.navigationController {
            nav.popViewController(animated: true);
        } else {
            self.dismiss(animated: true, completion: nil);
        }
    }
    
    @IBAction func editLocation(sender: Any)
    {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        {
            controller.location = self.location;
            controller.currentAddress = self.addressLabel.text;
            controller.callerController = self;
            controller.isFromMovedShop = isMovedShop;
            self.show(controller, sender: self);
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignTextField();
    }
    
    @IBAction func didTapScrollView(gesture: UITapGestureRecognizer)
    {
        self.resignTextField();
        
    }
    
    func resignTextField()
    {
        if let tf = self.firstResponder {
            tf.resignFirstResponder();
            self.firstResponder = nil;
            if let insets = self.contentInsets {
                self.scrollView.contentInset = insets;
            }
        }
    }
    
    func addCommonParameters(params: inout [String : Any])
    {
        params["customerID"] = UserDefaults.standard.value(forKey: "ID") as! String;
        params["shopID"] = "";
        params["orderType"] = "";
        params["lat"] = self.location?.coordinate.latitude ?? ""
        params["lng"] = self.location?.coordinate.longitude ?? ""
        params["address"] = self.addressLabel.text ?? "";
        params["brandId"] = self.carBrand!.id;
        params["modelId"] = self.carModle!.id;
        params["orderStatus"] = "";
    }
    
    @IBAction func placeOrderAction(sender: Any)
    {
        MBProgressHUD.showAdded(to: self.view, animated:true)
        self.postOrder();
        
    }
    
    func postOrder()
    {
        if appDelegate.isInternetAvailable()
        {
            Alamofire.request(Constants.kDoneOrder, method: .post, parameters:self.parameters, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        DispatchQueue.main.async {
                            let dic=response.result.value as! NSDictionary
                            self.addressLabel.text = ""
                            let orderID=Int(dic["orderID"] as! String)
                            let temp = "تم إنشاء طلبكم رقم \(String(format: "%07d", orderID!))"
                            let alert = UIAlertController(title: temp , message: nil, preferredStyle: .alert);
                            alert.addAction(UIAlertAction(title: "موافق", style: .default, handler: {(action) in
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true);
                                }
                            }));
                            self.present(alert, animated: true, completion: nil);
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:{
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                        MBProgressHUD.hide(for: self.view, animated: true);
                    });
                    break
                case .failure(_):
                    print(response.result.error as Any)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:{
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                        MBProgressHUD.hide(for: self.view, animated: true);
                        
                        let alert = UIAlertController(title: "Carefer", message: "الرجاء تحديد السعر", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    });
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

}

extension MoveShopReceiveCarBaseController : UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            return true;
        }
        
        func showPopupView(popupViewType: PopupViewType, parameters: [String: Any]?)
        {
            self.popupView.configureAndShow(in: self.view, popupViewType: popupViewType, parameters: parameters)
        }
        
        var parameters : [String : Any]? = nil;
        var popupType = PopupViewType.brand;
        //brand textfield is being edited
        if textField.tag == 1 {
            popupType = .brand;
        }
        //modle textfield is being edited
        else if textField.tag == 2 {
            popupType = .modle;
            if let brand = self.carBrand {
                parameters = ["brandID" : brand.id!];
            }else {
                let alert = UIAlertController(title: "اختر ماركة السيارة للحصول على القائمة", message:nil, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "اختر ماركة السيارة", style: .default, handler: { (action) in
                    showPopupView(popupViewType: .brand, parameters: nil);
                    
                }));
                alert.addAction(UIAlertAction(title: "إلغاء", style: .default, handler: nil));
                self.present(alert, animated: true, completion: nil);
                return false;
            }
        }
        //service type textfield is being edited
        else if textField.tag == 3 {
            popupType = .serviceType;
        }
        
        showPopupView(popupViewType: popupType, parameters: parameters);
        
        return false;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        firstResponder = textField;
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.updateAllTextFieldsAppearance();
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.updateAllTextFieldsAppearance();
        }
    }
    
    func getAddress()
    {
        if self.location == nil {return;}
        let parameters = ["longitude":self.location.coordinate.longitude , "latitude":self.location.coordinate.latitude]
        if appDelegate.isInternetAvailable()
        {
            Alamofire.request(Constants.kGetAddressUrl, method: .post, parameters:parameters, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        DispatchQueue.main.async {
                            if let add = serviceTypeObject?["address"] as? String {
                                self.addressLabel.text = add;
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:{
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                            MBProgressHUD.hide(for: self.view, animated: true);
                        });
                    }
                    break
                case .failure(_):
                    print(response.result.error as Any)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:{
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                        MBProgressHUD.hide(for: self.view, animated: true);
                    });
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
    
    
    func getDescription(url: String)
    {
        if appDelegate.isInternetAvailable()
        {
            Alamofire.request(url, method: .get, parameters:nil, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        DispatchQueue.main.async {
                            if let add = serviceTypeObject?["description"] as? String {
                                self.descriptionLabel.text = add;
                            }
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }
        else
        {
            self.descriptionLabel.text = "لا يتوفر انترنت …!";
        }
    }
}

extension MoveShopReceiveCarBaseController : PopupViewDelegate
{
    func didSelectBrand(brand: PopupModle)
    {
        self.carBrand = brand;
        self.brandTextField.text = brand.name;
    }
    
    func didSelectModle(modle: PopupModle)
    {
        self.carModle = modle;
        self.modelTextField.text = ((modle.name ?? "") as NSString).replacingOccurrences(of: "\t", with: "") as String;
    }
    
    func didSelectServiceType(serviceType: PopupModle)
    {
        self.serviceType = serviceType;
    }
}


