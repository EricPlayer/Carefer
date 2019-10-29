//
//  RateShopViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/19/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import MBProgressHUD
class RateShopViewController: UIViewController ,UITextViewDelegate{
    @IBOutlet weak var roundedView :UIView!
    @IBOutlet weak var WhiteRoundedView :UIView!
    @IBOutlet weak var txtAddComment:UITextView!
    @IBOutlet weak var btnAddComment:UIButton!
    @IBOutlet weak var priceRatingView:CosmosView!
    @IBOutlet weak var QualityRatingView:CosmosView!
    @IBOutlet weak var TimeRatingView:CosmosView!
     @IBOutlet weak var lblNavigationTitle :UILabel!
    @IBOutlet weak var lblRateShopText :UILabel!
    @IBOutlet weak var lblPricetitle :UILabel!
    @IBOutlet weak var lblQualityTitle :UILabel!
    @IBOutlet weak var lbltimeTitle :UILabel!
    @IBOutlet weak var navigationBar:UIView!
    
    
    
    
    var priceRating:String!
    var qualityRating:String!
    var timeRating:String!
    var shopId:String!
    var orderId:String!
    var shopName:String!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        //let topShadow = EdgeShadowLayer(forView:self.navigationBar, edge:.Bottom)
        //self.navigationBar.layer.addSublayer(topShadow)

        self.priceRating = ""
        self.qualityRating = ""
        self.timeRating = ""
        txtAddComment.delegate = self
        txtAddComment.text = "اكتب تعليقاتك هنا …......"
        txtAddComment.textColor = UIColor.lightGray
        self.lblRateShopText.text = self.shopName
        self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont,size:16)
        self.lblRateShopText.font = UIFont(name:Constants.kShahidFont,size:16)
        self.lblPricetitle.font = UIFont(name:Constants.kShahidFont,size:14)
        self.lblQualityTitle.font = UIFont(name:Constants.kShahidFont,size:14)
        self.lbltimeTitle.font = UIFont(name:Constants.kShahidFont,size:14)
        self.txtAddComment.font = UIFont(name:Constants.kShahidFont,size:16)
        self.btnAddComment.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:16)
        txtAddComment!.layer.borderWidth = 1
        txtAddComment!.layer.borderColor = UIColor.black.cgColor

      self.priceRatingView.didFinishTouchingCosmos =
        { rating in
          print(rating)
            self.priceRating = String(rating)
        }
        self.QualityRatingView.didFinishTouchingCosmos =
            { rating in
                print(rating)
                self.qualityRating = String(rating)
        }
        self.TimeRatingView.didFinishTouchingCosmos =
            { rating in
                print(rating)
                self.timeRating = String(rating)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtAddComment.resignFirstResponder()
    }
    @IBAction func btnBack(sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        //appDelegate.setHomeVc()
    }
    @IBAction func btnMyDeals(sender:UIButton)
    {
        self.appDelegate.setTabBarAsRootVc(selectedIndex:0)
    }
    @IBAction  func btnMyOrders(sender:UIButton)
    {
        self.appDelegate.setTabBarAsRootVc(selectedIndex:1)
    }
    @IBAction  func btnFavShops(sender:UIButton)
    {
        self.appDelegate.setTabBarAsRootVc(selectedIndex:2)
    }
    @IBAction  func btnshare(sender:UIButton)
    {
        self.appDelegate.setTabBarAsRootVc(selectedIndex:3)
    }
    @IBAction  func btnaboutUs(sender:UIButton)
    {
        self.appDelegate.setTabBarAsRootVc(selectedIndex:4)
    }
    @IBAction func btnSave (sender:UIButton)
    {
        if self.priceRating != "" || self.qualityRating != "" || self.timeRating != ""
        {
            if self.txtAddComment.text != "" && self.txtAddComment.text != "اكتب تعليقاتك هنا …......"
            {
        self.postOrder()
            }
            else
            {
                let alertController = UIAlertController(title: "Carefer", message: "الرجاء إضافة تعليقات", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Carefer", message: "يرجى إعطاء تقييم واحد على الأقل", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func postOrder()
    {
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        var comment = ""
        if self.txtAddComment.text != "اكتب تعليقاتك هنا …......"
        {
         comment = self.txtAddComment.text
        }
        
        let id = UserDefaults.standard.value(forKey: "ID") as! String
        var dic = [String:Any]()
        dic =  ["customerID": id, "shopID": self.shopId,"comments": comment,"priceRating": self.priceRating,"qualityRating": self.qualityRating,"timeRating":self.timeRating, "orderID":self.orderId]
        
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.kUploadcomments, method: .post, parameters:dic, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                    MBProgressHUD.hide(for:self.view, animated:true)
                    self.navigationController?.popViewController(animated: true)
                    let alertController = UIAlertController(title: "Carefer", message: "تمت إضافة التعليق", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                   // self.appDelegate.setHomeVc()
                    
                    
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
            self.present(alert, animated: true, completion: nil)}
    }

    // Mark TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            txtAddComment.text = nil
            txtAddComment.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtAddComment.text.isEmpty {
            txtAddComment.text = "اكتب تعليقاتك هنا …......"
            txtAddComment.textColor = UIColor.lightGray
        }
        self.txtAddComment.resignFirstResponder()
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
