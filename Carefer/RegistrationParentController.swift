//
//  RegistrationParentController.swift
//  Carefer
//
//  Created by Muzammal Hussain on 9/13/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit


protocol RegisterLaterDelegate : NSObjectProtocol {
    func didRegister();
    func didCancelRegistration();
    func didFailRegistration();
}


class RegistrationParentController : UIViewController
{
    var isFromRegisterLater = false;
    var registerLaterDelegate : RegisterLaterDelegate? = nil;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
    }
    
    @IBAction func cancelRegistration(_ sender: Any)
    {
        if let delegate = self.registerLaterDelegate {
            delegate.didCancelRegistration();
        }
        self.navigationController?.dismiss(animated: true, completion: nil);
    }
}
