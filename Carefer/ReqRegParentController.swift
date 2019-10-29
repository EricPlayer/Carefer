//
//  ReqRegParentController.swift
//  Carefer
//
//  Created by Muzammal Hussain on 9/12/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit

class ReqRegParentController : CareferParentController
{
    var reqRegistrationView : RegistrationView! = nil;
    var addReqRegViewOnDemand = false;
    
    var isUserDataAccessible : Bool {
        get {
            return !UserDefaults.standard.bool(forKey: Constants.kRegistrationSkipped)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if self.isUserDataAccessible
        {
            self.removeRequireRegistrationView();
        }
        else if !self.addReqRegViewOnDemand
        {
            self.addRequireRegistrationView(topMargin: nil);
        }
    }
    
    
    func addRequireRegistrationView(topMargin : CGFloat?)
    {
        if self.reqRegistrationView == nil {
            let regView = RegistrationView.registrationView();
            if self.addReqRegViewOnDemand {
                regView.btnCancel.isHidden = false;
            }
            regView.registrationDelegate = self;
            self.addAdjacentConstraints(superView: self.view, subView: regView, topMargin: topMargin);
            self.view.bringSubview(toFront: regView);
            self.reqRegistrationView = regView;
        }
    }
    
    func removeRequireRegistrationView()
    {
        if let view = self.reqRegistrationView {
            view.removeFromSuperview();
            self.reqRegistrationView = nil;
        }
    }
    
    func addAdjacentConstraints(superView : UIView, subView : UIView, topMargin : CGFloat?)
    {
        let y = topMargin == nil ? 64 : topMargin!
        subView.translatesAutoresizingMaskIntoConstraints = false;
        subView.frame = self.view.bounds;
        superView.addSubview(subView);
        let heightConstraint = NSLayoutConstraint(item: subView, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1.0, constant: -y);
        let widthConstraint = NSLayoutConstraint(item: subView, attribute: .width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1.0, constant: 0);
        let xMarginConstraint = NSLayoutConstraint(item: subView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0);
        let yMarginConstraint = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: y);
        superView.addConstraints([heightConstraint, widthConstraint, xMarginConstraint, yMarginConstraint]);
    }
    
    func postRegisterationFinishedNotfication()
    {
        NotificationCenter.default.post(name: Notification.Name.kNotifRegLaterFinish, object: nil);
    }
    
    func removeRegistrationFinishedObserver(controller : UIViewController)
    {
        NotificationCenter.default.removeObserver(controller, name: Notification.Name.kNotifRegLaterFinish, object: nil);
    }
}

extension ReqRegParentController : RegistrationViewDelegate
{
    func didTapRegisterButton()
    {
        if let loginController = self.storyboard?.instantiateViewController(withIdentifier: "PhoneLoginVc") as? PhoneLoginViewController
        {
            loginController.isFromRegisterLater = true;
            loginController.registerLaterDelegate = self;
            let navController = UINavigationController(rootViewController: loginController);
            navController.setNavigationBarHidden(true, animated: false);
            self.present(navController, animated: true, completion: nil);
        }
    }
    
    func removeReferenceToRegistrationViw()
    {
        self.removeRequireRegistrationView();
    }
}

extension ReqRegParentController : RegisterLaterDelegate
{
    func didRegister()
    {
        
    }
    
    func didFailRegistration()
    {
        
    }
    
    func didCancelRegistration()
    {
        
    }
}
