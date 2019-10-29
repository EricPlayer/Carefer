//
//  ShareViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/13/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Social
import SafariServices
import PinterestSDK

class ShareViewController: CareferParentController,SFSafariViewControllerDelegate,UIDocumentInteractionControllerDelegate {
@IBOutlet weak var roundedView :UIView!
    @IBOutlet weak var lblNavigationTitle:UILabel!
    @IBOutlet weak var lblDetailText:UILabel!
    @IBOutlet weak var orderYellowBar:UILabel!
    @IBOutlet weak var lblMapButtonTitle :UILabel!
    @IBOutlet weak var navigationBar:UIView!
    var appLink = "http://itunes.apple.com/us/app/carefer/1251376547"
    var documentController: UIDocumentInteractionController!
    var yourImage: UIImage?
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let layerGradient = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let topShadow = EdgeShadowLayer(forView:self.navigationBar, edge:.Bottom)
       // self.navigationBar.layer.addSublayer(topShadow)

        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:21)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblDetailText.font = UIFont(name:Constants.kShahidFont,size:16)
        case .phone:
            print("iPhone and iPod touch style UI")
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.orderYellowBar.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblDetailText.font = UIFont(name:Constants.kShahidFont,size:16)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        

        
        var tabFrame = self.tabBarController?.tabBar.frame
           // tabFrame?.size.height = 60
        //tabFrame?.origin.y = self.view.frame.size.height - 70
        self.tabBarController?.tabBar.backgroundImage=UIImage(named:"1x-shadow-bg")
        self.tabBarController?.tabBar.frame = tabFrame!
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
        let totalSpace = UIScreen.main.bounds.width / 5
        self.tabBarController?.tabBar.itemWidth = totalSpace - 50
        self.tabBarController?.tabBar.clipsToBounds = true
        yourImage = UIImage(named:"cuba-trinidadtaller-instrumentos-musicales-sonoros-y-musicales-musical-EKGCG3")
        self.lblMapButtonTitle.font = UIFont(name:Constants.kShahidFont ,size:13)
                // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(sender:UIButton)
    {
       // UserDefaults.standard.set("no", forKey: "isFirstForCity")
        appDelegate.setHomeVc()
    }
    @IBAction func btnShareViaFacebook(sender:UIButton)
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            //fbShare.title = appLink
                    fbShare.add(URL(string:appLink))
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            UIApplication.shared.openURL(NSURL(string: "https://m.facebook.com/sharer.php")! as URL)
//            let alert = UIAlertController(title: "Carefer", message: "يرجى تسجيل الدخول إلى حساب الفيسبوك للمشاركة.", preferredStyle: UIAlertControllerStyle.alert)
//            
//            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
        
        }
        else
        
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}

    }
    @IBAction func btnShareViaTwitter(sender:UIButton)
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            fbShare.add(URL(string:appLink))
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            UIApplication.shared.openURL(NSURL(string: "https://mobile.twitter.com/compose/tweet")! as URL)
//            let alert = UIAlertController(title: "Carefer", message: "يرجى تسجيل الدخول إلى حساب تويتر للمشاركة.", preferredStyle: UIAlertControllerStyle.alert)
//            
//            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
    }
    @IBAction func btnShareViaGtalk(sender:UIButton)
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        let urlstring = "https://developers.google.com/+/mobile/ios/share/\(appLink)"
        
        let shareURL = NSURL(string: urlstring)
        
        let urlComponents = NSURLComponents(string: "https://plus.google.com/share")
        
        urlComponents!.queryItems = [NSURLQueryItem(name: "url", value: shareURL!.absoluteString) as URLQueryItem]
        
        let url = urlComponents!.url!
        
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: url)
            svc.delegate = self
            self.present(svc, animated: true, completion: nil)
        } else {
            debugPrint("Not available")
            UIApplication.shared.openURL(NSURL(string: "https://developers.google.com/+/")! as URL)
        }
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnShareViaInstagram(sender:UIButton)
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
           // let localIdentifier = lastAsset.localIdentifier
            let u = "instagram://library?LocalIdentifier=\(appLink)"
            let url = NSURL(string: u)
        if (UIApplication.shared.canOpenURL(url as! URL)) {
            
          //  _ = UIImageJPEGRepresentation(yourImage?, 100)
            
            let captionString = appLink
            
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
//            if imageData?.writeToFile(writePath, atomically: true) == false {
            
//                return
                
//            } else {
                let fileURL = NSURL(fileURLWithPath: writePath)
                
                self.documentController = UIDocumentInteractionController(url: fileURL as URL)
                
                self.documentController.delegate = self
                
                self.documentController.uti = "com.instagram.exlusivegram"
                
                self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                self.documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
                
            //}
            
        } else {
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/")! as URL)
            print(" Instagram isn't installed ")
        }
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
    }
    @IBAction func btnBackToMap(sender:UIButton)
    {
        
        // UserDefaults.standard.set("no", forKey: "isFirstForCity")
        appDelegate.setHomeVc()
    }
    @IBAction func btnShareViaPinterest(sender:UIButton)
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        // open the Pinterest App if available
        if UIApplication.shared.openURL(URL(string: "pinterest://pin/76279787413881109")!) {
            // opening the app didn't work - let's open Safari
            if UIApplication.shared.openURL(URL(string: "http://www.pinterest.com/pin/76279787413881109/")!) {
                // nothing works - perhaps we're not online
                print("Dang!")
            }
        }
            else
            
        {
            
            UIApplication.shared.openURL(NSURL(string: "http://pinterest.com/pin/create")! as URL)
            }
        }
        else{
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        
    }
    @IBAction func btnShareViaWhatsApp(sender:UIButton)
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        let msg: NSString = appLink as NSString
        let titlewithoutspace = msg.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        if let titlewithoutspace = titlewithoutspace {
            let urlWhats = "whatsapp://send?text=\(titlewithoutspace)"
            let whatsappURL = NSURL(string: urlWhats)
            print(whatsappURL!)
            if UIApplication.shared.canOpenURL(whatsappURL as! URL) {
                UIApplication.shared.openURL(whatsappURL as! URL)
            } else {
                // Cannot open whatsapp
                UIApplication.shared.openURL(NSURL(string: "https://web.whatsapp.com/")! as URL)
//                let alert = UIAlertController(title: "Carefer", message: "ال واتساب غير مثبتة. الرجاء تثبيت ال واتساب", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Carefer", message: "ال واتساب غير مثبتة. الرجاء تثبيت ال واتساب", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        
        
    }
    @IBAction func btnShareViaTeleGram(sender:UIButton)
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        let urlString = "tg://msg?text=\(appLink)"
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if UIApplication.shared.canOpenURL(tgUrl!)
        {
            UIApplication.shared.openURL(tgUrl!)
        }else
        {
            UIApplication.shared.openURL(NSURL(string: "https://web.telegram.org")! as URL)
//            let alert = UIAlertController(title: "Carefer", message: "برقية غير مثبتة. الرجاء تثبيت برقية", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
            //App not installed.
        }
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
    }
    @IBAction func btnShareViaSnapChat(sender:UIButton)
    {
        
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        let msg: NSString = appLink as NSString
        //let titlewithoutspace = msg.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
       // if let titlewithoutspace = msg {
            let urlWhats = "snapchat://add=\(msg)"
            let whatsappURL = NSURL(string:"snapchat://")
            print(whatsappURL!)
            if UIApplication.shared.canOpenURL(whatsappURL as! URL) {
                UIApplication.shared.openURL(whatsappURL as! URL)
//            } else {
//                // Cannot open whatsapp
                
//                let alert = UIAlertController(title: "Carefer", message: "ال واتساب غير مثبتة. الرجاء تثبيت ال واتساب", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
        } else {
                
                UIApplication.shared.openURL(NSURL(string: "https://www.snap.com")! as URL)
//            let alert = UIAlertController(title: "Carefer", message: "ال واتساب غير مثبتة. الرجاء تثبيت ال واتساب", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}

        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Share Application Screen")
        
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
