//
//  RegistrationView.swift
//  Carefer
//
//  Created by Muzammal Hussain on 9/12/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit


protocol RegistrationViewDelegate : NSObjectProtocol {
    func didTapRegisterButton();
    func removeReferenceToRegistrationViw();
}

class RegistrationView : UIView
{
    
    //you are not registered yet, to access this feature registration required  =  أنت غير مسجل حتى الآن، للوصول إلى هذه الميزة تسجيل المطلوبة
    //Register = تسجيل
    @IBOutlet weak var btnCancel: UIButton!
    var registrationDelegate : RegistrationViewDelegate? = nil;
    
    class func registrationView() -> RegistrationView
    {
        let view = Bundle.main.loadNibNamed("RegistrationView", owner: nil, options: nil)?.first as! RegistrationView;
        return view;
    }
    
    @IBAction func register(_ sender: Any)
    {
        if let delegate = self.registrationDelegate {
            delegate.didTapRegisterButton();
        }
    }
    
    @IBAction func cancelRegistration(_ sender: Any)
    {
        if let delegate = self.registrationDelegate {
            delegate.removeReferenceToRegistrationViw();
        }
    }
}
