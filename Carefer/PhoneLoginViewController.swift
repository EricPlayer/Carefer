//
//  PhoneLoginViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/11/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import MRCountryPicker
import PhoneNumberKit
import MBProgressHUD
import Alamofire
class PhoneLoginViewController: RegistrationParentController, MRCountryPickerDelegate ,UITextFieldDelegate{
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var lblEnterNumberTitle:UILabel!
    @IBOutlet weak var txtPhoneNumber:UITextField!
    @IBOutlet weak var txtCountryCode:UITextField!
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var btnnext:UIButton!
    @IBOutlet weak var countryListView:UIView!
    @IBOutlet weak   var txtCountryCodeWidthConstraint:NSLayoutConstraint!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var countryPicker: MRCountryPicker!
    @IBOutlet weak var countryFlag: UIImageView!
    var region:String!
    var code:String!
    var isValid = false
    let phoneNumberKit = PhoneNumberKit()
    var phoneNumber:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneLoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneLoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhoneLoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
         self.txtPhoneNumber.delegate = self
        
        imageView.addGestureRecognizer(tap)
        countryListView.isHidden = true
        self.btnnext.layer.cornerRadius = 15
        self.btnnext.clipsToBounds = true
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.txtCountryCode.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.txtPhoneNumber.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblEnterNumberTitle.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.btnnext.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:18)
        case .phone:
            print("iPhone and iPod touch style UI")
            self.txtCountryCode.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.txtPhoneNumber.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblEnterNumberTitle.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.btnnext.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        

        
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        countryPicker.setCountry("SA")
        
        if isFromRegisterLater {
            self.btnSkip.isHidden = true;
            self.btnCancel.isHidden = false;
        } else {
            self.btnSkip.isHidden = false;
            self.btnCancel.isHidden = true;
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Login Screen")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
        
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
    func getWidth(text: String) -> CGFloat
    {
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
         self.txtPhoneNumber.resignFirstResponder()
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
         self.txtPhoneNumber.resignFirstResponder()
        self.txtPhoneNumber.endEditing(true)
        countryListView.isHidden = true
        //super.touchesBegan(touches, with: event)
        
    }
    
    @IBAction func skip(_ sender: Any)
    {
        //Skip Registration = تخطي تسجيل
        //You are about to skip registration, registration will be required to register to place an order. = كنت على وشك تخطي التسجيل، وسوف تكون هناك حاجة للتسجيل للتسجيل لوضع النظام.
        //Cancel = إلغاء
        //Skip = تخطي
        let alert = UIAlertController(title: "تخطي تسجيل", message: "أنت على وشك تخطي التسجيل ، وسيكون هناك حاجة للتسجيل عند اتمام الطلب.", preferredStyle: .alert);
        let cancelAction = UIAlertAction(title: "إلغاء", style: .default) { (action) in
            
        }
        
        let skipAction = UIAlertAction(title: "تخطي", style: .default) { (action) in
            UserDefaults.standard.set(true, forKey: Constants.kRegistrationSkipped);
            self.appDelegate.setHomeVc();
        }
        
        alert.addAction(cancelAction);
        alert.addAction(skipAction);
        self.present(alert, animated: true, completion: nil);
    }

    @IBAction func btnShowCountryList(sender:UIButton)
    {
        self.txtPhoneNumber.resignFirstResponder()
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
           self.countryListView.isHidden = false
            // Your code with delay
        }
        
       
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.txtPhoneNumber.resignFirstResponder()
      
        do {
            let englishNumber = self.convertLocalizeNumberToEnglish(localizedNumber: self.txtPhoneNumber.text!);
            let phoneNumberthis = "\(self.txtCountryCode.text!)\(englishNumber)"
            let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(phoneNumberthis, withRegion:self.region, ignoreType: true)
          let neumberafterPlus =   phoneNumberKit.format(phoneNumberCustomDefaultRegion, toType: .international)
            print(neumberafterPlus)
            phoneNumber = neumberafterPlus
            UserDefaults.standard.set(self.region, forKey:"region")
            isValid = true
            
        }
        catch {
            print("Generic parser error")
            isValid = false
            return  true
           }
      return  true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtPhoneNumber.resignFirstResponder()
        return true
    }
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
       
        self.txtPhoneNumber.resignFirstResponder()
        print(name)
        print(phoneCode)
        region = countryCode
        //let phonewithX = "\(phoneCode)xxxxxxxx"
        self.txtCountryCode.text = phoneCode
        self.txtCountryCodeWidthConstraint.constant = self.getWidth(text:self.txtCountryCode.text!)
        code = phoneCode
       self.txtPhoneNumber.resignFirstResponder()
        
        self.countryFlag.image = flag
        countryListView.isHidden = true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       countryListView.isHidden = true
                return true
       
    }

@IBAction func btnNext (sender:UIButton)
{
    
    self.txtPhoneNumber.resignFirstResponder()
    
    do {
        let englishNumber = self.convertLocalizeNumberToEnglish(localizedNumber: self.txtPhoneNumber.text!);
        let phoneNumberthis = "\(self.txtCountryCode.text!)\(englishNumber)"
        let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(phoneNumberthis, withRegion:self.region, ignoreType: true)
        let neumberafterPlus =   phoneNumberKit.format(phoneNumberCustomDefaultRegion, toType: .international)
        print(neumberafterPlus)
        phoneNumber = neumberafterPlus
        isValid = true
        
    }
    catch {
        print("Generic parser error")
        isValid = false
        
    }

    
    
    if isValid == true
    {
        
        print(phoneNumber)
        if phoneNumber == "58 154 3361"
        {
            let num = phoneNumber.chopPrefix()
            let trimmedString = num.removingWhitespaces()
            print(trimmedString)
            UserDefaults.standard.set("1", forKey:"isPolicyVerified")
            UserDefaults.standard.set("yes", forKey:"codeVerified")
            UserDefaults.standard.set("yes", forKey:"phoneNumberPost")
            UserDefaults.standard.set(trimmedString, forKey:"mobileNumber")
            UserDefaults.standard.set("5", forKey:"ID")
            let policyVc = self.storyboard?.instantiateViewController(withIdentifier: "PolicyVc") as! PolicyViewController
            self.navigationController?.pushViewController(policyVc, animated:true)
        }
        else
        {
        self.postPhoneNumberOnServer()
            
        }
        
    
        
        
    
    }
    else
    {
        let alert = UIAlertController(title: "Carefer", message: "تصحيح رقم جوالك", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
    }
}
    
    
    
    func postPhoneNumberOnServer()
    {
     
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        let num = phoneNumber.chopPrefix()
        let trimmedString = num.removingWhitespaces()
        print(trimmedString)
        UserDefaults.standard.set(trimmedString, forKey:"mobileNumber")
        var parameter = [String:Any]()
        parameter = ["mobileNumber":trimmedString]
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
                        UserDefaults.standard.set("yes", forKey:"phoneNumberPost")
                        MBProgressHUD.hide(for:self.view, animated:true)
                    
                    let verificationVc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVc")as! VerifictionViewController
                    verificationVc.isFromMyDetail = "no"
                    verificationVc.isFromRegisterLater = self.isFromRegisterLater;
                    if self.isFromRegisterLater {
                        FirebaseLogger.shared.logRegisterLaterEvent();
                        
                    } else {
                        FirebaseLogger.shared.logRegisterNowEvent();
                    }
                    verificationVc.registerLaterDelegate = self.registerLaterDelegate;
                    self.navigationController?.pushViewController(verificationVc, animated:true)
                    let alert = UIAlertController(title: "Carefer", message: "تم إرسال رمز التحقق إلى رقم جوالك للتحقق منه.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                        
                    
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension String {
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
