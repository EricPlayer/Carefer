//
//  PopupTableView.swift
//  Carefer
//
//  Created by Muzammal Hussain on 11/3/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire

protocol PopupViewDelegate : NSObjectProtocol
{
    func didSelectServiceType(serviceType: PopupModle);
    func didSelectBrand(brand: PopupModle);
    func didSelectModle(modle: PopupModle);
}

enum PopupViewType : Int
{
    case brand
    case modle
    case serviceType
}


class PopupTableView : UIView
{
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var closeButton : UIButton!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var searchTextField : UITextField!
    @IBOutlet weak var popupCenterYConstraint : NSLayoutConstraint!
    
    var isSearching = false;
    weak var popupDelegate : PopupViewDelegate? = nil;
    var items = [PopupModle]();
    var filteredItems : [PopupModle] {
        get {
            let searchText = self.searchTextField.text;
            if let text = searchText, text.characters.count > 0 {
                let filtered = self.items.filter({ ($0.name ?? "").contains(text) || (($0.name ?? "") == searchText) })
                return filtered;
            }
            else {
                return self.items;
            }
        }
    }
    
    
    
    var popviewType = PopupViewType.brand;
    override init(frame: CGRect) {
        super.init(frame: frame);
        let view = Bundle.main.loadNibNamed("PopupTableView", owner: self, options: nil)?.first as! UIView;
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view);
        addAdjacentConstraints(subView:view, view: self);
        self.configureAppearance();
        self.updateAppearance();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        let view = Bundle.main.loadNibNamed("PopupTableView", owner: self, options: nil)?.first as! UIView;
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view);
        addAdjacentConstraints(subView:view, view: self);
        self.configureAppearance();
        self.updateAppearance();
    }
    
    func updateAppearance()
    {
        self.tableView.register(UINib(nibName: "PopupTableViewCell", bundle: nil), forCellReuseIdentifier: "popupCell");
        self.searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15));
        let placeHodler = NSMutableAttributedString(string: "بحث");
        placeHodler.addAttributes([NSForegroundColorAttributeName : UIColor(red: 169.0/255.0, green: 57.0/255.0, blue: 29.0/255.0, alpha: 1.0)], range: NSMakeRange(0, placeHodler.string.characters.count));
        self.searchTextField.attributedPlaceholder = placeHodler;
        self.searchTextField.leftViewMode = UITextFieldViewMode.unlessEditing;
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotificaiton(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil);
    }
    
    func keyboardWillShowNotificaiton(notification: NSNotification)
    {
        DispatchQueue.main.async {
            self.popupCenterYConstraint.constant = UIScreen.main.bounds.width == 320 ? -110 : -70;
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded();
            })
        };
    }

    
    func configureAppearance()
    {
        self.containerView.layer.cornerRadius = 10.0;
        self.containerView.layer.masksToBounds = true;
        self.containerView.clipsToBounds = true;
        
    }

    func addAdjacentConstraints(subView: UIView, view: UIView)
    {
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView":subView, "view":view]);
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subView":subView, "view":view]);
        view.addConstraints(horizontalConstraints+verticalConstraints)
    }
    
    func serviceURL() -> String
    {
        var url = "";
        switch self.popviewType {
            case .brand:
                url = Constants.kCarBrandUrl;
                break;
            case .modle:
                url = Constants.kCarModleUrl;
                break;
            case .serviceType:
                url = Constants.kCarServiceTypeUrl;
                break;
        }
        return url;
    }
    
    func serviceMethod() -> HTTPMethod
    {
        var method = HTTPMethod.get;
        switch self.popviewType {
        case .brand:
            method = HTTPMethod.get;
            break;
        case .modle:
            method = HTTPMethod.post;
            break;
        case .serviceType:
            method = HTTPMethod.get;
            break;
        }
        return method;
    }
    
    func configureAndShow(in view: UIView, popupViewType: PopupViewType, parameters: [String : Any]?)
    {
        self.popviewType = popupViewType;
        self.items = [PopupModle]()
        self.tableView.reloadData();
        //this delay ensures that progress hud displays
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5){
            let hud = MBProgressHUD.showAdded(to: self, animated: true);
            hud.label.text = "جاري التحميل";
        }
        
        //hit webservice for data
        Alamofire.request(serviceURL(), method: serviceMethod(), parameters:parameters, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil {
                    
                    if let data = response.result.value as? [String : Any]
                    {
                        //Brands Service
                        if let brands = data["brandsData"] as? [[String : Any]]
                        {
                            for info in brands{
                                let modle = PopupModle(type: .brand, info: info);
                                self.items.append(modle)
                            }
                        } else if let serviceTypes = data["serviceTypeData"] as? [[String : Any]] {
                            for info in serviceTypes {
                                let modle = PopupModle(type: .serviceType, info: info);
                                self.items.append(modle)
                            }
                        }
                        else if let models = data["models"] as? [[String: Any]] {
                            for info in models {
                                let modle = PopupModle(type: .modle, info: info);
                                self.items.append(modle)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                    MBProgressHUD.hide(for:self, animated:true);
                });
                break
                
            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                    MBProgressHUD.hide(for:self, animated:true);
                });
                print(response.result.error as Any)
                break
                
            }
        }
        self.show(in: view);
    }
    
    @IBAction func close(sender: Any)
    {
        self.isHidden = true;
        self.searchTextField.resignFirstResponder();
        self.searchTextField.delegate = nil;
    }
    
    private func show(in view: UIView)
    {
        self.searchTextField.text = "";
        if self.superview != view {
            self.removeFromSuperview();
            view.addSubview(self);
            self.addAdjacentConstraints(subView: self, view: view);
        }
        self.isHidden = false;
        self.searchTextField.delegate = self;
    }
    
    @IBAction func bgTouched()
    {
        self.searchTextField.resignFirstResponder();
    }
}

extension PopupTableView : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSearching {
            return self.filteredItems.count;
        } else {
            return self.items.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popupCell") as! PopupTableViewCell;
        var item : PopupModle! = nil;
        if self.isSearching {
            item = self.filteredItems[indexPath.row];
        } else {
            item = self.items[indexPath.row];
        }
        cell.titleLabel.text = item.name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        var item : PopupModle! = nil;
        if self.isSearching {
            item = self.filteredItems[indexPath.row];
        } else {
            item = self.items[indexPath.row];
        }
        if let delegate = self.popupDelegate {
            switch self.popviewType {
                case .brand:
                    delegate.didSelectBrand(brand: item);
                    break;
                case .modle:
                    delegate.didSelectModle(modle: item);
                    break;
                case .serviceType:
                    delegate.didSelectServiceType(serviceType: item);
                    break;
            }
        }
        self.close(sender: self.closeButton);
    }
}


extension PopupTableView : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearching = true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isSearching = false;
        self.popupCenterYConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded();
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.text!.characters.count > 0 || string.characters.count > 0{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                self.tableView.reloadData();
            });
        }
        return true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.tableView.reloadData();
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.searchbar.resignFirstResponder();
    }
}
