//
//  HomeViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/12/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import MBProgressHUD
import SDWebImage
import SCLAlertView
import CoreLocation
import UserNotifications
import GoogleMaps
class HomeViewController: CustomTabBarParentController ,UITableViewDelegate,UITableViewDataSource, MKMapViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    // Filters outlets start
    @IBOutlet weak var lblShowFilterdResult :UILabel!
    @IBOutlet weak var filterLabel :UILabel!
    @IBOutlet weak var sortLabel :UILabel!
    @IBOutlet weak var lblShowTextforExpandMoreResult :UILabel!
    @IBOutlet weak var lblTitle :UILabel!
    @IBOutlet weak var lblProvideWarrenty :UILabel!
    @IBOutlet weak var lblProvideSpareParts :UILabel!
    @IBOutlet weak var lblTopRating :UILabel!
    @IBOutlet weak var btnShowResult :UIButton!
    @IBOutlet weak var btnReferehFilter :UIButton!
    @IBOutlet weak var provideWarrantlySwitch :UISwitch!
    @IBOutlet weak var provideSpareParsSwitch :UISwitch!
    @IBOutlet weak var topRatingSwitch :UISwitch!
    var locationManager: CLLocationManager!
    
    // Filters outlets end
    
    
    @IBOutlet weak var btnSearchthisAreaOnMap:UIButton!
    @IBOutlet weak var btnMySearch:UIButton!
    @IBOutlet weak var btnScrollListAtTop:UIButton!
    @IBOutlet weak var btnMyExplorer:UIButton!
    @IBOutlet weak var receiveShopButton:UIButton!
    @IBOutlet weak var movedShopButton:UIButton!
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var btnShowMapOfservce:UIButton!
    @IBOutlet weak var btnShowMapOfmodel:UIButton!
    @IBOutlet weak var btnShowMapOfbrnd:UIButton!
    @IBOutlet weak var txtFieldView :UIView!
    @IBOutlet weak var viewForMap :UIView!
    @IBOutlet weak var navigationBar:UIView!
    @IBOutlet weak var ShopingListView :UIView!
    @IBOutlet weak var SearchtypeSelectionView :UIView!
    @IBOutlet weak var serviceBarndPlaceTypeView :UIView!
    
    @IBOutlet weak var btnSetting:UIButton!
    @IBOutlet weak var btnFilter:UIButton!
    
    
    
    @IBOutlet weak var lblNavigationTitle :UILabel!
    @IBOutlet weak var lblMapButtonTitle :UILabel!
    @IBOutlet weak var lblShopsCount :UILabel!
    @IBOutlet weak var lblCarBrand :UILabel!
    @IBOutlet weak var lblCurrentLocation :UILabel!
     @IBOutlet weak var map:GMSMapView!
    @IBOutlet weak var tabbarView:UIView!
    @IBOutlet weak var tblCities:UITableView!
    @IBOutlet weak var tblserviceType:UITableView!
    @IBOutlet weak var tblCarbrand:UITableView!
    @IBOutlet weak var tblShopList:UITableView!
    @IBOutlet weak var txtSearchField:UITextField!
    
    @IBOutlet weak var btnFilterDoneHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var btnFilterHeightHeightConstraint:NSLayoutConstraint!
    
    let layerGradient = CAGradientLayer()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var aarayserviceType = NSMutableArray()
    var ArrayOfSections = NSMutableArray()
    var aarayOFserviceTypeForNextController = NSMutableArray()
    var arrayCararnd = NSMutableArray()
    var arrayOFPlaceTypes = NSMutableArray()
    var arrayShopsList = NSMutableArray()
    var arrayPoints = NSMutableArray()
    var filteredArrayShopsList = NSMutableArray()
    var arrayOfServicesSelected = NSMutableArray()
    var arrayOfBrandSelected = NSMutableArray()
    var arrayOfPlaceTypeSelected = NSMutableArray()
    var indexPathOfSelectedFilter = NSMutableArray()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var issearchActive = false
    var isFirstClick = false
    var isNameSearchButtonClick = false
    var filterType :String!
    var searchByName:String! = "test"
    var ServiceBrandPlacetype:String!
    var isMapMove = false
    var isMapreferesh = false
    var isListPopulate = false
    var isDefaultValueLoad = false
    var previousIndexPathRow = 0
    
    // For Custom Annotation View
    var coordinates:NSMutableArray = []
    var names :NSMutableArray = []
    var addresses :NSMutableArray = []
    var phones:NSMutableArray = []
    var serviceType:NSMutableArray = []
    var rating:NSMutableArray =  []
    var images:NSMutableArray =  []
    var arrayOfCites:NSMutableArray = []
    var isExpande = false
    var isSelectedForFilter = false
    var indexPathwithRow = 0
    var latOnMapClick:Double!
    var longOnMapClick:Double!
    var isFind = false
    var lastID : String?
    var backCheck = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //let topShadow = EdgeShadowLayer(forView:self.navigationBar, edge:.Bottom)
        //self.navigationBar.layer.addSublayer(topShadow)
        

        self.addHideListObserver();
        
        self.btnSetting.setImage(UIImage(named:"1x-arrows"), for: .normal)
        self.sortLabel.font = UIFont(name:Constants.kShahidFont ,size:14)
        self.sortLabel.text = "ترتيب";

        
        
        self.btnFilter.setImage(UIImage(named:"filter"), for: .normal)
        self.filterLabel.font = UIFont(name:Constants.kShahidFont ,size:14)
        self.filterLabel.text = "تصفية";
        
        if(UIScreen.main.traitCollection.userInterfaceIdiom == .phone) {
            self.btnSetting.imageEdgeInsets = UIEdgeInsets(top: 6,left: 40,bottom: 6,right: 14)
            //self.btnSetting.titleEdgeInsets = UIEdgeInsets(top: 0,left: -20,bottom: 0,right: 37)
            
            self.btnFilter.imageEdgeInsets = UIEdgeInsets(top: 6,left: 40,bottom: 6,right: 14)
            //self.btnFilter.titleEdgeInsets = UIEdgeInsets(top: 0,left: -35,bottom: 0,right: 45)
        } else {
            self.sortLabel.textAlignment = NSTextAlignment.center;
            self.filterLabel.textAlignment = NSTextAlignment.center;
        }
        
        self.txtSearchField.font  = UIFont(name:Constants.kShahidFont, size:14)
        self.tblShopList.contentInset = UIEdgeInsetsMake(0.0, 0.0, (70), 0.0);
        self.tblShopList.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, (70), 0.0);
        self.btnMyExplorer.isEnabled = false
        self.txtSearchField.attributedPlaceholder = NSAttributedString(string:self.txtSearchField.placeholder!,
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
        NotificationCenter.default.addObserver(self, selector:#selector(self.showLocalNotification), name:NSNotification.Name(rawValue: "urlReceived"), object:nil)
        self.tblShopList.separatorStyle = .none
        ServiceBrandPlacetype = "s"
        self.viewForMap.isHidden = true
        if UserDefaults.standard.value(forKey: "isFirstForCity")as! String == "yes"
        {
            
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    let uiAlert = UIAlertController(title:nil, message:"يلزم صلاحية الموقع لتحديد المكان", preferredStyle: UIAlertControllerStyle.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    
                    uiAlert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
                        
                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                        
                    }))
                    
                    uiAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { action in
                        //println("Click of cancel button")
                    }))
                    
                    
                    
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                }
            } else {
                let uiAlert = UIAlertController(title:nil, message:"يلزم صلاحية الموقع لتحديد المكان", preferredStyle: UIAlertControllerStyle.alert)
                self.present(uiAlert, animated: true, completion: nil)
                
                uiAlert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
                    
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                }))
                
                uiAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { action in
                    //println("Click of cancel button")
                }))
                
                
                
                print("Location services are not enabled")
            }
            if (CLLocationManager.locationServicesEnabled())
            {
//                locationManager = CLLocationManager()
//                locationManager.delegate = self
//                locationManager.desiredAccuracy = kCLLocationAccuracyBest
//                locationManager.requestAlwaysAuthorization()
//                locationManager.startUpdatingLocation()
            }
            

         self.getCities()
         self.getPlaceTypes()
         self.isMapreferesh = false
            
        }
        else
        {
           
            self.aarayOFserviceTypeForNextController = self.appDelegate.ArrayOfServices
            self.arrayCararnd = self.appDelegate.ArrayOfCarBrands
            self.arrayOFPlaceTypes = self.appDelegate.ArrayOfPlaceType
            let   latFrom = Double(UserDefaults.standard.value(forKey:"lat") as! NSNumber)
            let    longFrom = Double(UserDefaults.standard.value(forKey:"long") as! NSNumber)
            let id = UserDefaults.standard.value(forKey: "selectedCityID") as! String
            let selectedCityName = UserDefaults.standard.value(forKey: "selectedCityName") as! String
            self.lblCurrentLocation.text = selectedCityName
//            if UserDefaults.standard.value(forKey: "isFirstForCity")as! String == "no"
//            {
            self.getShopsListCityWise(cityID:id , lat:latFrom, long: longFrom, moapOrList: "l")
//            }
//            else
//            {
//                self.getCities()
//                self.getPlaceTypes()
//                self.isMapreferesh = true
//            }
        
        }
        
        
        self.tblCities.isHidden = true
        self.tblCities.tableFooterView = UIView()
        self.btnSearchthisAreaOnMap.isHidden = true
        self.btnSearchthisAreaOnMap.setTitle("البحث في هذه المنطقة", for:.normal)
        self.btnSearchthisAreaOnMap.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:14)
        let longPressGesture = UIPanGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
         longPressGesture.delegate = self
        self.map.addGestureRecognizer(longPressGesture)
//
        ArrayOfSections.add("نوع الخدمة")
        ArrayOfSections.add("ماركة السيارة")
        ArrayOfSections.add("نوع المكان")
        
        self.tblserviceType.allowsMultipleSelection = true
        
        self.lblMapButtonTitle.font = UIFont(name:Constants.kShahidFont ,size:16)
        
        //self.txtFieldView.layer.cornerRadius = 15
        //self.txtFieldView.clipsToBounds = true
        self.btnMySearch.isHidden = true
        self.txtSearchField.isHidden = true
        self.map.delegate = self
        
        
        self.tblserviceType.allowsMultipleSelection = true
        self.tblserviceType.delegate = self
        self.tblShopList.delegate = self
        self.tblserviceType.isHidden = true
        SearchtypeSelectionView.isHidden = true
        serviceBarndPlaceTypeView.isHidden = true
        
        self.tblShopList.estimatedRowHeight = 76
        self.tblShopList.rowHeight = UITableViewAutomaticDimension
        self.tblShopList.tableFooterView = UIView()
        
        self.tblserviceType.tableFooterView = UIView()
        //self.tblShopList.separatorStyle = .none
        if UserDefaults.standard.value(forKey: "fromOrderDone") as! String == "yes"
        {
            self.ShopingListView.isHidden = false
            self.btnBack.isHidden = false
            MBProgressHUD.hide(for:self.view, animated:true)
            MBProgressHUD.hide(for:self.view, animated:true)
        }
        else
        {
            self.ShopingListView.isHidden = true
            self.btnBack.isHidden = true
        }
        
        
        self.lblNavigationTitle.text =  "الخريطة"
       
        filterType = "0" // 0 use for none
        self.lblShopsCount.font = UIFont(name:Constants.kShahidFont, size:14)
                // Do any additional setup after loading the view.
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        
       
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.btnFilterDoneHeightConstraint.constant = 100
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblCurrentLocation.font = UIFont(name:Constants.kShahidFont ,size:21)
            
            self.btnShowResult.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.btnReferehFilter.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.btnShowMapOfbrnd.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.btnShowMapOfmodel.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.btnShowMapOfservce.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.btnMyExplorer.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblTitle.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblProvideWarrenty.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblProvideSpareParts.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblTopRating.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblShowTextforExpandMoreResult.font = UIFont(name:Constants.kShahidFont ,size:21)
            self.lblShowFilterdResult.font = UIFont(name:Constants.kShahidFont ,size:21)
        case .phone:
            self.btnFilterDoneHeightConstraint.constant = 49
            print("iPhone and iPod touch style UI")
            self.btnShowMapOfbrnd.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
            if self.view.frame.width == 320 {
                self.btnMyExplorer.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:12)
                self.movedShopButton.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:12)
                self.receiveShopButton.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:12)
            } else {
                self.btnMyExplorer.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:14)
                self.movedShopButton.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:14)
                self.receiveShopButton.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:14)
            }
            self.btnShowMapOfmodel.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.btnShowMapOfservce.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont ,size:19)
            self.lblCurrentLocation.font = UIFont(name:Constants.kShahidFont ,size:16)
            
            self.btnShowResult.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.btnReferehFilter.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblTitle.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblProvideWarrenty.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblProvideSpareParts.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblTopRating.font = UIFont(name:Constants.kShahidFont ,size:16)
            self.lblShowTextforExpandMoreResult.font = UIFont(name:Constants.kShahidFont ,size:14)
            self.lblShowFilterdResult.font = UIFont(name:Constants.kShahidFont ,size:16)
            
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }
        
        self.btnScrollListAtTop.isHidden = true
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Home Screen")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
               
    }
    override func viewDidAppear(_ animated: Bool) {
       
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        UserDefaults.standard.set(location.coordinate.latitude, forKey:"lat")
        UserDefaults.standard.set(location.coordinate.longitude, forKey:"long")
        UserDefaults.standard.set("yes", forKey:"showDistance")
    }
    @IBAction func btnScrollListAtTop(sender:UIButton)
    {
        self.btnScrollListAtTop.isHidden = true
        self.tblShopList.setContentOffset(CGPoint.zero, animated: true)
    }
    func showLocalNotification()
    {
        
        
        
        
        if UserDefaults.standard.value(forKey: "IsIOS9") as! String == "yes"
        {
            if UserDefaults.standard.value(forKey: "isFromForeGround") as! String == "yes"
            {
        let uiAlert = UIAlertController(title:UserDefaults.standard.value(forKey:"title") as? String, message:UserDefaults.standard.value(forKey:"body") as? String, preferredStyle: UIAlertControllerStyle.alert)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
            let url:NSURL = NSURL(string: UserDefaults.standard.value(forKey: "Link") as! String)!
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            } else {
                // Put your error handler code...
            }
            UIApplication.shared.openURL(url as URL)
            
            
        }))
        
        uiAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { action in
            //println("Click of cancel button")
        }))
        }
        }
        

    }
    @IBAction func btnZoomMapAtCurrnetlocation(sender:UIButton)
    {
        
        if UserDefaults.standard.value(forKey: "showDistance") as! String == "yes"
        {
            let   lati = Double(UserDefaults.standard.value(forKey: "lat")as! NSNumber)
            let   longi = Double(UserDefaults.standard.value(forKey: "long") as! NSNumber)
            let location = CLLocation(latitude: lati as CLLocationDegrees, longitude: longi as CLLocationDegrees)
            map.isMyLocationEnabled = true
            // map.settings.myLocationButton = true
            map.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        else
        {
            let uiAlert = UIAlertController(title:nil, message:"يلزم صلاحية الموقع لتحديد المكان", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
                
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            }))
            
            uiAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { action in
                //println("Click of cancel button")
            }))
            
        }
    }
    
    
    @IBAction func callHelpLine(sender: Any)
    {
        let phoneNumber = "920008629";
        let phoneUrl = URL(string: "telprompt://"+phoneNumber);
        let phoneFallbackUrl = URL(string: "tel://"+phoneNumber);
        
        if let url = phoneUrl, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url);
        } else if  let url = phoneFallbackUrl, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url);
        } else {
            // Your device can not make phone calls.
        }
    }
    
 @IBAction func btnMyDeals(sender:UIButton)
    {
        UserDefaults.standard.set("yes", forKey: "isFirstForCity")
    self.appDelegate.setTabBarAsRootVc(selectedIndex:0)
    }
  @IBAction  func btnMyOrders(sender:UIButton)
    {
        UserDefaults.standard.set("yes", forKey: "isFirstForCity")
      self.appDelegate.setTabBarAsRootVc(selectedIndex:1)
    }
  @IBAction  func btnFavShops(sender:UIButton)
    {
        UserDefaults.standard.set("yes", forKey: "isFirstForCity")
        self.appDelegate.setTabBarAsRootVc(selectedIndex:2)
    }
  @IBAction  func btnshare(sender:UIButton)
    {
        UserDefaults.standard.set("yes", forKey: "isFirstForCity")
        self.appDelegate.setTabBarAsRootVc(selectedIndex:3)
    }
  @IBAction  func btnaboutUs(sender:UIButton)
    {
        UserDefaults.standard.set("yes", forKey: "isFirstForCity")
       self.appDelegate.setTabBarAsRootVc(selectedIndex:4)
    }
    
    @IBAction  func movedShopAction(sender:UIButton)
    {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MovedShopViewController") as? MovedShopViewController {
            self.show(controller, sender: self);
        }
    }
    
    
    @IBAction  func receivedCarAction(sender:UIButton)
    {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReceivedCarController") as? ReceivedCarController {
            self.show(controller, sender: self);
        }
    }
    
    @IBAction  func btnExplorer(sender:UIButton)
    {
        
//        if isListPopulate == false
//        {
//            
//            isListPopulate = true
        let  lati = Double(UserDefaults.standard.value(forKey: "lat")as! NSNumber)
        let   longi = Double(UserDefaults.standard.value(forKey: "long") as! NSNumber)
//        if self.lblCurrentLocation.text != "الرياض"
//        {
        if self.arrayPoints.count == 0
        {

            let  formateType = "name CONTAINS[C] %@"
            let  searchString = "الرياض"
            let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
            let serviceArray = (self.appDelegate.ArrayOfCities as NSMutableArray).filtered(using: serviceSearchPredicate)
            if serviceArray.count>0
            {
                
                let cityObject  = serviceArray [0] as! NSDictionary
                let id = cityObject.value(forKey: "ID") as! String
                self.lblCurrentLocation.text = cityObject.value(forKey: "name") as? String
                self.isMapreferesh = false

                self.getShopsListCityWise(cityID: id ,lat: lati,long:longi,moapOrList: "m")
                UserDefaults.standard.set(self.lblCurrentLocation.text, forKey:"selectedCityName")
                UserDefaults.standard.set(id, forKey:"selectedCityID")
                
            }
            //}
            
        }
        else
        {
            
            self.arrayShopsList = []
            self.arrayShopsList = self.arrayPoints
            self.lblShowFilterdResult.text = "\(self.arrayShopsList.count) ورشة من أصل  \(self.arrayShopsList.count) "
            self.lblShopsCount.text = " عدد الورش \(self.arrayShopsList.count)"

            self.tblShopList.reloadData()
           // let id = UserDefaults.standard.value(forKey: "selectedCityID") as! String
            //self.getShopsListCityWise(cityID: id ,lat: lati,long:longi,moapOrList: "m")
        }
       // }
        //}
        
        self.viewForMap.isHidden = false
        self.ShopingListView.isHidden = false
        self.btnBack.isHidden = false
        self.lblNavigationTitle.text =  "قائمة الورش"
        self.btnMySearch.isHidden = false
        self.txtSearchField.isHidden = false
    }
    @IBAction  func btnBack(sender:UIButton)
    {
     
        if self.backCheck {
            backCheck = false
            self.viewForMap.isHidden = false
            self.ShopingListView.isHidden = false
            
            let shopDetailVc = self.storyboard?.instantiateViewController(withIdentifier: "shopDetailVc") as! ShopDetailViewController
            shopDetailVc.shopId = self.lastID

            self.navigationController?.pushViewController(shopDetailVc, animated: true)
        }else{
        
       //self.navigationController?.popViewController(animated: true)
       self.viewForMap.isHidden = true
       self.ShopingListView.isHidden = true
       self.SearchtypeSelectionView.isHidden = true
       self.serviceBarndPlaceTypeView.isHidden = true
       self.btnBack.isHidden = true
       self.lblNavigationTitle.text = "الخريطة"
        self.txtSearchField.resignFirstResponder();
       }
    }
    @IBAction  func btnServiceType(sender:UIButton)
    {
        if self.arrayShopsList.count != 0 ||  self.filteredArrayShopsList.count != 0
        {
        self.tblserviceType.isHidden = false
        self.tblserviceType.reloadData()
        SearchtypeSelectionView.isHidden = false
            //self.tblserviceType.isHidden = true
            self.serviceBarndPlaceTypeView.isHidden = true
            
        }
        
        
    }
    @IBAction func btnCancelFilter()
    {
        self.filteredArrayShopsList.removeAllObjects()
        MBProgressHUD.showAdded(to: self.view, animated:true)
         SearchtypeSelectionView.isHidden = true
         issearchActive = false
         //self.tblShopList.reloadData()
        self.topRatingSwitch.isOn = false
        self.provideSpareParsSwitch.isOn = false
        self.provideWarrantlySwitch.isOn = false
         self.isFirstClick = false
        var newArry = NSMutableArray()
        for i in 0..<self.aarayOFserviceTypeForNextController.count {
            let  dic =  NSMutableDictionary()
            let serviceObject = aarayOFserviceTypeForNextController[i] as! NSDictionary
            //print(serviceObject)
            let id = serviceObject.value(forKey: "ID") as! String
            let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
            let serviceTypeName = serviceObject.value(forKey: "serviceTypeName") as! String
            
            dic.setValue(id, forKey:"ID")
            dic.setValue(dateAdded, forKey:"dateAdded")
            dic.setValue(serviceTypeName, forKey:"serviceTypeName")
            dic.setValue(false, forKey:"isSelected")
            newArry.add(dic)
            
        }
        self.aarayOFserviceTypeForNextController = []
        self.aarayOFserviceTypeForNextController = newArry
        newArry = []
        
        for i in 0..<self.arrayCararnd.count {
            let  dic =  NSMutableDictionary()
            let serviceObject = arrayCararnd[i] as! NSDictionary
            //print(serviceObject)
            let id = serviceObject.value(forKey: "ID") as! String
            let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
            let serviceTypeName = serviceObject.value(forKey: "brandName") as! String
            
            dic.setValue(id, forKey:"ID")
            dic.setValue(dateAdded, forKey:"dateAdded")
            dic.setValue(serviceTypeName, forKey:"brandName")
            dic.setValue(false, forKey:"isSelected")
            newArry.add(dic)
        }
        
        self.arrayCararnd = []
        self.arrayCararnd = newArry
        newArry = []

        for i in 0..<self.arrayOFPlaceTypes.count {
            let  dic =  NSMutableDictionary()
            let serviceObject = arrayOFPlaceTypes[i] as! NSDictionary
            //print(serviceObject)
            let id = serviceObject.value(forKey: "ID") as! String
            let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
            let serviceTypeName = serviceObject.value(forKey: "name") as! String
            
            dic.setValue(id, forKey:"ID")
            dic.setValue(dateAdded, forKey:"dateAdded")
            dic.setValue(serviceTypeName, forKey:"name")
            dic.setValue(false, forKey:"isSelected")
            newArry.add(dic)
        }
        self.arrayOFPlaceTypes = []
        self.arrayOFPlaceTypes = newArry
        newArry = []
         self.filteredArrayShopsList = []
        self.issearchActive = false
         self.tblShopList.reloadData()
         self.lblShowFilterdResult.text = "\(self.arrayShopsList.count) ورشة من أصل  \(self.arrayShopsList.count) "
        self.lblShopsCount.text = " عدد الورش \(self.arrayShopsList.count)"
        self.lblShowTextforExpandMoreResult.text = "اختيار جيد!الذهاب نرى ما تبدو المحلات التجارية الخاصة بك الكمال."
         MBProgressHUD.hide(for:self.view, animated:true)

    }
    @IBAction func btnCancelBrandServicePlacetypeFilter(sender:UIButton!)
    {
        var newArry = NSMutableArray()
        if self.ServiceBrandPlacetype == "s"
        {
        
        for i in 0..<self.aarayOFserviceTypeForNextController.count {
            let  dic =  NSMutableDictionary()
            let serviceObject = aarayOFserviceTypeForNextController[i] as! NSDictionary
            //print(serviceObject)
            let id = serviceObject.value(forKey: "ID") as! String
            let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
            let serviceTypeName = serviceObject.value(forKey: "serviceTypeName") as! String
            
            dic.setValue(id, forKey:"ID")
            dic.setValue(dateAdded, forKey:"dateAdded")
            dic.setValue(serviceTypeName, forKey:"serviceTypeName")
            dic.setValue(false, forKey:"isSelected")
            newArry.add(dic)
            
        }
        self.aarayOFserviceTypeForNextController = []
        self.aarayOFserviceTypeForNextController = newArry
        newArry = []
        }
        if self.ServiceBrandPlacetype == "b"
        {
        for i in 0..<self.arrayCararnd.count {
            let  dic =  NSMutableDictionary()
            let serviceObject = arrayCararnd[i] as! NSDictionary
            //print(serviceObject)
            let id = serviceObject.value(forKey: "ID") as! String
            let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
            let serviceTypeName = serviceObject.value(forKey: "brandName") as! String
            
            dic.setValue(id, forKey:"ID")
            dic.setValue(dateAdded, forKey:"dateAdded")
            dic.setValue(serviceTypeName, forKey:"brandName")
            dic.setValue(false, forKey:"isSelected")
            newArry.add(dic)
        }
        
        self.arrayCararnd = []
        self.arrayCararnd = newArry
        newArry = []
        }
        if self.ServiceBrandPlacetype == "p"
        {
        
            for i in 0..<self.arrayOFPlaceTypes.count {
                let  dic =  NSMutableDictionary()
                let serviceObject = arrayOFPlaceTypes[i] as! NSDictionary
                //print(serviceObject)
                let id = serviceObject.value(forKey: "ID") as! String
                let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                let serviceTypeName = serviceObject.value(forKey: "name") as! String
                
                dic.setValue(id, forKey:"ID")
                dic.setValue(dateAdded, forKey:"dateAdded")
                dic.setValue(serviceTypeName, forKey:"name")
                dic.setValue(false, forKey:"isSelected")
                newArry.add(dic)
            }
            self.arrayOFPlaceTypes = []
            self.arrayOFPlaceTypes = newArry
            newArry = []
        }
        self.tblserviceType.reloadData()
        self.serviceBarndPlaceTypeView.isHidden = true
        self.filterOnSwitchOffAndunselcetion()
      
    
    }
    
    @IBAction func btnBackToMap(sender:UIButton)
    {
        
        self.viewForMap.isHidden = true
        self.ShopingListView.isHidden = true
        
    }
    @IBAction func btnOkBrandServicePlacetypeFilter(sender:UIButton!)
    {
        self.serviceBarndPlaceTypeView.isHidden = true
        
    }
    @IBAction func btnSelectCity(sender:UIButton!)
    {
        self.btnScrollListAtTop.isHidden = true
        self.tblCities.reloadData()
        self.tblCities.isHidden = false
    }
    @IBAction func btnShowServiceTypesOnFilter(sender:UIButton)
    {
         ServiceBrandPlacetype = "s"
        self.serviceBarndPlaceTypeView.isHidden = false
        self.tblserviceType.reloadData()
    }
    @IBAction func btnShowBrandsOnFilter(sender:UIButton)
    {
        ServiceBrandPlacetype = "b"
        self.serviceBarndPlaceTypeView.isHidden = false
        self.tblserviceType.reloadData()
    }
    @IBAction func btnShowPlaceTypesOnFilter(sender:UIButton)
    {
        ServiceBrandPlacetype = "p"
        self.serviceBarndPlaceTypeView.isHidden = false
        self.tblserviceType.reloadData()
    }
    @IBAction func btnBackFromFilterSelection(sender:UIButton)
    {
        self.issearchActive = false
        self.lblShopsCount.text = " عدد الورش \(self.arrayShopsList.count)"
        self.tblShopList.reloadData()
        SearchtypeSelectionView.isHidden = true
        self.serviceBarndPlaceTypeView.isHidden = true
    }
    @IBAction func btnDoneFilter()
    {
        //SearchtypeSelectionView.isHidden = true
        //self.serviceBarndPlaceTypeView.isHidden = true
        if self.filteredArrayShopsList.count > 0
        {
            SearchtypeSelectionView.isHidden = true
            self.serviceBarndPlaceTypeView.isHidden = true
            self.lblShopsCount.text = " عدد الورش \(self.filteredArrayShopsList.count)"
            issearchActive = true
            self.tblShopList.reloadData()
        }
        else
        {
        //issearchActive = false
          //  self.lblShopsCount.text = " عدد الورش \(self.arrayShopsList.count)"
            
            let alert = UIAlertController(title: "لم يتم العثور على أي نتائج حتى الآن!", message:nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "إلغاء", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        //self.tblShopList.reloadData()
        
    }
    @IBAction func btnArrowUpDown(sender:UIButton)
    {
        self.btnScrollListAtTop.isHidden = true
        if self.arrayShopsList.count != 0 ||  self.filteredArrayShopsList.count != 0
        {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true
        )
 let color = UIColor(red: 158/255, green: 51/255, blue: 2/255, alpha: 1.0)
        let alertView = SCLAlertView(appearance:appearance)
            alertView.addButton("الاسم", backgroundColor:color, textColor:UIColor.white, showDurationStatus:true, action:
                {
                    print("name")
                    let appearance = SCLAlertView.SCLAppearance(
                        showCloseButton: true
                    )
                    
                    let alertView = SCLAlertView(appearance:appearance)
                    let color = UIColor(red: 158/255, green: 51/255, blue: 2/255, alpha: 1.0)
                    alertView.addButton("تصاعدي", backgroundColor:color, textColor:UIColor.white, showDurationStatus:true, action:
                        {
                            self.sortByName(order:"a")
                    })
                    alertView.addButton("تنازلي", backgroundColor:color, textColor:UIColor.white, showDurationStatus:true, action:
                        {
                            
                            self.sortByName(order:"d")
                    })
                    
                    alertView.showSuccess("", subTitle:"ترتيب")
                    
                    
                    
            })

       
        alertView.addButton("التقييم", backgroundColor:color, textColor:UIColor.white, showDurationStatus:true, action:
            {
        print("rating")
                self.sortByRating()
        })
        alertView.addButton("المسافة", backgroundColor:color, textColor:UIColor.white, showDurationStatus:true, action:
            {
                if UserDefaults.standard.value(forKey: "showDistance") as! String == "yes"
                {
                    self.sortByDistance()
                }
                else
                {
                    let uiAlert = UIAlertController(title:nil, message:"لايوجد صلاحية للوصول إلى الموقع …!", preferredStyle: UIAlertControllerStyle.alert)
                                    self.present(uiAlert, animated: true, completion: nil)
                    
                                    uiAlert.addAction(UIAlertAction(title: "موافق", style: .default, handler: { action in
                                        
                                                            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                                                return
                                                            }
                                        
                                                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                                                if #available(iOS 10.0, *) {
                                                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                                                        print("Settings opened: \(success)") // Prints true
                                                                    })
                                                                } else {
                                                                    // Fallback on earlier versions
                                                                }
                                                            }
                    
                                    }))
                    
                                    uiAlert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { action in
                                        //println("Click of cancel button")
                                    }))
                    
 
                    

                }
                print("Distance")
               
        })
        
            
        alertView.showSuccess("", subTitle: "ترتيب")
        }
        
        
    }
    
    func sortByRating()
    {
     self.btnScrollListAtTop.isHidden = true
        var ArrayBeforeSort = NSMutableArray()
        if  issearchActive == true
        {
        ArrayBeforeSort = self.filteredArrayShopsList
        }
        else
        
        {
        ArrayBeforeSort = arrayShopsList
        }
        
        let arrayToSort = NSMutableArray()
        for i in 0..<ArrayBeforeSort.count
        {
            let dic = ArrayBeforeSort[i] as! NSDictionary
            let  someString = dic.value(forKey: "shopRating") as! String
            if let myInteger = Double(someString) {
                let myNumber = NSNumber(value:myInteger)
                arrayToSort.add(myNumber)
            }
            
            
        }
        
        //var array = [5,3,4,6,8,2,9,1,7,10,11]
        let sortedArray = NSMutableArray(array: arrayToSort)
        var sortedAboveIndex = arrayToSort.count
        self.filteredArrayShopsList = ArrayBeforeSort
        var swaps = 0
        
        repeat {
            var lastSwapIndex = 0
            
            for i in 1..<sortedAboveIndex {
                if (sortedArray[i - 1] as! Float) < (sortedArray[i] as! Float) {
                    sortedArray.exchangeObject(at: i, withObjectAt: i-1)
                    self.filteredArrayShopsList.exchangeObject(at: i, withObjectAt:i-1)
                    lastSwapIndex = i
                    swaps += 1
                }
            }
            
            sortedAboveIndex = lastSwapIndex
            
        } while (sortedAboveIndex != 0)
        
        
        // [5, 3, 4, 6, 8, 2, 9, 1, 7, 10, 11]
        //print(arrayToSort)
        
        // [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        //print(sortedArray as Array)
        //print(self.filteredArrayShopsList)
        //print("Array is sorted in \(swaps) swaps.")
        //print(filteredArrayShopsList)
        self.issearchActive = true
        self.tblShopList.reloadData()

    }
    func sortByDistance()
    {
        var ArrayBeforeSort = NSMutableArray()
        if  issearchActive == true
        {
            ArrayBeforeSort = self.filteredArrayShopsList
        }
        else
            
        {
            ArrayBeforeSort = arrayShopsList
        }
        
        let arrayToSort = NSMutableArray()
        for i in 0..<ArrayBeforeSort.count
        {
            let dic = ArrayBeforeSort[i] as! NSDictionary
            arrayToSort.add(dic.value(forKey: "distance") as! NSNumber)
            
        }
        
        //var array = [5,3,4,6,8,2,9,1,7,10,11]
        let sortedArray = NSMutableArray(array: arrayToSort)
        var sortedAboveIndex = arrayToSort.count
        self.filteredArrayShopsList = ArrayBeforeSort
        var swaps = 0
        
        repeat {
            var lastSwapIndex = 0
            
            for i in 1..<sortedAboveIndex {
                if (sortedArray[i - 1] as! Float) > (sortedArray[i] as! Float) {
                    sortedArray.exchangeObject(at: i, withObjectAt: i-1)
                    self.filteredArrayShopsList.exchangeObject(at: i, withObjectAt:i-1)
                    lastSwapIndex = i
                    swaps += 1
                }
            }
            
            sortedAboveIndex = lastSwapIndex
            
        } while (sortedAboveIndex != 0)
        
        
        // [5, 3, 4, 6, 8, 2, 9, 1, 7, 10, 11]
        //print(arrayToSort)
        
        // [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        //print(sortedArray as Array)
        //print(self.filteredArrayShopsList)
        //print("Array is sorted in \(swaps) swaps.")
        //print(filteredArrayShopsList)
        self.issearchActive = true
        self.tblShopList.reloadData()
        
    }

    
    func sortByName(order:String)
    {
      
        
        let ArrayOfAlaf = NSMutableArray()
        let ArrayOfBa = NSMutableArray()
        let ArrayOfTa = NSMutableArray()
        let ArrayOfSa = NSMutableArray()
        let ArrayOfjīm = NSMutableArray()
        let ArrayOfHa = NSMutableArray()
        let ArrayOfkhā = NSMutableArray()
        let ArrayOfdāl = NSMutableArray()
        let ArrayOfZal = NSMutableArray()
        let ArrayOfrā = NSMutableArray()
        let ArrayOfzay = NSMutableArray()
        let ArrayOfSin = NSMutableArray()
        let ArrayOfShin = NSMutableArray()
        let ArrayOfSad = NSMutableArray()
        let ArrayOfDad = NSMutableArray()
        let ArrayOfToy = NSMutableArray()
        let ArrayOfZoy = NSMutableArray()
        let ArrayOfAyin = NSMutableArray()
        let ArrayOfGhyin = NSMutableArray()
        let ArrayOfFa = NSMutableArray()
        let ArrayOfQafSmall = NSMutableArray()
        let ArrayOfKafLarge = NSMutableArray()
        let ArrayOfLam = NSMutableArray()
        let ArrayOfMim = NSMutableArray()
        let ArrayOfNun = NSMutableArray()
        let ArrayOfhāAfterNun = NSMutableArray()
        let ArrayOfwaw = NSMutableArray()
        let ArrayOfYa = NSMutableArray()
        
        
        var ArrayBeforeSort = NSMutableArray()
        if  issearchActive == true
        {
            ArrayBeforeSort = self.filteredArrayShopsList
        }
        else
            
        {
            ArrayBeforeSort = arrayShopsList
        }
        self.filteredArrayShopsList = []
    for i in 0..<ArrayBeforeSort.count
        {
            let dic = ArrayBeforeSort[i] as! NSDictionary
            let shopeName = dic.value(forKey: "shopName") as! String
            if shopeName.hasPrefix("ا") {
                ArrayOfAlaf.add(dic)
            }
            else
                if shopeName.hasPrefix("ب") {
                    ArrayOfBa.add(dic)
              }
                else
                    if shopeName.hasPrefix("ت") {
                        ArrayOfTa.add(dic)
            }
                    else
                        if shopeName.hasPrefix("ث") {
                            ArrayOfSa.add(dic)
            }
                        else
                            if shopeName.hasPrefix("ج") {
                                ArrayOfjīm.add(dic)
            }
                            else
                                if shopeName.hasPrefix("ح") {
                                ArrayOfHa.add(dic)}
                                else
                                    if shopeName.hasPrefix("خ") {
                                    ArrayOfkhā.add(dic)}
            
                                    else
                                        if shopeName.hasPrefix("د") {  ArrayOfdāl.add(dic)
            }
                                        else
                                            if shopeName.hasPrefix("ذ") {  ArrayOfZal.add(dic)
            }
                                            else
                                                if shopeName.hasPrefix("ر") {  ArrayOfrā.add(dic)
            }
                                                else
                                                    if shopeName.hasPrefix("ز") {  ArrayOfzay.add(dic)
            }
                                                    else
                                                        if shopeName.hasPrefix("س") { ArrayOfSin.add(dic)
            }
                                                        else
                                                            if shopeName.hasPrefix("ش") {  ArrayOfShin.add(dic)
            }
                                                            else
                                                                if shopeName.hasPrefix("ص") {  ArrayOfSad.add(dic)
            }
                                                                else
                                                                    if shopeName.hasPrefix("ض") {   ArrayOfDad.add(dic)
            }
                                                                    else
                                                                        if shopeName.hasPrefix("ط") {  ArrayOfToy.add(dic)
            }
                                                                        else
                                                                            if shopeName.hasPrefix("ظ") {  ArrayOfZoy.add(dic)
            }
                                                                            else
                                                                                if shopeName.hasPrefix("ع") {  ArrayOfAyin.add(dic)
            }
                                                                                else
                                                                                    if shopeName.hasPrefix("غ") {  ArrayOfGhyin.add(dic)
            }
                                                                                    else
                                                                                        if shopeName.hasPrefix("ف") {  ArrayOfFa.add(dic)
            }
                                                                                        else
                                                                                            if shopeName.hasPrefix("ق") {  ArrayOfQafSmall.add(dic)
            }
                                                                                            else
                                                                                                if shopeName.hasPrefix("ك") {  ArrayOfKafLarge.add(dic)
            }
                                                                                                else
                                                                                                    if shopeName.hasPrefix("ل") {  ArrayOfLam.add(dic)
            }
                                                                                                    else
                                                                                                        if shopeName.hasPrefix("م") {  ArrayOfMim.add(dic)
            }
                                                                                                        else
                                                                                                            if shopeName.hasPrefix("ن") {  ArrayOfNun.add(dic)
            }
                                                                                                            else
                                                                                                                if shopeName.hasPrefix("ه") {  ArrayOfhāAfterNun.add(dic)
            }
                                                                                                                else
                                                                                                                    if shopeName.hasPrefix("و") {  ArrayOfwaw.add(dic)
            }
                                                                                                                    else
                                                                                                                        if shopeName.hasPrefix("ي") {  ArrayOfYa.add(dic)
            }
        
        }
       
        if order == "a"
        {
            for item in ArrayOfAlaf {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfBa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfTa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfSa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfjīm {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfHa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfkhā {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfdāl {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfZal {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfrā {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfzay {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfSin {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfShin {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfSad {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfDad {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfToy {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfZoy {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfAyin {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfGhyin {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfFa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfQafSmall {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfKafLarge {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfLam {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfMim {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfNun {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfwaw {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfhāAfterNun {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfYa {
                self.filteredArrayShopsList.add(item)
            }
        
            
            //print(filteredArrayShopsList)
            self.issearchActive = true
            self.tblShopList.reloadData()

            

        }
        else
        {
            
            
            for item in ArrayOfYa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfhāAfterNun {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfwaw {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfNun {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfMim {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfLam {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfKafLarge {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfQafSmall {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfFa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfGhyin {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfAyin {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfZoy {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfToy {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfDad {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfSad {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfShin {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfSin {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfzay {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfrā {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfZal {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfdāl {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfkhā {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfHa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfjīm {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfSa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfTa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfBa {
                self.filteredArrayShopsList.add(item)
            }
            for item in ArrayOfAlaf {
                self.filteredArrayShopsList.add(item)
            }
            
            //print(filteredArrayShopsList)
            self.issearchActive = true
            self.tblShopList.reloadData()
            

        }
       
        
     self.issearchActive = true
     self.tblShopList.reloadData()

    }
    @IBAction func btnSearch(sender:UIButton)
    {
      
        
        if isNameSearchButtonClick == false
        {
            self.txtSearchField.isSelected = true
            isNameSearchButtonClick = true
         let image = UIImage(named:"1493394596_Cross")
         self.btnMySearch.setImage(image, for:.normal)
        }
        else
        {
            isNameSearchButtonClick = false
            self.txtSearchField.resignFirstResponder()
            let image = UIImage(named:"1493393179_User_Interface-25")
            self.btnMySearch.setImage(image, for:.normal)
        }
         self.lblNavigationTitle.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         //self.tblserviceType.isHidden = true
        // SearchtypeSelectionView.isHidden = true
        self.tblCities.isHidden = true
         self.txtSearchField.resignFirstResponder()
        if (self.txtSearchField.text?.characters.count)! > 0
        {
        
        }
        else
        {
            self.issearchActive = false
            self.tblShopList.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        // create a cell for each table view row
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
       
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width - 8, height: 44)
        let headerView = UIView(frame:rect)
        headerView.backgroundColor = UIColor.white
       // return footerView
        let rectTitle = CGRect(x: 0, y: 0, width: tableView.frame.size.width - 8 , height: 44)
        let headerLabel = UILabel(frame: rectTitle)
        if ServiceBrandPlacetype == "s"
        {
        headerLabel.text = self.ArrayOfSections[0]as? String
        }
        else
        if ServiceBrandPlacetype == "b"
        {
        headerLabel.text = self.ArrayOfSections[1]as? String
        }else
        {
        headerLabel.text = self.ArrayOfSections[2]as? String
        }
        headerLabel.textAlignment = .right
        
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            headerLabel.font = UIFont(name:Constants.kShahidFont ,size:21)
        case .phone:
            print("iPhone and iPod touch style UI")
            headerLabel.font = UIFont(name:Constants.kShahidFont ,size:16)
        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }

        //headerLabel.textAlignment = NSTextAlignment.center;
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 0
        {
        return 44
        }
        else
        {
        return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 0
        {
            if ServiceBrandPlacetype == "s"
            {
        return self.aarayOFserviceTypeForNextController.count
            }
            else
                if ServiceBrandPlacetype == "b"
                {
                    return self.arrayCararnd.count
            }
            else
                {
             return self.arrayOFPlaceTypes.count
           
                }
            
        }
        else if tableView.tag == 1
        {
        return self.arrayCararnd.count
        }
        else
        if tableView.tag == 2
        
        {
            if issearchActive == true
            {
            return self.filteredArrayShopsList.count
            }
            else
            {
            return self.arrayShopsList.count
            }
        
        }
        else
        {
        return self.appDelegate.ArrayOfCities.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        
        if tableView.tag == 0
        {
           
            
        let cell:DropDownTableViewCell = self.tblserviceType.dequeueReusableCell(withIdentifier:"ServiceAndBrandCell") as! DropDownTableViewCell!
            if ServiceBrandPlacetype == "s"
            {
           let dic = self.aarayOFserviceTypeForNextController[indexPath.row] as! NSDictionary
            cell.lblServicetypeOrBrand.text = dic.value(forKey: "serviceTypeName")as? String
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont ,size:12)
                let isSelected = dic.value(forKey: "isSelected") as! Bool
                if isSelected == true
                {
                cell.checkBox.image = UIImage(named:"1x-check")
                }
                else
                {
                cell.checkBox.image = UIImage(named:"1x-box")
                }
            }
            else
                if ServiceBrandPlacetype == "b"
                {
                    let dic = self.arrayCararnd[indexPath.row] as! NSMutableDictionary
                    cell.lblServicetypeOrBrand.text = dic.value(forKey: "brandName")as? String
                    cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont ,size:12)
                    let isSelected = dic.value(forKey: "isSelected") as! Bool
                    if isSelected == true
                    {
                        cell.checkBox.image = UIImage(named:"1x-check")
                    }
                    else
                    {
                      cell.checkBox.image = UIImage(named:"1x-box")
                    }
                }
            else
                    if ServiceBrandPlacetype == "p"
                    {
                        let dic = self.arrayOFPlaceTypes[indexPath.row] as! NSMutableDictionary
                        cell.lblServicetypeOrBrand.text = dic.value(forKey: "name")as? String
                        
                        let isSelected = dic.value(forKey: "isSelected") as! Bool
                        if isSelected == true
                        {
                          cell.checkBox.image = UIImage(named:"1x-check")
                        }
                        else
                        {
                         cell.checkBox.image = UIImage(named:"1x-box")
                        }
                     }
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont ,size:21)
            case .phone:
                print("iPhone and iPod touch style UI")
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont ,size:12)
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }

            
            return cell
            
        }
            
        else
            if tableView.tag == 1
        {
            let cell:DropDownTableViewCell = self.tblCarbrand.dequeueReusableCell(withIdentifier:"ServiceAndBrandCell") as! DropDownTableViewCell!
            let dic = self.arrayCararnd[indexPath.row] as! NSMutableDictionary
            cell.lblServicetypeOrBrand.text = dic.value(forKey: "brandName")as? String
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont ,size:21)
            case .phone:
                print("iPhone and iPod touch style UI")
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont ,size:12)
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }

            return cell
        }
        else
                if tableView.tag == 2
            {
                let identifier = "shoplist"
                var cell: ShopListTableViewCell! = tblShopList.dequeueReusableCell(withIdentifier: identifier) as? ShopListTableViewCell
                if cell == nil
                {
                    tblShopList.register(UINib(nibName: "ShopListTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ShopListTableViewCell
                }
                var dic = NSDictionary()
                if issearchActive == true
                {
                dic = self.filteredArrayShopsList[indexPath.row]as! NSDictionary
                    
                    
                    
                }
                else
                {
                dic = self.arrayShopsList[indexPath.row]
                    as! NSDictionary
                }
                let str = dic.value(forKey: "serviceType") as? String
                if let isTrusted = dic.value(forKey: "isTrusted") as? NSNumber, isTrusted.boolValue {
                    cell.trustedImageView.isHidden = false;
                }
                else {
                    cell.trustedImageView.isHidden = true;
                }
                if let isDiscounted = dic.value(forKey: "isDiscounted") as? NSNumber, isDiscounted.boolValue {
                    cell.discountedImageView.isHidden = false;
                }
                else {
                    cell.discountedImageView.isHidden = true;
                }
                let array = str?.components(separatedBy: ",")
                cell.lblServiceType.text = (array?[0])!
                    cell.lblShopNameForLargeView.text = dic.value(forKey: "shopName") as? String
                cell.lblDetail.text = dic.value(forKey: "shopDescription") as? String
                let rating = dic.value(forKey:"shopRating") as! String
                let distance = dic.value(forKey: "distance") as! NSNumber
                let distancewithOneDecimal = String(format: "%.1f", Double(distance))
                
                cell.ratingViewForLargeView.rating = Double(rating)!
                
                
                let isShowDistance = UserDefaults.standard.value(forKey:"showDistance")as!String
                
                if isShowDistance == "yes"
                {
                    cell.lblDistanceForLargeView.text = "\(distancewithOneDecimal)km"
               // cell.lblDistanceForLargeView.isHidden = false
                }
                else
                {
                    cell.lblDistanceForLargeView.text = "-- km"
               // cell.lblDistanceForLargeView.isHidden = true
                }
              // cell.lblDistanceWidthConstraint.constant = self.getWidth(text:cell.lblDistanceForLargeView.text!)
                    cell.btnDetail.addTarget(self, action:#selector(HomeViewController.btnShopDetail), for:UIControlEvents.touchUpInside)
                
                cell.btnDetail.tag = indexPath.row
               
                if   let imageString = dic.value(forKey: "shopImage") as? String
                {
                    
                    
                    let imageFinalString = "\(Constants.kBaseUrlImages)\(dic.value(forKey: "ID")as! String)/thumbnails/\(imageString)"
                    let trimmedString = imageFinalString.trim()
                   
                   // let url = URL(string: "http://www.stackoverflow.com")
                    let urlStr : NSString = trimmedString.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
                    let searchURL : NSURL = NSURL(string: urlStr as String)!
                    // let url = NSURL(string:searchURL)
                    
                    
                    cell.imageViewLarge.sd_setImage(with:searchURL as URL   , placeholderImage:UIImage(named:"Icon-83.5"))
                    let size = CGSize(width:60, height:65)
                    cell.imageViewLarge.image = self.resizeImage(image:cell.imageViewLarge.image! , size: size)
                    
                    
                    
                }
                 cell.imageViewLarge.layer.cornerRadius = 05
                cell.imageViewLarge.layer.masksToBounds = true
                switch (deviceIdiom) {
                    
                case .pad:
                    print("iPad style UI")
                    cell.lblServiceType.font = UIFont(name:Constants.kShahidFont ,size:21)
                    cell.lblDetail.font = UIFont(name:Constants.kShahidFont ,size:21)
                    cell.lblShopNameForLargeView.font = UIFont(name:Constants.kShahidFont ,size:21)
                    cell.btnDetail.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
                    cell.lblDistanceForLargeView.font = UIFont(name:Constants.kShahidFont ,size:14)
                    

                case .phone:
                    cell.lblServiceType.font = UIFont(name:Constants.kShahidFont ,size:13)
                    cell.lblDetail.font = UIFont(name:Constants.kShahidFont ,size:11)
                    cell.lblShopNameForLargeView.font = UIFont(name:Constants.kShahidFont ,size:14)
                    cell.btnDetail.titleLabel?.font = UIFont(name:Constants.kShahidFont ,size:16)
                    cell.lblDistanceForLargeView.font = UIFont(name:Constants.kShahidFont ,size:12)

                case .tv:
                    print("tvOS style UI")
                default:
                    print("Unspecified UI idiom")
                }

                                // let font = UIFont(name: "HSN_Shahd_Regular", size: 12)
                
                if dic.value(forKey: "isCollapsed")as! Bool == true
                {
                    

                    let color = UIColor(red: 249/255, green: 203/255, blue: 181/255, alpha: 1.0)
                    cell.largeView.backgroundColor = color
                    cell.btnDetail.isHidden = false
                    cell.detailLabelHeightConstraint.constant = 50
                    cell.btnDetailHeight.constant = 32
                    cell.layoutIfNeeded();
                }
                else
                    
                {
                    cell.largeView.backgroundColor = UIColor.white
                    cell.btnDetail.isHidden = true
                    cell.detailLabelHeightConstraint.constant = 0
                    cell.btnDetailHeight.constant = 0
                    
                }

               return cell
        
        }
        else
        {
        
            let cell:CitySelectionTableViewCell = self.tblCities.dequeueReusableCell(withIdentifier:"citySelectionCell") as! CitySelectionTableViewCell!
            let dic = self.appDelegate.ArrayOfCities[indexPath.row] as! NSMutableDictionary
            cell.lblCityName.text = dic.value(forKey: "name")as? String
           
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                 cell.lblCityName.font = UIFont(name:Constants.kShahidFont ,size:21)
                
            case .phone:
                 cell.lblCityName.font = UIFont(name:Constants.kShahidFont ,size:16)
                
            case .tv:
                print("tvOS style UI")
            default:
                print("Unspecified UI idiom")
            }

            return cell
        }
        // set the text from the data model
        
        
   
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.tag == 2
        {
           
        }
        
    }
    func getWidth(text: String) -> CGFloat
    {
        let txtField = UILabel(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    @IBAction func searchThisAreaOnMap(sender:UIButton)
    {
        
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        isDefaultValueLoad = false
        isListPopulate = false
        self.isMapreferesh = true
//        let allAnnotations = self.map.annotations
//        self.map.removeAnnotations(allAnnotations)
         MBProgressHUD.showAdded(to: self.view, animated:true)
         self.btnSearchthisAreaOnMap.isHidden = true
        self.isFind = false
        self.arrayPoints = []
        self.getCurrentlocation(lat:self.latOnMapClick  , long: self.longOnMapClick)
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        
    }
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        
        self.btnSearchthisAreaOnMap.isHidden = true
        if gesture.state == .began
        {
        self.btnSearchthisAreaOnMap.isHidden = true
        }
        if gesture.state == .ended {
            self.btnSearchthisAreaOnMap.isHidden = false
            // self.addPinsOnMap(lat:coordinate.latitude , long: coordinate.longitude)
           
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
     func resizeImage(image: UIImage, size: CGSize) -> UIImage? {
        var returnImage: UIImage?
        
        var scaleFactor: CGFloat = 1.0
        var scaledWidth = size.width
        var scaledHeight = size.height
        var thumbnailPoint = CGPoint(x:0, y:0)
        
        if !image.size.equalTo(size) {
            let widthFactor = size.width / image.size.width
            let heightFactor = size.height / image.size.height
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            
            scaledWidth = image.size.width * scaleFactor
            scaledHeight = image.size.height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (size.height - scaledHeight) * 0.5
            } else if widthFactor < heightFactor {
                thumbnailPoint.x = (size.width - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        image.draw(in: thumbnailRect)
        returnImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    func heightDetailLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    @IBAction func btnSwitch(sender:UISwitch)
    {
       
        
        if sender.isOn == true
        {
            
    if sender.tag == 0
       {
        self.filterOnServiceModelAndName(serviceType: "", brand:"", indexPath:0)
       }
        else
        if sender.tag == 1
        {
            self.filterOnServiceModelAndName(serviceType: "", brand:"", indexPath:1)
        }
        else
        if sender.tag == 2
        {
           self.filterOnServiceModelAndName(serviceType: "", brand:"", indexPath:2)
        }
    }
        else
        {
        self.filterOnSwitchOffAndunselcetion()
        }
        
    }
    func filterOnSwitchOffAndunselcetion()
    {
       
         MBProgressHUD.showAdded(to: self.view, animated:true)
        self.filteredArrayShopsList = []
        var newArray = NSMutableArray()
        newArray = self.arrayShopsList
        var formateType :String!
        var searchString:String!

        if self.provideWarrantlySwitch.isOn
        {
            formateType = "provideWarranty CONTAINS[C] %@"
            searchString = "1"
            let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
            let serviceArray = (newArray as NSMutableArray).filtered(using: serviceSearchPredicate)
            filteredArrayShopsList = []
            //print ("array = \(serviceArray)")
            filteredArrayShopsList.addObjects(from:serviceArray)
            newArray = filteredArrayShopsList
            issearchActive = true;
        }
        if self.provideSpareParsSwitch.isOn
        {
            formateType = "provideReplaceParts CONTAINS[C] %@"
            searchString = "1"
            let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
            let serviceArray = (newArray as NSMutableArray).filtered(using: serviceSearchPredicate)
            filteredArrayShopsList = []
            //print ("array = \(serviceArray)")
            filteredArrayShopsList.addObjects(from:serviceArray)
            newArray = filteredArrayShopsList
            issearchActive = true;
        }
        if self.topRatingSwitch.isOn
        {
            filteredArrayShopsList = []
            for i in 0..<newArray.count
            {
                let dic = newArray [i] as! NSDictionary
                if dic.value(forKey: "shopRating") as! String == "5"
                {
                    filteredArrayShopsList.add(dic)
                }
                
            }
            //
            newArray = filteredArrayShopsList
            issearchActive = true;
        }
        for i in 0..<self.aarayOFserviceTypeForNextController.count
        {
            let dic = aarayOFserviceTypeForNextController[i] as! NSDictionary
            if dic.value(forKey: "isSelected") as! Bool == true
            {
            formateType = "serviceType CONTAINS[C] %@"
            searchString = dic.value(forKey: "serviceTypeName") as! String
            let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
            let serviceArray = (newArray as NSMutableArray).filtered(using: serviceSearchPredicate)
            filteredArrayShopsList = []
            //print ("array = \(serviceArray)")
            filteredArrayShopsList.addObjects(from:serviceArray)
            issearchActive = true;
            }
            
        }
        newArray = filteredArrayShopsList
        for i in 0..<self.arrayCararnd.count
        {
            
            let dic = arrayCararnd[i] as! NSDictionary
            if dic.value(forKey: "isSelected") as! Bool == true
            {
            formateType = "brands CONTAINS[C] %@"
            searchString = dic.value(forKey: "brandName") as! String
            let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
            let serviceArray = (newArray as NSMutableArray).filtered(using: serviceSearchPredicate)
            filteredArrayShopsList = []
            //print ("array = \(serviceArray)")
            filteredArrayShopsList.addObjects(from:serviceArray)
            issearchActive = true;
            }
            
        }
        newArray = filteredArrayShopsList
        for i in 0..<self.arrayOFPlaceTypes.count
        {
            
            let dic = arrayOFPlaceTypes[i] as! NSDictionary
            if dic.value(forKey: "isSelected") as! Bool == true
              {
            formateType = "shopType CONTAINS[C] %@"
            searchString = dic.value(forKey: "name") as! String
            let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
            let serviceArray = (newArray as NSMutableArray).filtered(using: serviceSearchPredicate)
            filteredArrayShopsList = []
            //print ("array = \(serviceArray)")
            filteredArrayShopsList.addObjects(from:serviceArray)
            issearchActive = true;
            }
            
        }
       
       
        if  self.filteredArrayShopsList.count > 20
        {
            self.lblShowTextforExpandMoreResult.text = ""
            "اختيار جيد! الذهاب نرى ما تبدو المحلات التجارية الخاصة بك الكمال."//
        }
        else
        {
         self.lblShowTextforExpandMoreResult.text = "يمكن زيادة النتائج بإزالة فلتر أو فلترين"
        }
        if  self.filteredArrayShopsList.count == 0
        {
            issearchActive = false;
            if isSelectedForFilter == true
            {
            self.lblShowFilterdResult.text = "\(self.filteredArrayShopsList.count) ورشة من أصل \(self.arrayShopsList.count) "
            }
            else
            {
            
            self.lblShowFilterdResult.text = "\(self.arrayShopsList.count) ورشة من أصل \(self.arrayShopsList.count) "
                self.lblShowTextforExpandMoreResult.text  = ""
            }
            
            // self.lblShowTextforExpandMoreResult.text = "اختيار جيد! الذهاب نرى ما تبدو المحلات التجارية الخاصة بك الكمال."
        }
        else
        {
            self.lblShowFilterdResult.text = "\(self.filteredArrayShopsList.count) ورشة من أصل  \(self.arrayShopsList.count) "
        }
         MBProgressHUD.hide(for:self.view, animated:true)
    }
    func filterOnServiceModelAndName (serviceType:String ,brand:String ,indexPath:Int)
    {
       
        var newArray = NSMutableArray()
        if isFirstClick == false
        {
            isFirstClick = true
            filteredArrayShopsList = []
            newArray = self.arrayShopsList
        }
        else
        {
            if filteredArrayShopsList.count == 0
            {
                newArray = self.arrayShopsList
            }
            else
            {
            newArray = filteredArrayShopsList
            }
            
        
        }
       if newArray.count > 0
       {
        
        
            var formateType :String!
            var searchString:String!
            //print(self.arrayShopsList[0] as! NSDictionary)
           // let shopObject = self.arrayShopsList[0] as! NSDictionary
        
            switch indexPath {
                
            case 0:
                formateType = "provideWarranty CONTAINS[C] %@"
                searchString = "1"
                let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
                let serviceArray = (newArray as NSMutableArray).filtered(using: serviceSearchPredicate)
                filteredArrayShopsList = []
                //print ("array = \(serviceArray)")
                filteredArrayShopsList.addObjects(from:serviceArray)
                newArray = filteredArrayShopsList
                issearchActive = true;
            case 1:
                formateType = "provideReplaceParts CONTAINS[C] %@"
                searchString = "1"
                let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
                let serviceArray = (newArray as NSMutableArray).filtered(using: serviceSearchPredicate)
                filteredArrayShopsList = []
                //print ("array = \(serviceArray)")
                filteredArrayShopsList.addObjects(from:serviceArray)
                newArray = filteredArrayShopsList
                issearchActive = true;
            
            case 2:
              filteredArrayShopsList = []
                for i in 0..<newArray.count
                {
                    
                let dic = newArray [i] as! NSDictionary
                    if ((dic.value(forKey: "shopRating") as! String) as NSString).floatValue >= 4.0
                    {
                    filteredArrayShopsList.add(dic)
                    }
                   
                }
                //
              newArray = filteredArrayShopsList
                issearchActive = true;
            default:
                formateType = "\(serviceType) CONTAINS[C] %@"
                searchString = brand
                let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
                let serviceArray = (newArray as NSMutableArray).filtered(using: serviceSearchPredicate)
                filteredArrayShopsList = []
                //print ("array = \(serviceArray)")
                filteredArrayShopsList.addObjects(from:serviceArray)
                issearchActive = true;
        }
            
            
        if  self.filteredArrayShopsList.count > 20
        {
            self.lblShowTextforExpandMoreResult.text = ""
            "اختيار جيد! الذهاب نرى ما تبدو المحلات التجارية الخاصة بك الكمال."//
        }
        else
        {
            self.lblShowTextforExpandMoreResult.text = "يمكن زيادة النتائج بإزالة فلتر أو فلترين"
        }
        self.lblShowFilterdResult.text = "\(self.filteredArrayShopsList.count)  ورشة من أصل  \(self.arrayShopsList.count) "
        self.lblShopsCount.text = " عدد الورش \(self.filteredArrayShopsList.count)"
        //self.tblShopList.reloadData()

        
        }
        
    }

    func btnCollapsed(sender:UIButton)
    {
       
        
       
        
        if issearchActive == true
        {
            let newArray =  NSMutableArray()
            for i in 0..<self.filteredArrayShopsList.count
            {
                let serviceObject = self.filteredArrayShopsList[i] as! NSDictionary
                let id = serviceObject.value(forKey: "ID") as! String
                let latitude = serviceObject.value(forKey: "latitude") as! String
                let longitude = serviceObject.value(forKey: "longitude") as! String
                let serviceType = serviceObject.value(forKey: "serviceType") as! String
                let shopDescription = serviceObject.value(forKey: "shopDescription") as? String
                let shopName = serviceObject.value(forKey: "shopName") as! String
                let shopRating = serviceObject.value(forKey: "shopRating") as! String
                let brand = serviceObject.value(forKey: "brands") as! String
                let shopImage = serviceObject.value(forKey: "shopImage") as? String
                let city = serviceObject.value(forKey: "city") as? String
                let provideReplaceParts = serviceObject.value(forKey: "provideReplaceParts") as? String
                let provideWarranty = serviceObject.value(forKey: "provideWarranty") as? String
                let shopType = serviceObject.value(forKey: "shopType") as? String
                _ = serviceObject.value(forKey: "isCollapsed") as! Bool
                let distance = serviceObject.value(forKey: "distance") as! NSNumber
                let newObject = NSMutableDictionary()
                if i == sender.tag
                {
                    
                    newObject.setValue(distance, forKey:"distance")
                    newObject.setValue(city, forKey:"city")
                    newObject.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                    newObject.setValue(provideWarranty, forKey:"provideWarranty")
                    newObject.setValue(shopType, forKey:"shopType")
                    newObject.setValue(shopRating, forKey:"shopRating")
                    
                    newObject.setValue(id, forKey:"ID")
                    newObject.setValue(latitude, forKey:"latitude")
                    newObject.setValue(longitude, forKey:"longitude")
                    newObject.setValue(serviceType, forKey:"serviceType")
                    newObject.setValue(shopDescription, forKey:"shopDescription")
                    newObject.setValue(shopName, forKey:"shopName")
                    
                    newObject.setValue(brand, forKey:"brands")
                    let isTrusted = serviceObject.value(forKey: "isTrusted") as! NSNumber
                    let isDiscounted = serviceObject.value(forKey: "isDiscounted") as! NSNumber
                    newObject.setValue(isTrusted, forKey:"isTrusted")
                    newObject.setValue(isDiscounted, forKey:"isDiscounted")

                    newObject.setValue(shopImage, forKey:"shopImage")
                    if serviceObject.value(forKey: "isCollapsed") as! Bool == true
                    {
                        newObject.setValue(false, forKey:"isCollapsed")
                    }
                    else
                        
                    {
                        newObject.setValue(true, forKey:"isCollapsed")
                    }
                }
                else
                {
                    
                    newObject.setValue(distance, forKey:"distance")
                    newObject.setValue(id, forKey:"ID")
                    newObject.setValue(latitude, forKey:"latitude")
                    newObject.setValue(longitude, forKey:"longitude")
                    newObject.setValue(serviceType, forKey:"serviceType")
                    newObject.setValue(shopDescription, forKey:"shopDescription")
                    newObject.setValue(shopName, forKey:"shopName")
                    newObject.setValue(shopRating, forKey:"shopRating")
                    newObject.setValue(brand, forKey:"brands")
                    newObject.setValue(false, forKey:"isCollapsed")
                    newObject.setValue(shopImage, forKey:"shopImage")
                    newObject.setValue(city, forKey:"city")
                    newObject.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                    newObject.setValue(provideWarranty, forKey:"provideWarranty")
                    newObject.setValue(shopType, forKey:"shopType")
                    let isTrusted = serviceObject.value(forKey: "isTrusted") as! NSNumber
                    let isDiscounted = serviceObject.value(forKey: "isDiscounted") as! NSNumber
                    newObject.setValue(isTrusted, forKey:"isTrusted")
                    newObject.setValue(isDiscounted, forKey:"isDiscounted")

                    
                }
                
                newArray.add(newObject)
            }
            self.filteredArrayShopsList = []
            self.filteredArrayShopsList = newArray
            //let nindexPath = IndexPath(row: sender.tag, section: 0)
            //self.tblShopList.reloadRows(at:[nindexPath] , with:.automatic)
            self.tblShopList.reloadData()

        }
        else
        {
            let newArray =  NSMutableArray()
        for i in 0..<self.arrayShopsList.count
        {
            let serviceObject = self.arrayShopsList[i] as! NSDictionary
            let id = serviceObject.value(forKey: "ID") as! String
            let latitude = serviceObject.value(forKey: "latitude") as! String
            let longitude = serviceObject.value(forKey: "longitude") as! String
            let serviceType = serviceObject.value(forKey: "serviceType") as! String
            let shopDescription = serviceObject.value(forKey: "shopDescription") as? String
            let shopName = serviceObject.value(forKey: "shopName") as! String
            let shopRating = serviceObject.value(forKey: "shopRating") as! String
            let brand = serviceObject.value(forKey: "brands") as! String
            let shopImage = serviceObject.value(forKey: "shopImage") as? String
            let city = serviceObject.value(forKey: "city") as? String
            let provideReplaceParts = serviceObject.value(forKey: "provideReplaceParts") as? String
            let provideWarranty = serviceObject.value(forKey: "provideWarranty") as? String
            let shopType = serviceObject.value(forKey: "shopType") as? String
            _ = serviceObject.value(forKey: "isCollapsed") as! Bool
            let distance = serviceObject.value(forKey: "distance") as! NSNumber
             let newObject = NSMutableDictionary()
            if i == sender.tag
            {
                
                newObject.setValue(distance, forKey:"distance")
                newObject.setValue(city, forKey:"city")
                newObject.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                newObject.setValue(provideWarranty, forKey:"provideWarranty")
                newObject.setValue(shopType, forKey:"shopType")
                newObject.setValue(shopRating, forKey:"shopRating")
                
                newObject.setValue(id, forKey:"ID")
                newObject.setValue(latitude, forKey:"latitude")
                newObject.setValue(longitude, forKey:"longitude")
                newObject.setValue(serviceType, forKey:"serviceType")
                newObject.setValue(shopDescription, forKey:"shopDescription")
                newObject.setValue(shopName, forKey:"shopName")
                let isTrusted = serviceObject.value(forKey: "isTrusted") as! NSNumber
                let isDiscounted = serviceObject.value(forKey: "isDiscounted") as! NSNumber
                newObject.setValue(isTrusted, forKey:"isTrusted")
                newObject.setValue(isDiscounted, forKey:"isDiscounted")

                newObject.setValue(brand, forKey:"brands")
                
                newObject.setValue(shopImage, forKey:"shopImage")
                if serviceObject.value(forKey: "isCollapsed") as! Bool == true
                {
                    newObject.setValue(false, forKey:"isCollapsed")
                }
                else
                
                {
                 newObject.setValue(true, forKey:"isCollapsed")
                }
            }
            else
            {
                
                newObject.setValue(distance, forKey:"distance")
                newObject.setValue(id, forKey:"ID")
                newObject.setValue(latitude, forKey:"latitude")
                newObject.setValue(longitude, forKey:"longitude")
                newObject.setValue(serviceType, forKey:"serviceType")
                newObject.setValue(shopDescription, forKey:"shopDescription")
                newObject.setValue(shopName, forKey:"shopName")
                newObject.setValue(shopRating, forKey:"shopRating")
                newObject.setValue(brand, forKey:"brands")
                newObject.setValue(false, forKey:"isCollapsed")
                newObject.setValue(shopImage, forKey:"shopImage")
                newObject.setValue(city, forKey:"city")
                newObject.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                newObject.setValue(provideWarranty, forKey:"provideWarranty")
                newObject.setValue(shopType, forKey:"shopType")
                let isTrusted = serviceObject.value(forKey: "isTrusted") as! NSNumber
                let isDiscounted = serviceObject.value(forKey: "isDiscounted") as! NSNumber
                newObject.setValue(isTrusted, forKey:"isTrusted")
                newObject.setValue(isDiscounted, forKey:"isDiscounted")

                
            }

        newArray.add(newObject)
        }
        self.arrayShopsList = []
        self.arrayShopsList = newArray
        //let nindexPath = IndexPath(row: sender.tag, section: 0)
        //self.tblShopList.reloadRows(at:[nindexPath] , with:.automatic)
        self.tblShopList.reloadData()
        }
        
    }
    func btnShopDetail(sender:UIButton)
    {
        var dic:NSDictionary!
        if self.issearchActive == true
        {
        dic = self.filteredArrayShopsList[sender.tag]as! NSDictionary
        }
        else
        {
        dic = self.arrayShopsList[sender.tag]as! NSDictionary
        }
        let shopDetailVc = self.storyboard?.instantiateViewController(withIdentifier: "shopDetailVc") as! ShopDetailViewController
       
        shopDetailVc.shopId = dic.value(forKey: "ID") as! String
        lastID=dic.value(forKey: "ID") as? String
        //shopDetailVc.destinationLat = Double(dic.value(forKey: "latitude")as! String)!
       // shopDetailVc.destinationLong = Double(dic.value(forKey: "longitude")as! String)!
        self.navigationController?.pushViewController(shopDetailVc, animated: true)


    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        self.btnScrollListAtTop.isHidden = true
        if scrollView == self.tblShopList {
            
            if yOffset <= 0 {
               
            }
            else
            
            {
                self.btnScrollListAtTop.isHidden = false
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          var isSelect = false
        self.tblCities.isHidden = true
        if tableView.tag == 0
        {
        //
           
          // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
            if ServiceBrandPlacetype == "s"
            {
               
                let dic = self.aarayOFserviceTypeForNextController[indexPath.row] as! NSDictionary
                let isSelected = dic.value(forKey: "isSelected") as! Bool
                let id = dic.value(forKey: "ID") as! String
                let dateAdded = dic.value(forKey: "dateAdded") as! String
                let serviceTypeName = dic.value(forKey: "serviceTypeName") as! String
                
                let newObject = NSMutableDictionary()
               if isSelected == false
                {
                    isSelect = true
                    isSelectedForFilter = true
                    newObject.setValue(id, forKey:"ID")
                    newObject.setValue(dateAdded, forKey:"dateAdded")
                    newObject.setValue(serviceTypeName, forKey:"serviceTypeName")
                    newObject.setValue(true, forKey:"isSelected")
                    self.arrayOfServicesSelected.add(newObject)
                    self.filterOnServiceModelAndName(serviceType:"serviceType" , brand:dic.value(forKey: "serviceTypeName") as! String, indexPath:8)
                    
                }
                else
                {
                     isSelectedForFilter = false
                    isSelect = false
                    newObject.setValue(id, forKey:"ID")
                    newObject.setValue(dateAdded, forKey:"dateAdded")
                    newObject.setValue(serviceTypeName, forKey:"serviceTypeName")
                    newObject.setValue(false, forKey:"isSelected")
                   
                    

                }
                
                self.aarayOFserviceTypeForNextController.replaceObject(at:indexPath.row, with: newObject)
                self.tblserviceType.reloadSections(IndexSet(integer:indexPath.section), with:.automatic)
                if isSelect == false
                {
                self.filterOnSwitchOffAndunselcetion()
                }
            
            }
            else
                if ServiceBrandPlacetype == "b"
            {
                
                let dic = self.arrayCararnd[indexPath.row] as! NSDictionary
                let isSelected = dic.value(forKey: "isSelected") as! Bool
                let id = dic.value(forKey: "ID") as! String
                let dateAdded = dic.value(forKey: "dateAdded") as! String
                let serviceTypeName = dic.value(forKey: "brandName") as! String
                
                let newObject = NSMutableDictionary()
                if isSelected == false
                {
                    isSelect = true
                    isSelectedForFilter = true
                    newObject.setValue(id, forKey:"ID")
                    newObject.setValue(dateAdded, forKey:"dateAdded")
                    newObject.setValue(serviceTypeName, forKey:"brandName")
                    newObject.setValue(true, forKey:"isSelected")
                    self.arrayOfBrandSelected.add(newObject)
                     self.filterOnServiceModelAndName(serviceType:"brands" , brand:dic.value(forKey: "brandName") as! String, indexPath:8)
                    
                }
                else
                {
                    isSelectedForFilter = false
                    isSelect = false
                    newObject.setValue(id, forKey:"ID")
                    newObject.setValue(dateAdded, forKey:"dateAdded")
                    newObject.setValue(serviceTypeName, forKey:"brandName")
                    newObject.setValue(false, forKey:"isSelected")
                   
                   
                    
                }
                self.arrayCararnd.replaceObject(at:indexPath.row, with: newObject)
                self.tblserviceType.reloadSections(IndexSet(integer:indexPath.section), with:.automatic)
                if isSelect == false
                {
                    self.filterOnSwitchOffAndunselcetion()
                }
               
            }
            else if ServiceBrandPlacetype == "p"
                {
                    
                    let newArray =  NSMutableArray()
                    for i in 0..<self.arrayOFPlaceTypes.count
                    {
                    let dic = self.arrayOFPlaceTypes[i] as! NSDictionary
                    let isSelected = dic.value(forKey: "isSelected") as! Bool
                    let id = dic.value(forKey: "ID") as! String
                    let dateAdded = dic.value(forKey: "dateAdded") as! String
                    let serviceTypeName = dic.value(forKey: "name") as! String
                    
                    let newObject = NSMutableDictionary()
                        if i == indexPath.row
                        {
                            if isSelected == false
                            {
                                isSelectedForFilter = true
                                isSelect = true
                                newObject.setValue(id, forKey:"ID")
                                newObject.setValue(dateAdded, forKey:"dateAdded")
                                newObject.setValue(serviceTypeName, forKey:"name")
                                newObject.setValue(true, forKey:"isSelected")
                                
                            }
                            else
                            {
                                isSelectedForFilter = false
                                isSelect = false
                                newObject.setValue(id, forKey:"ID")
                                newObject.setValue(dateAdded, forKey:"dateAdded")
                                newObject.setValue(serviceTypeName, forKey:"name")
                                newObject.setValue(false, forKey:"isSelected")
                                
                                
                            }

                        }
                        else
                        {
                            newObject.setValue(id, forKey:"ID")
                            newObject.setValue(dateAdded, forKey:"dateAdded")
                            newObject.setValue(serviceTypeName, forKey:"name")
                            newObject.setValue(false, forKey:"isSelected")
                           
                            
                        }
                        newArray.add(newObject)
                        
                    }
                    self.arrayOFPlaceTypes = []
                    self.arrayOFPlaceTypes = newArray
                    self.tblserviceType.reloadSections(IndexSet(integer:indexPath.section), with:.automatic)
//                    if isSelect == false
//                    {
                        self.filterOnSwitchOffAndunselcetion()
                    //}
                  
            }
           
          
        }
        else if tableView.tag == 2
        {
           
            if issearchActive == true
            {
                let newArray =  NSMutableArray()
                for i in 0..<self.filteredArrayShopsList.count
                {
                    let serviceObject = self.filteredArrayShopsList[i] as! NSDictionary
                    let id = serviceObject.value(forKey: "ID") as! String
                    let latitude = serviceObject.value(forKey: "latitude") as! String
                    let longitude = serviceObject.value(forKey: "longitude") as! String
                    let serviceType = serviceObject.value(forKey: "serviceType") as! String
                    let shopDescription = serviceObject.value(forKey: "shopDescription") as? String
                    let shopName = serviceObject.value(forKey: "shopName") as! String
                    let shopRating = serviceObject.value(forKey: "shopRating") as! String
                    let brand = serviceObject.value(forKey: "brands") as! String
                    let shopImage = serviceObject.value(forKey: "shopImage") as? String
                    let city = serviceObject.value(forKey: "city") as? String
                    let provideReplaceParts = serviceObject.value(forKey: "provideReplaceParts") as? String
                    let provideWarranty = serviceObject.value(forKey: "provideWarranty") as? String
                    let shopType = serviceObject.value(forKey: "shopType") as? String
                    _ = serviceObject.value(forKey: "isCollapsed") as! Bool
                    let distance = serviceObject.value(forKey: "distance") as! NSNumber
                    let newObject = NSMutableDictionary()
                    if i == indexPath.row
                    {
                        
                        newObject.setValue(distance, forKey:"distance")
                        newObject.setValue(city, forKey:"city")
                        newObject.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                        newObject.setValue(provideWarranty, forKey:"provideWarranty")
                        newObject.setValue(shopType, forKey:"shopType")
                        newObject.setValue(shopRating, forKey:"shopRating")
                        
                        newObject.setValue(id, forKey:"ID")
                        newObject.setValue(latitude, forKey:"latitude")
                        newObject.setValue(longitude, forKey:"longitude")
                        newObject.setValue(serviceType, forKey:"serviceType")
                        newObject.setValue(shopDescription, forKey:"shopDescription")
                        newObject.setValue(shopName, forKey:"shopName")
                        
                        newObject.setValue(brand, forKey:"brands")
                        let isTrusted = serviceObject.value(forKey: "isTrusted") as! NSNumber
                        let isDiscounted = serviceObject.value(forKey: "isDiscounted") as! NSNumber
                        newObject.setValue(isTrusted, forKey:"isTrusted")
                        newObject.setValue(isDiscounted, forKey:"isDiscounted")

                        newObject.setValue(shopImage, forKey:"shopImage")
                        if serviceObject.value(forKey: "isCollapsed") as! Bool == true
                        {
                            newObject.setValue(false, forKey:"isCollapsed")
                        }
                        else
                            
                        {
                            newObject.setValue(true, forKey:"isCollapsed")
                        }
                    }
                    else
                    {
                        
                        newObject.setValue(distance, forKey:"distance")
                        newObject.setValue(id, forKey:"ID")
                        newObject.setValue(latitude, forKey:"latitude")
                        newObject.setValue(longitude, forKey:"longitude")
                        newObject.setValue(serviceType, forKey:"serviceType")
                        newObject.setValue(shopDescription, forKey:"shopDescription")
                        newObject.setValue(shopName, forKey:"shopName")
                        newObject.setValue(shopRating, forKey:"shopRating")
                        newObject.setValue(brand, forKey:"brands")
                        newObject.setValue(false, forKey:"isCollapsed")
                        newObject.setValue(shopImage, forKey:"shopImage")
                        newObject.setValue(city, forKey:"city")
                        newObject.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                        newObject.setValue(provideWarranty, forKey:"provideWarranty")
                        newObject.setValue(shopType, forKey:"shopType")
                        let isTrusted = serviceObject.value(forKey: "isTrusted") as! NSNumber
                        let isDiscounted = serviceObject.value(forKey: "isDiscounted") as! NSNumber
                        newObject.setValue(isTrusted, forKey:"isTrusted")
                        newObject.setValue(isDiscounted, forKey:"isDiscounted")

                    }
                    
                    newArray.add(newObject)
                }
                self.filteredArrayShopsList = []
                self.filteredArrayShopsList = newArray
                DispatchQueue.main.async {
//                    let inPAth = IndexPath(row:self.previousIndexPathRow, section:0)
//                    self.tblShopList.reloadRows(at:[inPAth], with:.top)
                    self.tblShopList.reloadData()
                    
                }
            }
            else
            {
                let newArray =  NSMutableArray()
                for i in 0..<self.arrayShopsList.count
                {
                    let serviceObject = self.arrayShopsList[i] as! NSDictionary
                    let id = serviceObject.value(forKey: "ID") as! String
                    let latitude = serviceObject.value(forKey: "latitude") as! String
                    let longitude = serviceObject.value(forKey: "longitude") as! String
                    let serviceType = serviceObject.value(forKey: "serviceType") as! String
                    let shopDescription = serviceObject.value(forKey: "shopDescription") as?String
                    let shopName = serviceObject.value(forKey: "shopName") as! String
                    let shopRating = serviceObject.value(forKey: "shopRating") as! String
                    let brand = serviceObject.value(forKey: "brands") as! String
                    let shopImage = serviceObject.value(forKey: "shopImage") as? String
                    let city = serviceObject.value(forKey: "city") as? String
                    let provideReplaceParts = serviceObject.value(forKey: "provideReplaceParts") as? String
                    let provideWarranty = serviceObject.value(forKey: "provideWarranty") as? String
                    let shopType = serviceObject.value(forKey: "shopType") as? String
                    _ = serviceObject.value(forKey: "isCollapsed") as! Bool
                    let distance = serviceObject.value(forKey: "distance") as! NSNumber
                    let newObject = NSMutableDictionary()
                    if i == indexPath.row
                    {
                        
                        newObject.setValue(distance, forKey:"distance")
                        newObject.setValue(city, forKey:"city")
                        newObject.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                        newObject.setValue(provideWarranty, forKey:"provideWarranty")
                        newObject.setValue(shopType, forKey:"shopType")
                        newObject.setValue(shopRating, forKey:"shopRating")
                        
                        newObject.setValue(id, forKey:"ID")
                        newObject.setValue(latitude, forKey:"latitude")
                        newObject.setValue(longitude, forKey:"longitude")
                        newObject.setValue(serviceType, forKey:"serviceType")
                        newObject.setValue(shopDescription, forKey:"shopDescription")
                        newObject.setValue(shopName, forKey:"shopName")
                        
                        newObject.setValue(brand, forKey:"brands")
                        let isTrusted = serviceObject.value(forKey: "isTrusted") as! NSNumber
                        let isDiscounted = serviceObject.value(forKey: "isDiscounted") as! NSNumber
                        newObject.setValue(isTrusted, forKey:"isTrusted")
                        newObject.setValue(isDiscounted, forKey:"isDiscounted")

                        newObject.setValue(shopImage, forKey:"shopImage")
                        if serviceObject.value(forKey: "isCollapsed") as! Bool == true
                        {
                            newObject.setValue(false, forKey:"isCollapsed")
                        }
                        else
                            
                        {
                            newObject.setValue(true, forKey:"isCollapsed")
                        }
                    }
                    else
                    {
                        
                        newObject.setValue(distance, forKey:"distance")
                        newObject.setValue(id, forKey:"ID")
                        newObject.setValue(latitude, forKey:"latitude")
                        newObject.setValue(longitude, forKey:"longitude")
                        newObject.setValue(serviceType, forKey:"serviceType")
                        newObject.setValue(shopDescription, forKey:"shopDescription")
                        newObject.setValue(shopName, forKey:"shopName")
                        newObject.setValue(shopRating, forKey:"shopRating")
                        newObject.setValue(brand, forKey:"brands")
                        newObject.setValue(false, forKey:"isCollapsed")
                        newObject.setValue(shopImage, forKey:"shopImage")
                        newObject.setValue(city, forKey:"city")
                        newObject.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                        newObject.setValue(provideWarranty, forKey:"provideWarranty")
                        newObject.setValue(shopType, forKey:"shopType")
                        let isTrusted = serviceObject.value(forKey: "isTrusted") as! NSNumber
                        let isDiscounted = serviceObject.value(forKey: "isDiscounted") as! NSNumber
                        newObject.setValue(isTrusted, forKey:"isTrusted")
                        newObject.setValue(isDiscounted, forKey:"isDiscounted")

                        
                    }
                    newArray.add(newObject)
                }
                self.arrayShopsList = []
                self.arrayShopsList = newArray
                //self.tblShopList.beginUpdates()
                //self.tblShopList.endUpdates()
                DispatchQueue.main.async {
//                    let inPAth = IndexPath(row:self.previousIndexPathRow, section:0)
//                    self.tblShopList.reloadRows(at:[inPAth], with:.top)
                    
                    self.tblShopList.reloadData()
                }
                

            }
            

        
        }
        else
        if tableView.tag == 3
        {
            self.isMapreferesh = false
            let dic = self.appDelegate.ArrayOfCities[indexPath.row] as! NSDictionary
            let id = dic.value(forKey: "ID") as! String
            let   latFrom = Double(UserDefaults.standard.value(forKey:"lat") as! NSNumber)
            let    longFrom = Double(UserDefaults.standard.value(forKey:"long") as! NSNumber)
           // self.arrayShopsList = []
            self.lblCurrentLocation.text = dic.value(forKey: "name") as? String
            UserDefaults.standard.set(id, forKey:"selectedCityID")
            UserDefaults.standard.set(dic.value(forKey: "name") as! String, forKey:"selectedCityName")
                self.issearchActive = false
            if dic.value(forKey: "name") as! String == "الرياض"
            {
              isDefaultValueLoad = true
            }
            self.getShopsListCityWise(cityID: id ,lat:latFrom,long:longFrom,moapOrList: "l")
            self.tblCities.isHidden = true
        }

       
        print("You tapped cell number \(indexPath.row).")
    }
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    func addPinsOnMap(lat:Double! ,long:Double! ,first:Int! ,dic:NSDictionary!)
    {
      
         var latFrom:Double!
         var longFrom:Double!
        
        
            latFrom = lat
            longFrom = long
       

        
            for i in 0..<self.arrayPoints.count
            {
                let dic = self.arrayPoints[i] as! NSDictionary
        
             self.map.delegate = self
//        if first != 0
//        {
            let latitude = Double(dic.value(forKey: "latitude") as! String )
            let longitude = Double(dic.value(forKey: "longitude") as! String)
            let latLong = [latitude ,longitude]
             self.coordinates.add(latLong)
            
          
                let toLat = CLLocationDegrees(latitude!)
                let toLong = CLLocationDegrees(longitude!)
                
                
                let coordinate₀ = CLLocation(latitude: lat, longitude:long)
                let coordinate₁ = CLLocation(latitude:toLat, longitude:toLong)
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                var distanceInKm = Float(distanceInMeters/1000)
                distanceInKm = round(distanceInKm)
                let isShowDistance = UserDefaults.standard.value(forKey:"showDistance")as!String
                if isShowDistance == "yes"
                {
                if distanceInKm <= 10
                {
                    
                    let coordinates = CLLocationCoordinate2D(latitude: toLat, longitude: toLong)
                    let marker = GMSMarker(position: coordinates)
                    marker.map = self.map
                    marker.icon = UIImage(named: "1x-pin-map")
                    marker.infoWindowAnchor = CGPoint(x:-4, y: 3)
                    marker.accessibilityLabel = "\(i)"
                    
                    
                    
                    

                
            }
                }
                else
                
                {
                    
                    
                    
                    let coordinates = CLLocationCoordinate2D(latitude: toLat, longitude: toLong)
                    let marker = GMSMarker(position: coordinates)
                    marker.map = self.map
                    marker.icon = UIImage(named: "1x-pin-map")
                    marker.infoWindowAnchor = CGPoint(x:-4, y:3)
                    marker.accessibilityLabel = "\(i)"

                    
                    
                }
        
        }

        self.btnMyExplorer.isEnabled = true
        MBProgressHUD.hide(for:self.view, animated:true)
        
        

    }
    
    
    
    func addRadiusCircle(location: CLLocation){
        self.map.delegate = self
        let circle = MKCircle(center: location.coordinate, radius:5000)
       // self.map.add(circle)
        MBProgressHUD.hide(for:self.view, animated:true)
    }
    // For All shops
    func getShopsListForMapCityWise(cityID:String,lat:Double!,long:Double ,moapOrList:String)
    {
        
        let  lati = Double(UserDefaults.standard.value(forKey: "lat")as! NSNumber)
        let   longi = Double(UserDefaults.standard.value(forKey: "long") as! NSNumber)
        self.ShopingListView.isHidden = true
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
            self.arrayPoints = []
            var parameter = [String:Any]()
            parameter = ["cityID":cityID]
            
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.getShopListByCityWise, method: .post, parameters:parameter , headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        self.arrayPoints = []
                        //print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let shopsList = serviceTypeObject?.value(forKey:"shopsList") as! NSArray
                        var isShopExistInKm = false
                        for i in 0..<shopsList.count {
                            let  dic =  NSMutableDictionary()
                            
                            let serviceObject = shopsList[i] as! NSDictionary
                            //print(serviceObject)
                            let id = serviceObject.value(forKey: "ID") as! String
                            let latitude = serviceObject.value(forKey: "latitude") as! String
                            let longitude = serviceObject.value(forKey: "longitude") as! String
                            let serviceType = serviceObject.value(forKey: "serviceType") as? String
                            let shopDescription = serviceObject.value(forKey: "shopDescription") as? String
                            let shopName = serviceObject.value(forKey: "shopName") as? String
                            let shopRating = serviceObject.value(forKey: "shopRating") as! String
                            let brand = serviceObject.value(forKey: "brands") as? String
                            let shopImage = serviceObject.value(forKey: "shopImage") as? String
                            let city = serviceObject.value(forKey: "city") as? String
                            let provideReplaceParts = serviceObject.value(forKey: "provideReplaceParts") as? String
                            let provideWarranty = serviceObject.value(forKey: "provideWarranty") as? String
                            let shopType = serviceObject.value(forKey: "shopType") as? String
                            
                            let toLat = CLLocationDegrees(latitude)
                            let toLong = CLLocationDegrees(longitude)
                            let isTrusted = NSNumber(value: (serviceObject.value(forKey: "isTrusted") as! NSString).boolValue)
                            let isDiscounted = NSNumber(value: (serviceObject.value(forKey: "isDiscounted") as! NSString).boolValue)
                            
                            let coordinate₀ = CLLocation(latitude: lati, longitude:longi)
                            let coordinate₁ = CLLocation(latitude:toLat!, longitude:toLong!)
                            
                            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                            var distanceInKm = Float(distanceInMeters/1000)
                           
                            
                            dic.setValue(distanceInKm, forKey:"distance")
                            dic.setValue(shopType, forKey:"shopType")
                            dic.setValue(provideWarranty, forKey:"provideWarranty")
                            dic.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                            dic.setValue(shopRating, forKey:"shopRating")
                            dic.setValue(city, forKey:"city")
                            dic.setValue(id, forKey:"ID")
                            dic.setValue(latitude, forKey:"latitude")
                            dic.setValue(longitude, forKey:"longitude")
                            dic.setValue(serviceType, forKey:"serviceType")
                            dic.setValue(shopDescription, forKey:"shopDescription")
                            dic.setValue(shopName, forKey:"shopName")
                            dic.setValue(brand, forKey:"brands")
                            dic.setValue(false, forKey:"isCollapsed")
                            dic.setValue(shopImage, forKey:"shopImage")
                            dic.setValue(isTrusted, forKey: "isTrusted");
                            dic.setValue(isDiscounted, forKey: "isDiscounted");
                            self.arrayPoints.add(dic)
                            
                        }
                        let arrayToSort = NSMutableArray()
                        
                        
                        for i in 0..<self.arrayPoints.count
                        {
                            let dic = self.arrayPoints[i] as! NSDictionary
                            arrayToSort.add(dic.value(forKey: "distance") as! NSNumber)
                            
                        }
                        
                        //var array = [5,3,4,6,8,2,9,1,7,10,11]
                        let sortedArray = NSMutableArray(array: arrayToSort)
                        var sortedAboveIndex = arrayToSort.count
                        var swaps = 0
                        if sortedAboveIndex != 0
                        {
                            repeat {
                                var lastSwapIndex = 0
                                
                                for i in 1..<sortedAboveIndex {
                                    if (sortedArray[i - 1] as! Float) > (sortedArray[i] as! Float) {
                                        sortedArray.exchangeObject(at: i, withObjectAt: i-1)
                                        self.arrayPoints.exchangeObject(at: i, withObjectAt:i-1)
                                        lastSwapIndex = i
                                        swaps += 1
                                    }
                                }
                                
                                sortedAboveIndex = lastSwapIndex
                                
                            } while (sortedAboveIndex != 0)
                            
                        }
                        //print(self.arrayPoints)
                        
                        
                            DispatchQueue.main.async{
                             self.addPinsOnMap(lat:lat,long: long ,first:0,dic:nil)
                        }
                        
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
            self.present(alert, animated: true, completion: nil)}
        
        
    }

    
    func getShopsListCityWise(cityID:String,lat:Double!,long:Double ,moapOrList:String)
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        self.arrayShopsList = []
        var parameter = [String:Any]()
        parameter = ["cityID":cityID]

        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.getShopListByCityWise, method: .post, parameters:parameter , headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    self.arrayShopsList = []
                    //print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let shopsList = serviceTypeObject?.value(forKey:"shopsList") as! NSArray
                    var isShopExistInKm = false
                    for i in 0..<shopsList.count {
                        let  dic =  NSMutableDictionary()
                        
                        let serviceObject = shopsList[i] as! NSDictionary
                        //print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let latitude = serviceObject.value(forKey: "latitude") as! String
                        let longitude = serviceObject.value(forKey: "longitude") as! String
                        let serviceType = serviceObject.value(forKey: "serviceType") as? String
                        let shopDescription = serviceObject.value(forKey: "shopDescription") as? String
                        let shopName = serviceObject.value(forKey: "shopName") as! String
                        let shopRating = serviceObject.value(forKey: "shopRating") as! String
                        let brand = serviceObject.value(forKey: "brands") as? String
                        let shopImage = serviceObject.value(forKey: "shopImage") as? String
                        let city = serviceObject.value(forKey: "city") as? String
                        let provideReplaceParts = serviceObject.value(forKey: "provideReplaceParts") as? String
                        let provideWarranty = serviceObject.value(forKey: "provideWarranty") as? String
                        let shopType = serviceObject.value(forKey: "shopType") as? String
                        
                        let toLat = CLLocationDegrees(latitude)
                        let toLong = CLLocationDegrees(longitude)
                        
                        
                        let coordinate₀ = CLLocation(latitude: lat, longitude:long)
                        let coordinate₁ = CLLocation(latitude:toLat!, longitude:toLong!)
                        
                        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                        var distanceInKm = Float(distanceInMeters/1000)
                       
                        
                        dic.setValue(distanceInKm, forKey:"distance")
                        dic.setValue(shopType, forKey:"shopType")
                        dic.setValue(provideWarranty, forKey:"provideWarranty")
                        dic.setValue(provideReplaceParts, forKey:"provideReplaceParts")
                        dic.setValue(shopRating, forKey:"shopRating")
                        dic.setValue(city, forKey:"city")
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(latitude, forKey:"latitude")
                        dic.setValue(longitude, forKey:"longitude")
                        dic.setValue(serviceType, forKey:"serviceType")
                        dic.setValue(shopDescription, forKey:"shopDescription")
                        dic.setValue(shopName, forKey:"shopName")
                        dic.setValue(brand, forKey:"brands")
                        dic.setValue(false, forKey:"isCollapsed")
                        dic.setValue(shopImage, forKey:"shopImage")
                        let isTrusted = NSNumber(value: (serviceObject.value(forKey: "isTrusted") as! NSString).boolValue)
                        let isDiscounted = NSNumber(value: (serviceObject.value(forKey: "isDiscounted") as! NSString).boolValue)
                        dic.setValue(isTrusted, forKey:"isTrusted")
                        dic.setValue(isDiscounted, forKey:"isDiscounted")
                        self.arrayShopsList.add(dic)

                    }
                    let arrayToSort = NSMutableArray()
                    

                    for i in 0..<self.arrayShopsList.count
                    {
                        let dic = self.arrayShopsList[i] as! NSDictionary
                        arrayToSort.add(dic.value(forKey: "distance") as! NSNumber)
                        
                    }
                    
                    //var array = [5,3,4,6,8,2,9,1,7,10,11]
                    let sortedArray = NSMutableArray(array: arrayToSort)
                    var sortedAboveIndex = arrayToSort.count
                    var swaps = 0
                    if sortedAboveIndex != 0
                    {
                    repeat {
                        var lastSwapIndex = 0
                        
                        for i in 1..<sortedAboveIndex {
                            if (sortedArray[i - 1] as! Float) > (sortedArray[i] as! Float) {
                                sortedArray.exchangeObject(at: i, withObjectAt: i-1)
                                self.arrayShopsList.exchangeObject(at: i, withObjectAt:i-1)
                                lastSwapIndex = i
                                swaps += 1
                            }
                        }
                        
                        sortedAboveIndex = lastSwapIndex
                        
                    } while (sortedAboveIndex != 0)
                    
                    }
                    //print(self.arrayShopsList)
                    self.lblShowFilterdResult.text = "\(self.arrayShopsList.count) ورشة من أصل  \(self.arrayShopsList.count) "
                    self.lblShopsCount.text = " عدد الورش \(self.arrayShopsList.count)"
                    DispatchQueue.main.async{
                        self.tblShopList.reloadData()
                    }
                    
                }
                
                MBProgressHUD.hide(for:self.view, animated:true)
                
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
            self.present(alert, animated: true, completion: nil)}
        
        
    }

    
    
    
    func getCities()
    {
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        self.appDelegate.ArrayOfCities = []
         MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.getCities, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let arrayOfService = serviceTypeObject?.value(forKey:"citiesList") as! NSArray
                    for i in 0..<arrayOfService.count {
                        let  dic =  NSMutableDictionary()
                        let serviceObject = arrayOfService[i] as! NSDictionary
                        //print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                        let latitude = serviceObject.value(forKey: "latitude") as? String
                        let longitude = serviceObject.value(forKey: "longitude") as? String
                        let name = serviceObject.value(forKey: "name") as! String
                        
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(dateAdded, forKey:"dateAdded")
                        dic.setValue(latitude, forKey:"latitude")
                        dic.setValue(longitude, forKey:"longitude")
                        dic.setValue(name, forKey:"name")
                        self.appDelegate.ArrayOfCities.add(dic)
                        
                        
                    }
                    
                    self.getCurrentlocation (lat: 0,long: 0)
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
            self.present(alert, animated: true, completion: nil)}
    }

    func getCurrentlocation (lat :Double!,long:Double!)
 {
  
    if self.isMapreferesh != true
    {
    let  forlocationlati = Double(UserDefaults.standard.value(forKey: "lat")as! NSNumber)
    let  forLocationlongi = Double(UserDefaults.standard.value(forKey: "long") as! NSNumber)
    let location = CLLocation(latitude: forlocationlati as CLLocationDegrees, longitude: forLocationlongi as CLLocationDegrees)
    
    map.isMyLocationEnabled = true
    // map.settings.myLocationButton = true
    map.camera = GMSCameraPosition(target: location.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
    }
    
    var isAvailableNet = appDelegate.isInternetAvailable()
    if isAvailableNet == true
    {
    MBProgressHUD.showAdded(to: self.view, animated:true)
    var lati :Double!
    var  longi:Double!
    if lat == 0
    {
         lati = Double(UserDefaults.standard.value(forKey: "lat")as! NSNumber)
         longi = Double(UserDefaults.standard.value(forKey: "long") as! NSNumber)
        
        
        

    }
    else
    {
        lati = lat
        longi = long
        
        

    
    }
    
    let urlString  =  "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lati!),\(longi!)&language=ar&key=\(appDelegate.googleMapsApiKey)"
    
    
    Alamofire.request(urlString, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
        
        switch(response.result) {
        case .success(_):
            if response.result.value != nil{
                
                //print(response.result.value as Any)
                let  serviceTypeObject = response.result.value as? NSDictionary
                let shopsList = serviceTypeObject?.value(forKey:"results") as! NSArray
                //print(shopsList)
                if (shopsList.count) > 0
                {
                    var name:String!
                  for var j in 0..<shopsList.count
                  {
              if self.isFind == false
              {
                    let addressObject = shopsList [j] as? NSDictionary
                    
                    //print(addressObject as Any)
                
                    let arrayOfAddressComponents = addressObject?.value(forKey: "address_components") as! NSArray
                    
                    for var i in 0..<arrayOfAddressComponents.count
                    {
                        if  self.isFind == false
                        {
                        let objectatOneIndex = arrayOfAddressComponents[i] as! NSDictionary
                       
                        let types = objectatOneIndex.value(forKey: "types") as? NSArray
                        let locality = types?[0] as? String
                        
                        //print(locality as Any)
                        if locality == "locality"
                        {
                            
                        name  = objectatOneIndex.value(forKey: "short_name") as! String
                            //print(name)
                            if name != "" && name != nil
                            {
                            let chek = name.isAlphanumeric
                            if chek == true
                            {
                               
                            }
                            else
                            {
                                
                                j = shopsList.count + 2
                                i = arrayOfAddressComponents.count + 2
                                
                             
                            }
                            }
                            
                        }
                }
                
                }
                if name != "" && name != nil
                {
                   if self.isFind == false
                   {
                    
                    let  formateType = "name CONTAINS[C] %@"
                    let  searchString = name
                    let serviceSearchPredicate = NSPredicate(format:formateType , searchString!)
                    let serviceArray = (self.appDelegate.ArrayOfCities as NSMutableArray).filtered(using: serviceSearchPredicate)
                    if serviceArray.count>0
                    {
                        
                        self.isFind = true
                       let cityObject  = serviceArray [0] as! NSDictionary
                        let id = cityObject.value(forKey: "ID") as! String
                        self.getShopsListForMapCityWise(cityID: id ,lat: lati,long:longi,moapOrList: "m")
                        self.lblCurrentLocation.text = cityObject.value(forKey: "name") as? String
                        UserDefaults.standard.set(id, forKey:"selectedCityID")
                        UserDefaults.standard.set(cityObject.value(forKey: "name") as! String, forKey:"selectedCityName")
                    }
                    else
                    {
                        let  formateType = "name CONTAINS[C] %@"
                        let  searchString = "الرياض"
                        let serviceSearchPredicate = NSPredicate(format:formateType , searchString)
                        let serviceArray = (self.appDelegate.ArrayOfCities as NSMutableArray).filtered(using: serviceSearchPredicate)
                        if serviceArray.count>0
                        {
                            
                            self.isFind = true
                            let cityObject  = serviceArray [0] as! NSDictionary
                            let id = cityObject.value(forKey: "ID") as! String
                            self.getShopsListForMapCityWise(cityID: id ,lat: lati,long:longi,moapOrList: "m")
                            self.lblCurrentLocation.text = cityObject.value(forKey: "name") as? String
                            UserDefaults.standard.set(id, forKey:"selectedCityID")
                            UserDefaults.standard.set(cityObject.value(forKey: "name") as! String, forKey:"selectedCityName")
                        }

                    
                    }
                }
                }
                else
                   {
                  //  self.lblShowFilterdResult.text = "\("0") عدد الورش "
                                       //     self.lblShopsCount.text = "\("0")  عدد الورش"
                    
                                            MBProgressHUD.hide(for:self.view, animated:true)
                    let alert = UIAlertController(title: "Carefer", message: "لم يتم العثور على موقعك الحالي ...!", preferredStyle: UIAlertControllerStyle.alert)
                                            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                                            self.present(alert, animated: true, completion: nil)
                    
                   
                
                }
                    MBProgressHUD.hide(for:self.view, animated:true)
                
                    }
            }

        }
                MBProgressHUD.hide(for:self.view, animated:true)
                
                
            }
            MBProgressHUD.hide(for:self.view, animated:true)
            break
            
        case .failure(_):
            print(response.result.error as Any)
            MBProgressHUD.hide(for:self.view, animated:true)
            break
            
        }
    }

    
    }
    else
    
    {}
    }
     func didMoveToSuperview() {
        self.view.superview?.autoresizesSubviews = false;
    }
    func getServiceType()
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.kServiceTypeData, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let serviceTypeData = serviceTypeObject?.value(forKey:"serviceTypeData") as! NSArray
                    for i in 0..<serviceTypeData.count {
                        let  dic =  NSMutableDictionary()
                        let serviceObject = serviceTypeData[i] as! NSDictionary
                        //print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                        let serviceTypeName = serviceObject.value(forKey: "serviceTypeName") as! String
                     
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(dateAdded, forKey:"dateAdded")
                        dic.setValue(serviceTypeName, forKey:"serviceTypeName")
                        dic.setValue(false, forKey:"isSelected")
                        self.aarayOFserviceTypeForNextController.add(dic)
                    }
                    self.getCarBrand()
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
            self.present(alert, animated: true, completion: nil)}
 
    }
    func getCarBrand()
    {
        
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.kBrandData, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let brandsData = serviceTypeObject?.value(forKey:"brandsData") as! NSArray
                    for i in 0..<brandsData.count {
                        let  dic =  NSMutableDictionary()
                        let serviceObject = brandsData[i] as! NSDictionary
                        //print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                        let serviceTypeName = serviceObject.value(forKey: "brandName") as! String
                        
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(dateAdded, forKey:"dateAdded")
                        dic.setValue(serviceTypeName, forKey:"brandName")
                        dic.setValue(false, forKey:"isSelected")
                        self.arrayCararnd.add(dic)
                    }
                   
//                    let newdic = NSMutableDictionary()
//                    newdic.setValue("علامة تجارية", forKey:"brandName")
//                    self.arrayCararnd.insert(newdic, at:0)
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
            self.present(alert, animated: true, completion: nil)}
    }
    
    func getPlaceTypes()
    {
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.filtertypes, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let placeType = serviceTypeObject?.value(forKey:"placeType") as! NSArray
                    let brandsData = serviceTypeObject?.value(forKey:"brandsData") as! NSArray
                    let serviceTypeData = serviceTypeObject?.value(forKey:"serviceTypeData") as! NSArray
                    for i in 0..<serviceTypeData.count {
                        let  dic =  NSMutableDictionary()
                        let serviceObject = serviceTypeData[i] as! NSDictionary
                        //print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                        let serviceTypeName = serviceObject.value(forKey: "serviceTypeName") as! String
                        
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(dateAdded, forKey:"dateAdded")
                        dic.setValue(serviceTypeName, forKey:"serviceTypeName")
                        dic.setValue(false, forKey:"isSelected")
                        self.aarayOFserviceTypeForNextController.add(dic)
                    }

                    for i in 0..<brandsData.count {
                        let  dic =  NSMutableDictionary()
                        let serviceObject = brandsData[i] as! NSDictionary
                        //print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                        let serviceTypeName = serviceObject.value(forKey: "brandName") as! String
                        
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(dateAdded, forKey:"dateAdded")
                        dic.setValue(serviceTypeName, forKey:"brandName")
                        dic.setValue(false, forKey:"isSelected")
                        self.arrayCararnd.add(dic)
                    }

                    
                    for i in 0..<placeType.count {
                        let  dic =  NSMutableDictionary()
                        let serviceObject = placeType[i] as! NSDictionary
                        //print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                        let serviceTypeName = serviceObject.value(forKey: "name") as! String
                        
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(dateAdded, forKey:"dateAdded")
                        dic.setValue(serviceTypeName, forKey:"name")
                        dic.setValue(false, forKey:"isSelected")
                        self.arrayOFPlaceTypes.add(dic)
                    }
                    self.appDelegate.ArrayOfServices = self.aarayOFserviceTypeForNextController
                    self.appDelegate.ArrayOfCarBrands = self.arrayCararnd
                    self.appDelegate.ArrayOfPlaceType = self.arrayOFPlaceTypes

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
            self.present(alert, animated: true, completion: nil)}
        
    }

    //MARK: MKMapViewDelegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       
        let lat = mapView.camera.target.latitude
        let long = mapView.camera.target.longitude
        self.latOnMapClick = lat
        self.longOnMapClick = long
        
    }
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let mapLatitude = mapView.centerCoordinate.latitude
        let mapLongitude = mapView.centerCoordinate.longitude
       let center = "Latitude: \(mapLatitude) Longitude: \(mapLongitude)"
            self.latOnMapClick = mapLatitude
            self.longOnMapClick = mapLongitude
            
        

        print(center)
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // 1
        let index:Int! = Int(marker.accessibilityLabel!)
        // 2
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        let dic = self.arrayPoints[index] as! NSDictionary
        
        calloutView.starbucksImage.image = UIImage(named:"Icon-83.5")
                        if   let imageString = dic.value(forKey: "shopImage")
                        {
        
                            let imageFinalString = "\(Constants.kBaseUrlImages)\(dic.value(forKey: "ID")as! String)/thumbnails/\(imageString)"
                            let trimmedString = imageFinalString.trim()
        
                            // let url = URL(string: "http://www.stackoverflow.com")
                            let urlStr : NSString = trimmedString.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
                            let searchURL : NSURL = NSURL(string: urlStr as String)!
                            // let url = NSURL(string:searchURL)
                            let img = UIImageView()
                            img.sd_setImage(with:searchURL as URL   , placeholderImage:UIImage(named:"Icon-83.5"))
                            calloutView.starbucksImage.image = img.image
        
        
        
                        }//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
    
        calloutView.starbucksName.text = dic.value(forKey: "shopName") as? String
        calloutView.starbucksAddress.text = dic.value(forKey: "serviceType") as? String
        calloutView.starbucksPhone.text = dic.value(forKey: "shopDescription") as? String
        
        let rating  = dic.value(forKey: "shopRating") as? String
        let ratingInt = Double(rating!)
        calloutView.ratingView.rating = ratingInt!
        calloutView.starbucksName.font = UIFont(name:Constants.kShahidFont,size:8)
        calloutView.starbucksAddress.font = UIFont(name:Constants.kShahidFont,size:8)
        calloutView.starbucksPhone.font = UIFont(name:Constants.kShahidFont,size:8)
        
        calloutView.btnGoToShopDetail.addTarget(self, action: #selector(HomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.btnGoToShopDetail.tag = index
        
        calloutView.center = CGPoint(x:-(calloutView.bounds.size.width), y: calloutView.bounds.size.height - 60)
        
        return calloutView
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let index:Int! = Int(marker.accessibilityLabel!)
        var dic:NSDictionary!
        dic = self.arrayPoints[index]as! NSDictionary
        
        let shopDetailVc = self.storyboard?.instantiateViewController(withIdentifier: "shopDetailVc") as! ShopDetailViewController
        shopDetailVc.aarayserviceType = self.aarayOFserviceTypeForNextController
        shopDetailVc.arrayCararnd = self.arrayCararnd
        shopDetailVc.shopId = dic.value(forKey: "ID") as! String
        shopDetailVc.destinationLat = Double(dic.value(forKey: "latitude")as! String)!
        shopDetailVc.destinationLong = Double(dic.value(forKey: "longitude")as! String)!
        self.navigationController?.pushViewController(shopDetailVc, animated: true)
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let index:Int! = Int(marker.accessibilityLabel!)
        // 2
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        let dic = self.arrayPoints[index] as! NSDictionary
        calloutView.starbucksImage.image = UIImage(named:"Icon-83.5")
        
        if   let imageString = dic.value(forKey: "shopImage")
        {
            
            let imageFinalString = "\(Constants.kBaseUrlImages)\(dic.value(forKey: "ID")as! String)/thumbnails/\(imageString)"
            let trimmedString = imageFinalString.trim()
            
            // let url = URL(string: "http://www.stackoverflow.com")
            let urlStr : NSString = trimmedString.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
            let searchURL : NSURL = NSURL(string: urlStr as String)!
            // let url = NSURL(string:searchURL)
            let img = UIImageView()
            img.sd_setImage(with:searchURL as URL   , placeholderImage:UIImage(named:"Icon-83.5"))
            calloutView.starbucksImage.image = img.image
            
            
            
        }//make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        
        calloutView.starbucksName.text = dic.value(forKey: "shopName") as? String
        calloutView.starbucksAddress.text = dic.value(forKey: "serviceType") as? String
        calloutView.starbucksPhone.text = dic.value(forKey: "shopDescription") as? String
        
        let rating  = dic.value(forKey: "shopRating") as? String
        let ratingInt = Double(rating!)
        calloutView.ratingView.rating = ratingInt!
        calloutView.starbucksName.font = UIFont(name:Constants.kShahidFont,size:8)
        calloutView.starbucksAddress.font = UIFont(name:Constants.kShahidFont,size:8)
        calloutView.starbucksPhone.font = UIFont(name:Constants.kShahidFont,size:8)
        
        calloutView.btnGoToShopDetail.addTarget(self, action: #selector(HomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.btnGoToShopDetail.tag = index
        
        calloutView.center = CGPoint(x:-(calloutView.bounds.size.width), y: calloutView.bounds.size.height - 60)
            self.view.addSubview(calloutView)
        
        return false
    }
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let starbucksAnnotation = view.annotation as! StarbucksAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.starbucksName.text = starbucksAnnotation.name
        calloutView.starbucksAddress.text = starbucksAnnotation.address
        calloutView.starbucksPhone.text = starbucksAnnotation.phone
        let dic = self.arrayPoints[starbucksAnnotation.id!] as! NSDictionary
        let rating  = dic.value(forKey: "shopRating") as? String
        let ratingInt = Double(rating!)
        calloutView.ratingView.rating = ratingInt!
        calloutView.starbucksName.font = UIFont(name:Constants.kShahidFont,size:10)
        calloutView.starbucksAddress.font = UIFont(name:Constants.kShahidFont,size:10)
        calloutView.starbucksPhone.font = UIFont(name:Constants.kShahidFont,size:10)
        //
        //let button = UIButton(frame: calloutView.starbucksPhone.frame)
        calloutView.btnGoToShopDetail.addTarget(self, action: #selector(HomeViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        calloutView.btnGoToShopDetail.tag = starbucksAnnotation.id!
        //calloutView.addSubview(button)
        calloutView.starbucksImage.image = starbucksAnnotation.image
        // 3
        calloutView.center = CGPoint(x:-(calloutView.bounds.size.width/2 + 10), y: calloutView.bounds.size.height - 60)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    

    func callPhoneNumber(sender: UIButton)
    {
        let v = sender.superview as! CustomCalloutView
        let tag = v.btnGoToShopDetail.tag
        var dic:NSDictionary!
        dic = self.arrayPoints[tag]as! NSDictionary
        
        let shopDetailVc = self.storyboard?.instantiateViewController(withIdentifier: "shopDetailVc") as! ShopDetailViewController
        shopDetailVc.aarayserviceType = self.aarayOFserviceTypeForNextController
        shopDetailVc.arrayCararnd = self.arrayCararnd
        shopDetailVc.shopId = dic.value(forKey: "ID") as! String
        shopDetailVc.destinationLat = Double(dic.value(forKey: "latitude")as! String)!
        shopDetailVc.destinationLong = Double(dic.value(forKey: "longitude")as! String)!
        self.navigationController?.pushViewController(shopDetailVc, animated: true)
        

        print(tag)
    }
    
// mark Text Field Delegate 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtSearchField.resignFirstResponder()
        if (self.txtSearchField.text?.characters.count)! > 0
        {
        
        }
        else
        {
            issearchActive = false;
            self.tblShopList.reloadData()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var ArrayTosearch:NSMutableArray = []
//        if issearchActive == true
//        {
//        ArrayTosearch = filteredArrayShopsList
//        }
//        else
//        {
        ArrayTosearch = self.arrayShopsList
        //}
        if ArrayTosearch.count != 0
        {
        
        if (self.txtSearchField.text?.characters.count)! > 0
        {
       let  formateType = "shopName CONTAINS[C] %@"
       //seachString = shopObject.value(forKey: "provideWarranty") as! String
        let serviceSearchPredicate = NSPredicate(format:formateType , self.txtSearchField.text!)
        let serviceArray = (ArrayTosearch as NSMutableArray).filtered(using: serviceSearchPredicate)
        filteredArrayShopsList = []
        //print ("array = \(serviceArray)")
        filteredArrayShopsList.addObjects(from:serviceArray)
        issearchActive = true;
            
            if filteredArrayShopsList.count > 0
            {
                
            self.lblShopsCount.text = " عدد الورش \(self.filteredArrayShopsList.count)"
            var ArrayBeforeSort = NSMutableArray()
            
                ArrayBeforeSort = self.filteredArrayShopsList
                let arrayToSort = NSMutableArray()
            for i in 0..<ArrayBeforeSort.count
            {
                let dic = ArrayBeforeSort[i] as! NSDictionary
                arrayToSort.add(dic.value(forKey: "distance") as! NSNumber)
                
            }
            
            //var array = [5,3,4,6,8,2,9,1,7,10,11]
            let sortedArray = NSMutableArray(array: arrayToSort)
            var sortedAboveIndex = arrayToSort.count
            self.filteredArrayShopsList = ArrayBeforeSort
            var swaps = 0
            
            repeat {
                var lastSwapIndex = 0
                
                for i in 1..<sortedAboveIndex {
                    if (sortedArray[i - 1] as! Float) > (sortedArray[i] as! Float) {
                        sortedArray.exchangeObject(at: i, withObjectAt: i-1)
                        self.filteredArrayShopsList.exchangeObject(at: i, withObjectAt:i-1)
                        lastSwapIndex = i
                        swaps += 1
                    }
                }
                
                sortedAboveIndex = lastSwapIndex
                
            } while (sortedAboveIndex != 0)
            
            
            // [5, 3, 4, 6, 8, 2, 9, 1, 7, 10, 11]
            //print(arrayToSort)
            
            // [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
            //print(sortedArray as Array)
            //print(self.filteredArrayShopsList)
            //print("Array is sorted in \(swaps) swaps.")
            //print(filteredArrayShopsList)
            }
            self.tblShopList.reloadData()

        }
        else
        {
           self.lblShopsCount.text = " عدد الورش \(self.arrayShopsList.count)"
            issearchActive = false;
            self.tblShopList.reloadData()
        
        }
        }
        return true
    }
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addHideListObserver()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.hideListForMap), name: Notification.Name.kNotifHideListForMap, object: nil);
    }
    
    
    func hideListForMap()
    {
        self.viewForMap.isHidden = true
        self.ShopingListView.isHidden = true
        self.backCheck = true
    }
}
public class EdgeShadowLayer: CAGradientLayer {
    
    public enum Edge {
        case Top
        case Left
        case Bottom
        case Right
    }
    
    public init(forView view: UIView,
                edge: Edge = Edge.Top,
                shadowRadius radius: CGFloat = 6.0,
                toColor: UIColor = UIColor.white,
                fromColor: UIColor = UIColor.gray) {
        super.init()
        self.colors = [fromColor.cgColor, toColor.cgColor]
        self.shadowRadius = radius
        
        let viewFrame = view.frame
        
        switch edge {
        case .Top:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            self.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: shadowRadius)
        case .Bottom:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            self.frame = CGRect(x: 0.0, y: viewFrame.height - shadowRadius, width: viewFrame.width + 900, height: shadowRadius)
        case .Left:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
            self.frame = CGRect(x: 0.0, y: 0.0, width: shadowRadius, height: viewFrame.height)
        case .Right:
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint = CGPoint(x: 0.0, y: 0.5)
            self.frame = CGRect(x: viewFrame.width - shadowRadius, y: 0.0, width: shadowRadius, height: viewFrame.height)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
