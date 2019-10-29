 //
//  AppDelegate.swift
//  Carefer
//
//  Created by Fatoo on 4/11/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

 

import UIKit
import CoreData
import CoreLocation
import Firebase
import GoogleMaps
import GooglePlaces
import Alamofire
import MBProgressHUD
import Foundation
import SystemConfiguration
import UserNotifications
import UserNotificationsUI
import FirebaseInstanceID
import FirebaseMessaging



 
 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate ,UNUserNotificationCenterDelegate,MessagingDelegate{
    //let googleMapsApiKey = "AIzaSyBM5LvzFaH4u_DYQWskllf9EAFFBAFBx7U" //for mine account
    let googleMapsApiKey  = "AIzaSyCT0q73xwMlCJvrX69a6RnoKbgAI1lxvyw" // for client account
    
    
    var window: UIWindow?
    var homeNavigationController : UINavigationController! = nil;
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var ArrayOfCities:NSMutableArray = []
    var ArrayOfServices:NSMutableArray = []
    var ArrayOfCarBrands:NSMutableArray = []
    var ArrayOfPlaceType:NSMutableArray = []
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set("no", forKey:"IsVerifyAsRoot")
        
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        
       // FIRApp.configure()
       
        
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        if #available(iOS 10.0, *) {
            UserDefaults.standard.set("no", forKey:"IsIOS9")
            UserDefaults.standard.set("no", forKey:"isFromForeGround")
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(tokenRefreshNotification), name:NSNotification.Name.InstanceIDTokenRefresh, object:nil)
        
        UserDefaults.standard.set("yes", forKey: "isFirstForCity")
        UserDefaults.standard.set("no", forKey: "fromOrderDone")
        if UserDefaults.standard.bool(forKey: Constants.kRegistrationSkipped)
        {
            self.setHomeVc()
        }
        else
        {
            if UserDefaults.standard.value(forKey: "phoneNumberPost") as? String == "yes"
            {
                if UserDefaults.standard.value(forKey: "codeVerified") as? String == "yes"
                {
                    if UserDefaults.standard.value(forKey: "isPolicyVerified") as? String == "1"
                    {
                        self.setHomeVc()
                    }
                    else
                    {
                        self.setPolicyVc()
                    }
                    
                }
                else
                {
                    
                    self.setVerifyCodeVc()
                }
            }
            else
            {
                self.setPhoneLoginVc()
            }
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                UserDefaults.standard.set("no", forKey:"showDistance")
                UserDefaults.standard.set(24.7136, forKey:"lat")
                UserDefaults.standard.set(46.6753, forKey:"long")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                UserDefaults.standard.set("yes", forKey:"showDistance")
            }
        } else {
            print("Location services are not enabled")
            UserDefaults.standard.set("no", forKey:"showDistance")
            UserDefaults.standard.set(24.7136, forKey:"lat")
            UserDefaults.standard.set(46.6753, forKey:"long")
            
        }
        
        if !UserDefaults.standard.bool(forKey: "isInstallEventLogged"){
            FirebaseLogger.shared.logEventInstallEvent();
            UserDefaults.standard.set(true, forKey: "isInstallEventLogged");
        }
        
        // Google Analytics
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
             return true
        }
        gai.tracker(withTrackingId: "UA-102096327-1")
        //gai.tracker(withTrackingId: "UA-111636951-1")
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
        
        
        return true
    }
    // for push notification
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type:FIRInstanceIDAPNSTokenType.sandbox)
        Messaging.messaging().apnsToken = deviceToken
        //FIRInstanceID.instanceID().setAPNSToken(deviceToken, type:FIRInstanceIDAPNSTokenType.prod)
        print(deviceToken)
//        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        UserDefaults.standard.set(token , forKey:"deviceTiken")
//        print(token)
        
    }
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey:"deviceTiken")
    
        //UserDefaults.standard.set(fcmToken , forKey:"deviceTiken")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
       // let refreshedToken = FIRInstanceID.instanceID().token()
        //print("InstanceID token: \(refreshedToken)")
        
        connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
             //   print("Unable to connect with FCM. \(error)")
            } else {
              //  print("Connected to FCM.")
            }
        }
    }
    
    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage) {
        print("noti recieve remote notification in extesnion")
        print("%@ debug", remoteMessage)
        print("%@", remoteMessage.appData)
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo as? NSDictionary
        print(userInfo)
        let notificationObject = userInfo?.value(forKey: "aps") as? NSDictionary
        print(notificationObject)
        let alert = notificationObject?.value(forKey: "alert") as? String
        let link = userInfo?.value(forKey: "gcm.notification.Link") as? String
        if link != nil {
        let url:NSURL = NSURL(string: link!)!
            if UIApplication.shared.canOpenURL(url as URL) {
               // UIApplication.shared.openURL(url as URL)
                UIApplication.shared.open(NSURL(string:link!)! as URL)
            } else {
                // Put your error handler code...
            }
        }
      
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        
        
        completionHandler( [.alert,.sound,.badge])
        
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        let aps = userInfo["aps"] as! NSDictionary
        let Link = userInfo["Link"] as! String
        if UIApplication.shared.applicationState == .active {
            print(userInfo)
            
            if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
            {
                
                print(info)
                let alertMsg = info["alert"] as! NSDictionary
                print(alertMsg)
                let title = alertMsg.value(forKey:"title") as! String
                let body = alertMsg.value(forKey:"body") as! String
                UserDefaults.standard.set(title, forKey:"title")
                UserDefaults.standard.set(body, forKey:"body")
                UserDefaults.standard.set(Link, forKey:"Link")
                UserDefaults.standard.set("yes", forKey:"IsIOS9")
                UserDefaults.standard.set("yes", forKey:"isFromForeGround")
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "urlReceived"), object:nil)
                
            }
        } else
        {
            
            print(userInfo)
            var url:NSURL = NSURL(string: Link)!
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            } else {
                // Put your error handler code...
            }
            UIApplication.shared.openURL(url as URL)
            
            //TODO: Handle background notification
        }
    }
    
    
    func isInternetAvailable() -> Bool
    {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let latestLocation: CLLocation = locations[locations.count - 1]
        UserDefaults.standard.set(latestLocation.coordinate.latitude, forKey:"lat")
        UserDefaults.standard.set(latestLocation.coordinate.longitude, forKey:"long")
        UserDefaults.standard.set("yes", forKey:"showDistance")
        
        if startLocation == nil {
            startLocation = latestLocation
        }
        
        let distanceBetween: CLLocationDistance =
            latestLocation.distance(from: startLocation)
        
        // distance.text = String(format: "%.2f", distanceBetween)
    }
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }
    // MARK: function
    
    func setVerifyCodeVc()
    {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "VerificationVc") as! VerifictionViewController
        UserDefaults.standard.set("yes", forKey:"IsVerifyAsRoot")
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        
    }
    func setPolicyVc()
    {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "PolicyVc") as! PolicyViewController
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        
    }
    
    func setPhoneLoginVc()
    {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "PhoneLoginVc") as! PhoneLoginViewController
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        
    }
    func setHomeVc()
    {
        var navController : UINavigationController ;
        if let homeNavController = self.homeNavigationController
        {
            navController = homeNavController;
        }
        else
        {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "mapVc") as! HomeViewController;
            self.homeNavigationController = UINavigationController(rootViewController: controller)
            navController = self.homeNavigationController;
        }
        navController.isNavigationBarHidden = true;
        self.window?.rootViewController = navController;
    }
    func setTabBarAsRootVc(selectedIndex:Int)
    {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let hoemVC = storyboard.instantiateViewController(withIdentifier: "tabBarVc")as! UITabBarController
        hoemVC.selectedIndex = selectedIndex
        self.window?.rootViewController = hoemVC
        
    }
    
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    @available(iOS 10.0, *)
    func saveContext () {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name:"www.Brushez.com-Shahd-Font-Regular.ttf", size:17) }
    }
    
}
