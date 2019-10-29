//
//  DetailOrderViewController.swift
//  Carefer
//
//  Created by Apple on 12/13/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class DetailOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_subTitle: UILabel!
    @IBOutlet weak var lbl_navTitle: UILabel!
    var orderID :String!
    var data = NSDictionary()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbl_navTitle.text="تفاصيل الطلب"
        self.lbl_subTitle.text="تفاصيل الطلب"
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.getShopsDetails()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if(indexPath.row==11){
            let temp=self.data.object(forKey: "orderType") as? String
            if temp==""{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
            }
        }else if(indexPath.row==0){
            
            
            let temp1=self.data.object(forKey: "orderNo") as? String
            
            if temp1==""{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
                
            }
        }else if(indexPath.row==1){
            let temp=self.data.object(forKey: "orderDate") as? String
            if temp==""{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
            }
        }else if(indexPath.row==2){
            let temp=self.data.object(forKey: "type") as? String
            if temp==""{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
            }
        }else if(indexPath.row==3){
            let temp=self.data.object(forKey: "brandName") as? String
            if temp==""{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
            }
        }else if(indexPath.row==4){
            let temp=self.data.object(forKey: "modelName") as? String
            if temp==""{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
            }
        }else if(indexPath.row==5){
            let temp=self.data.object(forKey: "serviceTypeName") as? String
            if temp==""{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
            }
        }else if(indexPath.row==6){
            let temp=self.data.object(forKey: "movedShopPrice") as? String
            if temp=="" || temp == nil{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
            }
        }else if(indexPath.row==7){
                    let temp=self.data.object(forKey: "receiveCarComments") as? String
                    if temp==""{
                        return 0.0;
                    }else{
                        return UITableViewAutomaticDimension;
            }
        }else if(indexPath.row==8){
            let temp=self.data.object(forKey: "customerLocation") as? String
            if temp==""{
                return 0.0;
            }else{
                return UITableViewAutomaticDimension;
            }
        }

//        }else if(indexPath.row==9){
//            let temp=self.data.object(forKey: "shopName") as? String
//            if temp==""{
//                return 0.0;
//            }else{
//                return UITableViewAutomaticDimension;
//            }
  //      }
         else {
            return UITableViewAutomaticDimension;
        }
        
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:DetailOrderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier:"CellData") as! DetailOrderTableViewCell!
        
        if indexPath.row==0{
            cell.lbl_type.text="رقم الطلب:"
            
            cell.lbl_data.text=self.data.object(forKey: "orderNo") as? String
            
        }else if indexPath.row==1{
            cell.lbl_type.text="تاريخ الطلب:"
            cell.lbl_data.text=self.data.object(forKey: "orderDate") as? String
            
           
            
        }else if indexPath.row==2{
            
            cell.lbl_type.text="نوع الطلب:"
            if self.data.object(forKey: "type") as? String == "Moved Shops"{
                cell.lbl_data.text="الورشة المتنقلة"
            }else{
                cell.lbl_data.text="استلام السيارة"
            }
            
            
        }else if indexPath.row==3{
            cell.lbl_type.text="ماركة السيارة:"
            cell.lbl_data.text=self.data.object(forKey: "brandName") as? String
            
        }else if indexPath.row==4{
            cell.lbl_type.text="نوع السيارة:"
            cell.lbl_data.text=self.data.object(forKey: "modelName") as? String
            
        }else if indexPath.row==5{
            cell.lbl_type.text="نوع الخدمة:"
            cell.lbl_data.text=self.data.object(forKey: "serviceTypeName") as? String
            
        }else if indexPath.row==6{
            cell.lbl_type.text="سعر الورشة المتنقلة:"
            cell.lbl_data.text=self.data.object(forKey: "movedShopPrice") as? String
            
        }else if indexPath.row==7{
                        cell.lbl_type.text="ملاحظات إستلام السيارة:"
                        cell.lbl_data.text=self.data.object(forKey: "receiveCarComments") as? String
            
        }else if indexPath.row==8{
            cell.lbl_type.text="مكان العميل:"
            cell.lbl_data.text=self.data.object(forKey: "customerLocation") as? String
            
        }
//        else if indexPath.row==9{
//            cell.lbl_type.text="ملاحظات إستلام السيارة:"
//            cell.lbl_data.text=self.data.object(forKey: "receiveCarComments") as? String
//
//        }else if indexPath.row==8{
//            cell.lbl_type.text="نوع الطلب:"
//            cell.lbl_data.text=self.data.object(forKey: "orderType") as? String
//
//        }else if indexPath.row==9{
//            cell.lbl_type.text="الورشة:"
//            cell.lbl_data.text=self.data.object(forKey: "shopName") as? String
//        }
        
        
        return cell
    }
    
    func getShopsDetails()
    {
        
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.kOrderDetailsData+self.orderID, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let shopsDetail = serviceTypeObject?.value(forKey:"orderDetails") as! NSArray
                        if shopsDetail.count > 0{
                            self.data = shopsDetail[0] as! NSDictionary
                        //print(shopDetailObject)
                        }
                        self.tableView.reloadData()
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                        MBProgressHUD.hide(for:self.view, animated:true)
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true);
                    })
                    break
                case .failure(_):
                    print(response.result.error as Any)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                        MBProgressHUD.hide(for:self.view, animated:true)
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true);
                    })
                    break
                    
                }
            }
        }else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }


}
