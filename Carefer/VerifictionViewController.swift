//
//  VerifictionViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/11/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
class VerifictionViewController: RegistrationParentController, UITextFieldDelegate {
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var circleView :UIView!
    @IBOutlet weak var txtVerificationCodeOne:UITextField!
    @IBOutlet weak var txtVerificationCodeTwo:UITextField!
    @IBOutlet weak var txtVerificationCodeThree:UITextField!
    @IBOutlet weak var txtVerificationCodeFour:UITextField!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var lblTitleOne:UILabel!
    @IBOutlet weak var lblCodeSentToYourNumber:UILabel!
    @IBOutlet weak var lblTitleTwo:UILabel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var counter = 120
    var countForSixtySecond = 60
    var countForSecondSixtySecond = 60
    var timer = Timer()
    var isFromMyDetail:String!
    var mobileNumberFromDetail:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if UserDefaults.standard.value(forKey: "IsVerifyAsRoot")as? String == "yes"
        {
         isFromMyDetail = "no"
        }
        
        if isFromMyDetail == "yes"
        {
        self.tabBarController?.tabBar.isHidden = true
        }
        else
        {
        
        }
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneLoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneLoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.lblTitleTwo.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblCodeSentToYourNumber.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.btnNext.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:18)
        case .phone:
            print("iPhone and iPod touch style UI")
            self.lblTitleTwo.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblCodeSentToYourNumber.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.btnNext.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }

        
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        self.btnNext.layer.cornerRadius = 15
        self.btnNext.clipsToBounds = true
        self.txtVerificationCodeOne.addTarget(self, action:#selector(textFieldDidChange(textField:)), for:.editingChanged)
        self.txtVerificationCodeTwo.addTarget(self, action:#selector(textFieldDidChange(textField:)), for:.editingChanged)
        self.txtVerificationCodeThree.addTarget(self, action:#selector(textFieldDidChange(textField:)), for:.editingChanged)
        self.txtVerificationCodeFour.addTarget(self, action:#selector(textFieldDidChange(textField:)), for:.editingChanged)
        
        
       
        if isFromRegisterLater {
            self.btnCancel.isHidden = false;
        } else {
            self.btnCancel.isHidden = true;
        }
        // Do any additional setup after loading the view.
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtVerificationCodeOne.resignFirstResponder()
        self.txtVerificationCodeTwo.resignFirstResponder()
        self.txtVerificationCodeThree.resignFirstResponder()
        self.txtVerificationCodeFour.resignFirstResponder()
    }
    @IBAction func btnNext (sender:UIButton)
    {
      if self.txtVerificationCodeOne.text != ""
        {
            if self.txtVerificationCodeTwo.text != ""
            {
                if self.txtVerificationCodeThree.text != ""
                {
                    if self.txtVerificationCodeFour.text != ""
                    {
                        if self.isFromMyDetail == "yes"
                        {
                            self.verifyCodeForNumberChange()}
                        else
                        {
                            self.verifyCode()
                        }
                    }
                }
            }
        }
    }
    func timerAction() {
        
        self.lblCodeSentToYourNumber.text = "تم إرسال رمز التحقق إلى رقم جوالك للتحقق منه."
        counter -= 1
        
         countForSixtySecond -= 1
        if counter > 60
        {
        self.lblTime.text = "01:\(countForSixtySecond)"
        }
        else
        {
            if countForSecondSixtySecond > 0
            {
            countForSecondSixtySecond -= 1
            self.lblTime.text = "00:\(countForSecondSixtySecond)"
            }
        }
        
        
        if counter == 0
        {
            timer.invalidate()
            let uiAlert = UIAlertController(title: "Carefer", message: "إعادة إرسال رمز التحقق مرة أخرى", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "تأكيد رقم جوالك", style: .default, handler: { action in
               // println("Click of default button")
                self.postRequestToResendCode()
            }))
            
            uiAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { action in
                //println("Click of cancel button")
            }))
        
        }
    }
    
    func postRequestToResendCode()
    {
       
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            self.countForSixtySecond = 60
            self.countForSecondSixtySecond = 60
        self.counter = 120
        let num = UserDefaults.standard.value(forKey: "mobileNumber") as! String
        var parameter = [String:Any]()
        parameter = ["mobileNumber":num]
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.kreceivemobilenumber , method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let serviceObject = serviceTypeObject?.value(forKey:"customer") as! NSDictionary
                    
                    print(serviceObject)
                    let id = serviceObject.value(forKey: "ID") as! String
                    let customerMobile = serviceObject.value(forKey: "customerMobile") as! String
                    let customerName = serviceObject.value(forKey: "customerName") as! String
                    let isVerified = serviceObject.value(forKey: "isVerified") as! String
                    
                    UserDefaults.standard.set(id, forKey:"ID")
                    UserDefaults.standard.set(customerMobile, forKey:"customerMobile")
                    UserDefaults.standard.set(customerName, forKey:"customerName")
                    UserDefaults.standard.set(isVerified, forKey:"isVerified")
                    MBProgressHUD.hide(for:self.view, animated:true)
                    let alert = UIAlertController(title: "Carefer", message: "تم إرسال رمز التحقق إلى رقم جوالك للتحقق منه.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                   self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(VerifictionViewController.timerAction), userInfo: nil, repeats: true)
                    
                    
                    
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

    @IBAction func btnBack(sender:UIButton)
    {
    self.navigationController?.popViewController(animated: true)
    }
    // Mark:text filed delegate 
    
    func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        let tag = textField.tag
        if text?.utf16.count==1{
            switch tag{
            case 0:
                txtVerificationCodeOne.resignFirstResponder()
                txtVerificationCodeTwo.becomeFirstResponder()
            case 1:
                txtVerificationCodeOne.resignFirstResponder()
                txtVerificationCodeTwo.resignFirstResponder()
                txtVerificationCodeThree.becomeFirstResponder()
            case 2:
                txtVerificationCodeOne.resignFirstResponder()
                txtVerificationCodeTwo.resignFirstResponder()
                txtVerificationCodeThree.resignFirstResponder()
                txtVerificationCodeFour.becomeFirstResponder()
            case 3:
                txtVerificationCodeFour.resignFirstResponder()
                txtVerificationCodeOne.resignFirstResponder()
                txtVerificationCodeTwo.resignFirstResponder()
                txtVerificationCodeThree.resignFirstResponder()
            default:
                txtVerificationCodeFour.resignFirstResponder()
                txtVerificationCodeOne.resignFirstResponder()
                txtVerificationCodeTwo.resignFirstResponder()
                txtVerificationCodeThree.resignFirstResponder()
                break
            }
        }else{
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        
        if textField.tag == 0
        {
        self.txtVerificationCodeTwo.becomeFirstResponder()
        }
        else
            if textField.tag == 1
            {
                self.txtVerificationCodeThree.becomeFirstResponder()
        }
        else
                if textField.tag == 2
                {
                    self.txtVerificationCodeFour.becomeFirstResponder()
        }
        else
                {
                    txtVerificationCodeOne.resignFirstResponder()
                    txtVerificationCodeTwo.resignFirstResponder()
                    txtVerificationCodeThree.resignFirstResponder()
                    txtVerificationCodeFour.resignFirstResponder()
                }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text?.characters.count == 1
        {
            if textField.tag == 0
            {
                self.txtVerificationCodeTwo.becomeFirstResponder()
            }
            else
                if textField.tag == 1
                {
                    self.txtVerificationCodeThree.becomeFirstResponder()
                }
                else
                    if textField.tag == 2
                    {
                        self.txtVerificationCodeFour.becomeFirstResponder()
                    }
                    else
                    {
                        txtVerificationCodeOne.resignFirstResponder()
                        txtVerificationCodeTwo.resignFirstResponder()
                        txtVerificationCodeThree.resignFirstResponder()
                        txtVerificationCodeFour.resignFirstResponder()
                        if self.isFromMyDetail == "yes"
                        {
                        self.verifyCodeForNumberChange()}
                        else
                        {
                        self.verifyCode()
                        }
            }
        }
        return true
    }
    
    func convertLocalizeNumberToEnglish(localizedNumber : String) -> String
    {
        //var index = localizedNumber.index(localizedNumber.startIndex, offsetBy: 3);
        //let number = localizedNumber.substring(from: index);
        //let code = localizedNumber.substring(to: index);
        let formatter = NumberFormatter();
        formatter.locale = Locale(identifier: "EN");
        if let englishNumber = formatter.number(from: localizedNumber) {
            return englishNumber.stringValue;
        } else {
            return localizedNumber;
        }
    }
    
    func verifyCodeForNumberChange()
    {
        
        let deviceToken = UserDefaults.standard.value(forKey:"deviceTiken") as! String
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            
            var code = "\(self.txtVerificationCodeOne.text!)\(self.txtVerificationCodeTwo.text!)\(self.txtVerificationCodeThree.text!)\(self.txtVerificationCodeFour.text!)"
            code = convertLocalizeNumberToEnglish(localizedNumber: code);
            var parameter = [String:Any]()
            parameter = ["verificationCode":code,"customerID":UserDefaults.standard.value(forKey: "ID")as! String,"regID":deviceToken,"mobileType":"IOS","customerMobile":self.mobileNumberFromDetail]
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.verifycustomer , method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let serviceObject = serviceTypeObject?.value(forKey:"customer") as! NSDictionary
                        
                        print(serviceObject)
                        let id = serviceObject.value(forKey: "statusCode") as! NSNumber
                        if id == 1
                        {
                            if self.isFromMyDetail == "yes"
                            {
                                self.navigationController?.popViewController(animated:true)
                            }
                            else
                            {
                              
                            }
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Carefer", message: "رمز التحقق غير صحيح ...!", preferredStyle: UIAlertControllerStyle.alert)
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
            self.present(alert, animated: true, completion: nil)}
        
    }

    func verifyCode()
    {
        let token = UserDefaults.standard.value(forKey:"deviceTiken") as? String;
        let deviceToken =  (token == nil ? "" : token!)
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            
        var code = "\(self.txtVerificationCodeOne.text!)\(self.txtVerificationCodeTwo.text!)\(self.txtVerificationCodeThree.text!)\(self.txtVerificationCodeFour.text!)"
        code = self.convertLocalizeNumberToEnglish(localizedNumber: code);
        var parameter = [String:Any]()
        parameter = ["verificationCode":code,"customerID":UserDefaults.standard.value(forKey: "ID")as! String,"regID":deviceToken,"mobileType":"IOS"]
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.verifycustomer , method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let serviceObject = serviceTypeObject?.value(forKey:"customer") as! NSDictionary
                    
                    print(serviceObject)
                    let id = serviceObject.value(forKey: "statusCode") as! NSNumber
                    if id == 1
                    {
                         if self.isFromMyDetail == "yes"
                        {
                            let _ = self.navigationController?.popViewController(animated:true)
                        }
                        else
                        {
                        UserDefaults.standard.set("yes", forKey:"codeVerified")
                        UserDefaults.standard.set(false, forKey: Constants.kRegistrationSkipped);
                        UserDefaults.standard.synchronize();
                        self.timer.invalidate()
                        let policyVc = self.storyboard?.instantiateViewController(withIdentifier: "PolicyVc") as! PolicyViewController
                            policyVc.isFromRegisterLater = self.isFromRegisterLater;
                            policyVc.registerLaterDelegate = self.registerLaterDelegate;
                        self.navigationController?.pushViewController(policyVc, animated:true)
                        }
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Carefer", message: "رمز التحقق غير صحيح ...!", preferredStyle: UIAlertControllerStyle.alert)
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
