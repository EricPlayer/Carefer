//
//  FirebaseLogger.swift
//  Carefer
//
//  Created by Muzammal Hussain on 10/4/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAnalytics


class FirebaseLogger : NSObject
{
    fileprivate let INSTALL_EVENT_ID = 1;
    fileprivate let REGISTER_LATER_ID = 2;
    fileprivate let REGISTER_NOW_ID = 3;
    fileprivate let CREATE_ORDER_ID = 4;
    fileprivate let INSTALL_EVENT_NAME = "AppInstall";
    fileprivate let REGISTER_LATER_EVENT_NAME = "RegisterLater";
    fileprivate let REGISTER_NOW_EVENT_NAME = "RegisterNow";
    fileprivate let CREATE_ORDER_EVENT_NAME = "OrderCreated";
    fileprivate static let sharedInstance : FirebaseLogger = FirebaseLogger();
    public class var shared : FirebaseLogger {
        get {
            return sharedInstance;
        }
    }
    
    func logEventInstallEvent()
    {
        self.logEvent(name: INSTALL_EVENT_NAME, eventID: INSTALL_EVENT_ID);
    }
    
    func logRegisterLaterEvent()
    {
        self.logEvent(name: REGISTER_LATER_EVENT_NAME, eventID: REGISTER_LATER_ID);
    }
    
    func logRegisterNowEvent()
    {
        self.logEvent(name: REGISTER_NOW_EVENT_NAME, eventID: REGISTER_NOW_ID);
    }
    
    func logCreateOrderEvent()
    {
        self.logEvent(name: CREATE_ORDER_EVENT_NAME, eventID: CREATE_ORDER_ID);
    }
    
    fileprivate func logEvent(name:String, eventID: Int, contentType : String = "text")
    {
        Analytics.logEvent(name, parameters: nil);
    }
}
