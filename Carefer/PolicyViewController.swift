//
//  PolicyViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/11/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class PolicyViewController: RegistrationParentController
{
    @IBOutlet weak var circleView :UIView!
    @IBOutlet weak var txtPolicy:UITextView!
    @IBOutlet weak var checkBoxImageView:UIImageView!
    @IBOutlet weak var lblNavigationTitle :UILabel!
    var isAcepted = false
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        getPrivacyPolicy()
        self.registerUserAfterVerification()
        self.txtPolicy.isEditable = false
        self.txtPolicy.isSelectable = false
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.txtPolicy.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont ,size:21)
            
        case .phone:
            print("iPhone and iPod touch style UI")
            self.txtPolicy.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont ,size:16)
            
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnNext (sender:UIButton)
    {
        
        // appDelegate.setTabBarAsRootVc()
        if UserDefaults.standard.value(forKey: "isPolicyVerified") as! String == "1"
        {
            
            UserDefaults.standard.set("yes", forKey:"verified")
            if isFromRegisterLater {
                self.navigationController?.dismiss(animated: true, completion: {(Void) -> Void in
                    if let delegate = self.registerLaterDelegate {
                        delegate.didRegister();
                    }
                })
            } else {
                let mapvc = self.storyboard?.instantiateViewController(withIdentifier: "mapVc") as! HomeViewController
                self.navigationController?.pushViewController(mapvc, animated:true)
            }
        }
        else
            
        {
            let alert = UIAlertController(title: "Carefer", message: "يرجى قبول سياسة كارفر أولا …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func btnAcceptTermAndCondition (sender:UIButton)
    {
        if isAcepted == false
        {
            if UserDefaults.standard.value(forKey: "lat") != nil
            {
                UserDefaults.standard.set("yes", forKey:"showDistance")
                isAcepted = true
                self.postPolicy()
                self.checkBoxImageView.image = UIImage(named:"1x-check")
            }
            else
            {
                UserDefaults.standard.set("no", forKey:"showDistance")
                UserDefaults.standard.set(24.7136, forKey:"lat")
                UserDefaults.standard.set(46.6753, forKey:"long")
                isAcepted = true
                self.postPolicy()
                self.checkBoxImageView.image = UIImage(named:"1x-check")
                
                
                //                let alert = UIAlertController(title: "Carefer", message: "لايوجد صلاحية للوصول إلى موقع الجهاز …!", preferredStyle: UIAlertControllerStyle.alert)
                //                alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                //                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else
        {
            
            isAcepted = false
            self.checkBoxImageView.image = UIImage(named:"1x-box")
        }
        
        
    }
    func postPolicy()
    {
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            var parameter = [String:Any]()
            parameter = ["customerID":UserDefaults.standard.value(forKey: "ID")as! String]
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.verifypolicy , method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let policyVerified = serviceTypeObject?.value(forKey:"policyVerified") as! NSNumber
                        
                        if policyVerified == 1
                        {
                            UserDefaults.standard.set("1", forKey:"isPolicyVerified")
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
        else{
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getPrivacyPolicy()
    {
        
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.kCareferPolicy, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let policyData = response.result.value as? NSDictionary
                        let policyValue = policyData?.value(forKey:"policyData") as! NSArray
                        let policyObject = policyValue[0] as! NSDictionary
                        let policyContent = policyObject.value(forKey: "policyContent") as? String
                        print(policyContent)
                        self.txtPolicy.text = policyContent
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
            self.present(alert, animated: true, completion: nil)}
    }
    
    func registerUserAfterVerification()
    {
        
        
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            var parameter = [String:Any]()
            parameter = ["customerName":"","customerMobile":UserDefaults.standard.value(forKey: "mobileNumber") as! String,"isVerified":"1"]
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.kUploadUser , method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let arrayOfService = serviceTypeObject?.value(forKey:"customerDetails") as! NSArray
                        for i in 0..<arrayOfService.count {
                            
                            let serviceObject = arrayOfService[i] as! NSDictionary
                            print(serviceObject)
                            let id = serviceObject.value(forKey: "ID") as! String
                            let customerMobile = serviceObject.value(forKey: "customerMobile") as! String
                            let customerName = serviceObject.value(forKey: "customerName") as! String
                            let isVerified = serviceObject.value(forKey: "isVerified") as! String
                            let isPolicyVerified = serviceObject.value(forKey: "isPolicyVerified") as! String
                            
                            UserDefaults.standard.set(isPolicyVerified, forKey:"isPolicyVerified")
                            UserDefaults.standard.set(id, forKey:"ID")
                            UserDefaults.standard.set(customerMobile, forKey:"customerMobile")
                            UserDefaults.standard.set(customerName, forKey:"customerName")
                            UserDefaults.standard.set(isVerified, forKey:"isVerified")
                            MBProgressHUD.hide(for:self.view, animated:true)
                            
                            
                            
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
    
}
