//
//  ShopDetailViewController.swift
//  Carefer
//
//  Created by Fatoo on 4/13/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import MBProgressHUD
import GoogleMaps
import Cosmos
import ImageSlideshow
import SKPhotoBrowser

class ShopDetailViewController: CustomTabBarParentController ,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate,GMSMapViewDelegate,UIScrollViewDelegate{
    
    @IBOutlet weak var shopDetailContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shopDetailContainer: UIView!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var ratingView:CosmosView!
    @IBOutlet weak var ratingViewForYellowStars:CosmosView!
    @IBOutlet weak var StarOne:UIImageView!
    @IBOutlet weak var StarTwo:UIImageView!
    @IBOutlet weak var StarThree:UIImageView!
    @IBOutlet weak var StarFour:UIImageView!
    @IBOutlet weak var StarFive:UIImageView!
    @IBOutlet weak var ShopimageOne:UIImageView!
    @IBOutlet weak var ShopimageTwo:UIImageView!
    @IBOutlet weak var ShopimageThree:UIImageView!
    @IBOutlet weak var imgProvideWarranty:UIImageView!
    @IBOutlet weak var imgReplaceParts:UIImageView!
    @IBOutlet weak var RoundedView:UIView!
    @IBOutlet weak var NamebackgrondView:UIView!
    @IBOutlet weak var ViewForServiceBrandModel:UIView!
    @IBOutlet weak var ViewForOrderNow:UIView!
    @IBOutlet weak var ServiceTypeView :UIView!
    @IBOutlet weak var CarBrandView :UIView!
    @IBOutlet weak var ModelView :UIView!
    @IBOutlet weak var ReviewsView :UIView!
    @IBOutlet weak var tabBarView :UIView!
    @IBOutlet weak var discountLabel :UILabel!
    @IBOutlet weak var discountLabelHeightConstraint :NSLayoutConstraint!
    
    @IBOutlet weak var tblReviews:UITableView!
    @IBOutlet weak var tblModel:UITableView!
    @IBOutlet weak var tblserviceType:UITableView!
    @IBOutlet weak var tblCarbrand:UITableView!
    @IBOutlet weak var btnReview:UIButton!
    @IBOutlet weak var map:GMSMapView!
    
    @IBOutlet weak var lblServiceTypeForYellow:UILabel!
    @IBOutlet weak var lblShopNameForYellow:UILabel!
    @IBOutlet weak var lblNavigationTitle:UILabel!
    @IBOutlet weak var lblServiceTypeForOrderNow:UILabel!
    
    @IBOutlet weak var lblServiceType:UILabel!
    @IBOutlet weak var lblAverageRating:UILabel!
    @IBOutlet weak var lblTotalReviews:UILabel!
    @IBOutlet weak var shopDetail:UILabel!
    @IBOutlet weak var lblShopName:UILabel!
    @IBOutlet weak var lblService :UILabel!
    @IBOutlet weak var lblCarBrand :UILabel!
    @IBOutlet weak var lblModel :UILabel!
    @IBOutlet weak var lblReplacePart :UILabel!
    @IBOutlet weak var lblProvidewarranty :UILabel!
    @IBOutlet weak var lblCityTitle :UILabel!
    @IBOutlet weak var lblCity :UILabel!
    @IBOutlet weak var lblReviews :UILabel!
    @IBOutlet weak var lblserviceTypeValue :UILabel!
    @IBOutlet weak var lblserviceTypeTitle :UILabel!
    @IBOutlet weak var lblSpecialBandValue :UILabel!
    @IBOutlet weak var lblSpecialBranTitle :UILabel!
    @IBOutlet weak var lblNationalityValue :UILabel!
    @IBOutlet weak var lblNationalityTitle :UILabel!
    @IBOutlet weak var lblMapButtonTitle :UILabel!
    
    
   
    @IBOutlet weak var lblProvidePartsSwitch:UILabel!
    @IBOutlet weak var lblProvideWarrantySwitch:UILabel!
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var btnDone:UIButton!
    @IBOutlet weak var btnMyNext:UIButton!
    @IBOutlet weak var btnCallTheShop:UIButton!
    @IBOutlet weak var btnNavigate:UIButton!
    @IBOutlet weak var btnOrderNow:UIButton!
    @IBOutlet weak var btnFavourite:UIButton!
    @IBOutlet weak var btnGoogleMapButton:UIButton!
    @IBOutlet weak var btnOpenMapButton:UIButton!
    @IBOutlet weak var btnFullDescriptionButton:UIButton!
    
    
    @IBOutlet weak var ShoupRoundedImageView:UIImageView!
    @IBOutlet weak var ShoupRectangleImageView:UIImageView!
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var ShopDetailScrollView: UIScrollView!
    @IBOutlet weak var ShopDetailScrollViewContentView: UIView!
    // constraints
    @IBOutlet weak var ShopDetailContentViewHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var btnFullDescriptionHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var lblSpecialBrandHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var lblSpecialBrandValueHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var lblNationalityHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var lblServicesHeightConstraint:NSLayoutConstraint!
    
    // shop full description code 
    
    @IBOutlet weak var lblNationalityTitleForShopDescription :UILabel!
    @IBOutlet weak var txtShopFullDescription :UITextView!
    @IBOutlet weak var shopfullDescriptionView :UIView!
    @IBOutlet weak var navigationBar:UIView!
    @IBOutlet weak var navigationBarOfReview:UIView!
    
    // end shop full description code
    var scrollV : UIScrollView!
    let imageWidth:CGFloat = 137
    let imageHeight:CGFloat = 137
    var yPosition:CGFloat = 0
    var xPosition:CGFloat = 20
    var scrollViewContentSize:CGFloat=0;
    
    let layerGradient = CAGradientLayer()
    var arrayOfReviews = NSMutableArray()
    var arrayToStoreIamges = NSMutableArray()
    var aarayserviceType = NSMutableArray()
    var arrayCararnd = NSMutableArray()
    var arrayModel = NSMutableArray()
    var shopId :String!
    var customerId :String!
    var serviceTypeId:String!
    var modelId:String!
    var brandID:String!
    var destinationLat:Double = 0.0
    var destinationLong:Double = 0.0
    var isFavourite = false
    var isFromFavourite = "no"
    var contactNumber:String!
    var imageIndex:Int!
    var imageViewForZoom : UIImageView!
    

    
    var myRoute : MKRoute?
    var locationMarker: GMSMarker!
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    var selectedRoute: Dictionary<NSObject, AnyObject>!
    
    var overviewPolyline: Dictionary<NSObject, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var originAddress: String!
    
    var destinationAddress: String!
    
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    
    var routePolyline: GMSPolyline!
    var mapTasks = MapTasks()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addReqRegViewOnDemand = true;
        
        let topShadow = EdgeShadowLayer(forView:self.navigationBar, edge:.Bottom)
        self.navigationBar.layer.addSublayer(topShadow)
        let topShadow1 = EdgeShadowLayer(forView:self.navigationBarOfReview, edge:.Bottom)
        self.navigationBar.layer.addSublayer(topShadow1)
        

        self.btnReview.isHidden = true
        self.ShoupRoundedImageView.layer.cornerRadius = self.ShoupRoundedImageView.frame.size.width / 2
        self.ShoupRoundedImageView.clipsToBounds = true

        self.lblMapButtonTitle.font = UIFont(name:Constants.kShahidFont ,size:16)
        self.tblReviews.separatorStyle = .none
        if isFromFavourite == "yes"
        {
             self.tabBarController?.tabBar.isHidden = true
        
        }
        else
        {
        
        }
        self.btnFullDescriptionHeightConstraint.constant = 0
        self.btnFullDescriptionButton.isHidden = true
        self.shopfullDescriptionView.isHidden = true
        
        self.arrayCararnd = self.appDelegate.ArrayOfCarBrands
        self.aarayserviceType = self.appDelegate.ArrayOfServices
        self.ShopDetailScrollView.canCancelContentTouches = true
        self.ShopDetailScrollView.delaysContentTouches = true
        self.tblReviews.estimatedRowHeight = 174
        self.tblReviews.rowHeight = UITableViewAutomaticDimension
        self.ReviewsView.isHidden = true
        self.brandID = ""
        self.serviceTypeId = ""
        self.modelId = ""
        self.tblCarbrand.delegate = self
        self.tblserviceType.delegate = self
        self.tblModel.delegate = self
        self.tblModel.isHidden = true
        self.tblCarbrand.isHidden = true
        self.tblserviceType.isHidden = true
        
        self.ViewForServiceBrandModel.isHidden = true
        self.ViewForOrderNow.isHidden = true
        self.map.isHidden = true
        
        self.btnDone.isHidden = true
        self.btnGoogleMapButton.isHidden = true
        self.btnOpenMapButton.isHidden = true
        
        
        self.ModelView.layer.borderWidth = 0.5
        self.ModelView.layer.borderColor = UIColor.gray.cgColor
        self.ServiceTypeView.layer.borderWidth = 0.5
        self.ServiceTypeView.layer.borderColor = UIColor.gray.cgColor
        self.CarBrandView.layer.borderWidth = 0.5
        self.CarBrandView.layer.borderColor = UIColor.gray.cgColor
        
        self.lblNavigationTitle.text = "تفاصيل الورشة"
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
            
        case .pad:
            print("iPad style UI")
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont, size:21)
            self.lblCarBrand.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblService.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblModel.font = UIFont(name:Constants.kShahidFont,size:21)
            self.lblReviews.font = UIFont(name:Constants.kShahidFont,size:21)
            
            self.btnMyNext.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:20)
            self.btnDone.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:20)
            self.btnOrderNow.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:20)
            
            self.btnReview.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblAverageRating.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblReviews.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblTotalReviews.font = UIFont(name:Constants.kShahidFont,size:18)
            self.lblSpecialBandValue.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblSpecialBranTitle.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblNationalityTitle.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblNationalityValue.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblserviceTypeValue.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblserviceTypeTitle.font = UIFont(name:Constants.kShahidFont,size:20)
            
            
            
            self.lblReplacePart.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblProvidewarranty.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblCityTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblCity.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblShopName.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblServiceType.font = UIFont(name:Constants.kShahidFont,size:20)
            self.shopDetail.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblShopNameForYellow.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblServiceTypeForYellow.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblServiceTypeForOrderNow.font = UIFont(name:Constants.kShahidFont,size:20)
            
            self.txtShopFullDescription.font = UIFont(name:Constants.kShahidFont,size:20)
            self.lblNationalityTitleForShopDescription.font = UIFont(name:Constants.kShahidFont,size:20)
            

            
        case .phone:
            print("iPhone and iPod touch style UI")
            self.lblNavigationTitle.font = UIFont(name:Constants.kShahidFont, size:16)
            self.lblCarBrand.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblService.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblModel.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblReviews.font = UIFont(name:Constants.kShahidFont,size:16)
            
            
            self.btnMyNext.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:16)
            self.btnDone.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:16)
            self.btnOrderNow.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:16)
            
            self.btnReview.titleLabel?.font = UIFont(name:Constants.kShahidFont,size:10)
            self.lblAverageRating.font = UIFont(name:Constants.kShahidFont,size:16)
            
            self.lblTotalReviews.font = UIFont(name:Constants.kShahidFont,size:12)
            self.lblSpecialBandValue.font = UIFont(name:Constants.kShahidFont,size:14)
            self.lblSpecialBranTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblNationalityTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblNationalityValue.font = UIFont(name:Constants.kShahidFont,size:14)
            self.lblserviceTypeValue.font = UIFont(name:Constants.kShahidFont,size:14)
            self.lblserviceTypeTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            
            
            
            self.lblReplacePart.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblProvidewarranty.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblCityTitle.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblCity.font = UIFont(name:Constants.kShahidFont,size:14)
            self.lblShopName.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblServiceType.font = UIFont(name:Constants.kShahidFont,size:14)
            self.shopDetail.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblShopNameForYellow.font = UIFont(name:Constants.kShahidFont,size:18)
            self.lblServiceTypeForYellow.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblServiceTypeForOrderNow.font = UIFont(name:Constants.kShahidFont,size:16)
            
            self.txtShopFullDescription.font = UIFont(name:Constants.kShahidFont,size:16)
            self.lblNationalityTitleForShopDescription.font = UIFont(name:Constants.kShahidFont,size:16)
            

        case .tv:
            print("tvOS style UI")
        default:
            print("Unspecified UI idiom")
        }

        
        
       
        self.tblReviews.isMultipleTouchEnabled = false
        self.tblReviews.allowsSelection = false
        self.tblserviceType.tableFooterView = UIView()
        self.tblModel.tableFooterView = UIView()
        self.tblCarbrand.tableFooterView = UIView()
        
        
        
        
        
        
        self.getShopsDetails()
        // Do any additional setup after loading the view.
        
        if !self.isUserDataAccessible
        {
            self.addRegistrationFinishedObserver();
        }
    }
    
    func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    func drawPath()
    {
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
         MBProgressHUD.showAdded(to: self.view, animated:true)
        self.map.isMyLocationEnabled = true
        let fromLat = CLLocationDegrees(UserDefaults.standard.value(forKey: "lat")as! Double)
        let fromLong = CLLocationDegrees(UserDefaults.standard.value(forKey: "long") as! Double)
        let position = CLLocationCoordinate2D(latitude: fromLat, longitude: fromLong)
        let marker = GMSMarker(position: position)
        // marker.isDraggable = true
       // marker.title = "Hello World"
        marker.map = map
        let markerImage = UIImage(named: "1x-pin-map")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        let position1 = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
            
        let marker1 = GMSMarker(position: position1)
           // marker1.iconView = markerView
            marker1.icon = UIImage(named: "1x-pin-map")
            
        // marker.title = "Hello World"
        marker1.isDraggable = true
        marker1.map = map

       
        let origin = "\(fromLat),\(fromLong)"
        let destination = "\(destinationLat),\(destinationLong)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(appDelegate.googleMapsApiKey)"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    
                    
                    OperationQueue.main.addOperation({
                        for route in routes
                        {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            polyline.strokeColor = UIColor.orange
                            
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.map!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            
                            polyline.map = self.map
                            
                            }
                        MBProgressHUD.hide(for:self.view, animated:true)
                    })
                }catch let error as NSError{
                    print("error:\(error)")
                    MBProgressHUD.hide(for:self.view, animated:true)
                }
            }
        }).resume()
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        
        
        
    }
        //MARK:- Annotations
    
    func getMapAnnotations() -> [MKPointAnnotation] {
        let fromLat = CLLocationDegrees(UserDefaults.standard.value(forKey: "lat")as! NSNumber)
        let fromLong = CLLocationDegrees(UserDefaults.standard.value(forKey: "long") as! NSNumber)
        let newYorkLocation = CLLocationCoordinate2DMake(fromLat, fromLong)
        var annotations:Array = [MKPointAnnotation]()
        let dropPin = MKPointAnnotation()
         dropPin.coordinate = newYorkLocation
        annotations.append(dropPin)
        //source point
        print(destinationLat)
        print(destinationLong)
        let sourceLocation = CLLocationCoordinate2DMake(destinationLat, destinationLong)
        let sourcePin = MKPointAnnotation()
        sourcePin.coordinate = sourceLocation
        annotations.append(sourcePin)
        
        return annotations
    }
    
    //MARK:- MapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            
        }
        return polylineRenderer
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        let _ = self.view;
        let _ = self.shopDetailContainer;
        // Google tracking
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Shop Detail Screen")
            
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
            
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if let length = self.shopDetail.text?.characters.count, length ==  0  {
            DispatchQueue.main.async {
                self.shopDetailContainerHeightConstraint.constant = 0 ;
                self.shopDetailContainer.layoutIfNeeded();
                self.view.layoutIfNeeded();
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func btnFullDescriptionButton(sender:UIButton)
    {
    self.shopfullDescriptionView.isHidden = false
    }
    @IBAction  func btnBackFromShopFullDescription(sender:UIButton)
    {
         self.shopfullDescriptionView.isHidden = true
    }
    @IBAction  func btnOrderNow(sender:UIButton)
    {
        if !self.isUserDataAccessible
        {
            self.addRequireRegistrationView(topMargin: 58.0)
        }
        else
        {
            // comment code for service type ,model and brand selection
            // self.btnBack.tag = 1 uncomment code for service type ,model and brand selection
            self.btnOrderNow.isHidden = true
            self.ViewForServiceBrandModel.isHidden = true // make it false to show service type ,model and brand selection screen
            self.lblNavigationTitle.text = "اطلب الأن"
            // this code does not exsit if need to show above selection screen
            self.btnBack.tag = 1
            self.ViewForOrderNow.isHidden = false
        }
    }
    
    @IBAction  func btnFavourite(sender:UIButton)
    {
        if !self.isUserDataAccessible {
            self.addRequireRegistrationView(topMargin: 58.0)
        }else {
            self.makeFavouriteAndUnfavourite()
        }
    }
    
    @IBAction  func btnBackFromReviews(sender:UIButton)
    {
        self.ReviewsView.isHidden = true
    }
    @IBAction  func btnShowReviews(sender:UIButton)
    {
       
        
        self.getReviews()
        self.ReviewsView.isHidden = false
    }
    @IBAction func btnGoToGoogleMap(sender:UIButton)
   {
    
    if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
    {
        let urlString = "http://maps.google.com/?daddr=\(destinationLat),\(destinationLong)&directionsmode=driving"
        
        // use bellow line for specific source location
        
        //let urlString = "http://maps.google.com/?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&directionsmode=driving"
        
        UIApplication.shared.openURL(URL(string: urlString)!)
    }
    else
    {
        //let urlString = "http://maps.apple.com/maps?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&dirflg=d"
        let urlString = "http://maps.apple.com/maps?daddr=\(destinationLat),\(destinationLong)&dirflg=d"
        
        UIApplication.shared.openURL(URL(string: urlString)!)
    }
    
    }
    @IBAction func btnOpenGoogleMap(sender:UIButton)
    {
        
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        {
            let urlString = "http://maps.google.com/?daddr=\(destinationLat),\(destinationLong)&directionsmode=driving"
            
            // use bellow line for specific source location
            
            //let urlString = "http://maps.google.com/?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&directionsmode=driving"
            
            UIApplication.shared.openURL(URL(string: urlString)!)
        }
        else
        {
            //let urlString = "http://maps.apple.com/maps?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&dirflg=d"
            let urlString = "http://maps.apple.com/maps?daddr=\(destinationLat),\(destinationLong)&dirflg=d"
            
            UIApplication.shared.openURL(URL(string: urlString)!)
        }
        
    }
    @IBAction  func btnNext(sender:UIButton)
    {
      
        if self.serviceTypeId as String != ""
        {
            
            if self.brandID as String != ""
            {
                if self.modelId as String != ""
                {
                    self.btnBack.tag = 2
                    self.ViewForOrderNow.isHidden = false
                    //self.postOrder()
                }
                else
                {
                    let alertController = UIAlertController(title: "Carefer", message: "حدد موديل بليس", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    present(alertController, animated: true, completion: nil)
                }
                
            }
            else
            {
                let alertController = UIAlertController(title: "Carefer", message: "حدد الماركة الرجاء", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Carefer", message: "حدد الخدمة من فضلك", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }

        
    }
    @IBAction  func btnBack(sender:UIButton)
    {
      
        if sender.tag == 0
        {
        self.navigationController?.popViewController(animated: true)
        }
        if sender.tag == 1
        {
            self.btnBack.tag = 0
        self.ViewForServiceBrandModel.isHidden = true
        self.ViewForOrderNow.isHidden = true
            self.btnOrderNow.isHidden = true
            self.map.isHidden = true
            
            self.btnDone.isHidden = true
            self.btnGoogleMapButton.isHidden = true
            self.btnOpenMapButton.isHidden = true
             self.btnOrderNow.isHidden = false
             self.lblNavigationTitle.text = "تفاصيل الورشة"
        }
        else
        if sender.tag == 2
        {
//            self.btnBack.tag = 1
//            self.ViewForOrderNow.isHidden = true
//            self.btnOrderNow.isHidden = true
//            self.lblNavigationTitle.text = "اطلب الأن"
            // uncomment this code also to show service type selection screen on pressing backbutton and comment below line
             self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.btnBack.tag = 2
            self.map.isHidden = true
            self.btnDone.isHidden = true
            self.btnGoogleMapButton.isHidden = true
            self.btnOpenMapButton.isHidden = true
           
            self.lblNavigationTitle.text = "اطلب الأن"
            self.ViewForOrderNow.isHidden = false
        }
       
    }
    
    @IBAction func btnBackToMap(sender:UIButton)
    {
        
        // UserDefaults.standard.set("no", forKey: "isFirstForCity")
        //appDelegate.setHomeVc()
        NotificationCenter.default.post(name: Notification.Name.kNotifHideListForMap, object: nil);
        let _ = self.navigationController?.popViewController(animated: true);
    }
    @IBAction  func btnServiceType(sender:UIButton)
    {
       
        
        self.btnMyNext.isHidden = true
        self.tblCarbrand.isHidden = true
        self.tblModel.isHidden = true
        self.tblserviceType.isHidden = false
        self.ModelView.layer.borderWidth = 0.5
        self.ModelView.layer.borderColor = UIColor.gray.cgColor
        self.ServiceTypeView.layer.borderWidth = 0.5
        self.ServiceTypeView.layer.borderColor = UIColor(red: 240/255, green: 158/255, blue: 40/255, alpha: 1.0).cgColor
        self.CarBrandView.layer.borderWidth = 0.5
        self.CarBrandView.layer.borderColor = UIColor.gray.cgColor
    }
    @IBAction  func btnCarBrand(sender:UIButton)
    {
        self.btnMyNext.isHidden = true
        self.tblCarbrand.isHidden = false
        self.tblModel.isHidden = true
        self.tblserviceType.isHidden = true
        self.ModelView.layer.borderWidth = 0.5
        self.ModelView.layer.borderColor = UIColor.gray.cgColor
        self.ServiceTypeView.layer.borderWidth = 0.5
        self.ServiceTypeView.layer.borderColor = UIColor.gray.cgColor
        self.CarBrandView.layer.borderWidth = 0.5
        self.CarBrandView.layer.borderColor = UIColor(red: 240/255, green: 158/255, blue: 40/255, alpha: 1.0).cgColor
    }
    @IBAction  func btnModel(sender:UIButton)
    {
        if self.arrayModel.count > 0
        {
            self.tblModel.isHidden = false
            self.btnMyNext.isHidden = true

        }

        
        
        self.tblCarbrand.isHidden = true
                self.tblserviceType.isHidden = true
        self.ModelView.layer.borderWidth = 0.5
        self.ModelView.layer.borderColor = UIColor(red: 240/255, green: 158/255, blue: 40/255, alpha: 1.0).cgColor
        self.ServiceTypeView.layer.borderWidth = 0.5
        self.ServiceTypeView.layer.borderColor = UIColor.gray.cgColor
        self.CarBrandView.layer.borderWidth = 0.5
        self.CarBrandView.layer.borderColor = UIColor.gray.cgColor
    }
    @IBAction func btnNavigateToTheShop(sender:UIButton)
    {
        FirebaseLogger.shared.logCreateOrderEvent();
        self.postOrder(callOrNavigate: "n")
        if UserDefaults.standard.value(forKey: "showDistance") as! String == "yes"
        {
            self.drawPath()
            self.btnBack.tag = 3
            self.map.isHidden = false
            self.btnDone.isHidden = false
            self.btnGoogleMapButton.isHidden = false
            self.btnOpenMapButton.isHidden = false
            self.lblNavigationTitle.text = "ملاحة"
            

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

        
        
    }
    @IBAction func btnCallTheShop(sender:UIButton)
    {
        FirebaseLogger.shared.logCreateOrderEvent();
        self.postOrder(callOrNavigate: "c")
        let num = self.contactNumber
        guard let number = URL(string: "telprompt://" + num!) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func btnDone(sender:UIButton)
    {
        let _ = self.navigationController?.popViewController(animated: true);
    }
    
    func makeFavouriteAndUnfavourite()
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        
        var action = ""
        if self.isFavourite == true
        {
        action = "del"
        }
        else
        {
        action = "add"
        }
        var dic = [String:Any]()
        let id = UserDefaults.standard.value(forKey: "ID") as! String
        dic =  ["customerID": id, "shopID": self.shopId,"action":action]
        
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.kshopfavourite, method: .post, parameters:dic, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    MBProgressHUD.hide(for:self.view, animated:true)
                    if action == "add"
                    {
                         self.btnFavourite.setImage(UIImage(named:"star-balck-icon"), for:UIControlState.normal)
                    let alert = UIAlertController(title: "Carefer", message: "تم إضافة الورشة في قائمتك المفضلة", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                         self.isFavourite = true
                   
                       
                        
                        
                        
                        
                    }
                    else
                    {
                        self.btnFavourite.setImage(UIImage(named:"star-icon"), for:UIControlState.normal)
                        let alert = UIAlertController(title: "Carefer", message: "تم حذف الورشة من قائمتك المفضلة", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                         self.isFavourite = false
                       

                        
                        
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
    func postOrder(callOrNavigate:String)
        
    {
        
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        var orderType :String!
        if callOrNavigate == "c"
        {
            orderType = "call"
        }
        else
        {
        orderType = "navigate"
        }
        let id = UserDefaults.standard.value(forKey: "ID") as! String
        
        var dic = [String:Any]()
            dic =  ["customerID": id, "shopID": self.shopId,"orderType": orderType, "orderServiceType": "shops", "orderStatus" : ""]

        
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.kDoneOrder, method: .post, parameters:dic, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let _ = serviceTypeObject?.value(forKey:"orderID") as! String
                    MBProgressHUD.hide(for:self.view, animated:true)
                   
                    /*let alertController = UIAlertController(title: "Carefer", message: "تم إنشاء طلبك", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "موافق", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)*/
                    UserDefaults.standard.set("yes", forKey:"fromOrderDone")
                    UserDefaults.standard.set("no", forKey: "isFirstForCity")
                   
                    
                    
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
            self.present(alert, animated: true, completion: nil)
        }
    }

    func getShopsDetails()
    {
        
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.kShopsDetailsData+self.shopId, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let shopsDetail = serviceTypeObject?.value(forKey:"shopsDetail") as! NSArray
                    let shopImages = serviceTypeObject?.value(forKey:"shopImages") as! NSArray
                    let shopDetailObject = shopsDetail[0]as! NSDictionary
                    print(shopDetailObject)
                    for i in 0..<shopImages.count
                        
                    {
                        
                        let myImageView:UIImageView = UIImageView()
                        myImageView.contentMode = UIViewContentMode.scaleToFill
                        myImageView.frame.size.width = self.imageWidth
                        myImageView.frame.size.height = self.imageHeight
                        // myImageView.center = self.view.center
                        myImageView.frame.origin.y = self.yPosition
                        myImageView.frame.origin.x = self.xPosition
                        myImageView.tag = i
                        myImageView.image = UIImage(named:"1x-place-holder")
                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShopDetailViewController.imageTapped(_:)))
                        //Add the recognizer to your view.
                        myImageView.addGestureRecognizer(tapRecognizer)
                        myImageView.isUserInteractionEnabled = true
                        myImageView.layer.cornerRadius = 10
                         myImageView.layer.masksToBounds = true
                        
                        self.myScrollView.addSubview(myImageView)
                        let spacer:CGFloat = 4
                        self.xPosition+=self.imageWidth + spacer
                        self.scrollViewContentSize+=self.imageWidth + spacer
                        self.myScrollView.contentSize = CGSize(width: self.scrollViewContentSize + 15, height: self.myScrollView.frame.size.height)
                        
                        
                        let dic = shopImages[i] as! NSDictionary
                        let imageString = dic.value(forKey: "imageName")as! String
                        //http://carefer.dtechsystems.co/en/public/uploads/shop-1/url
                        let imageFinalString = "\(Constants.kBaseUrlImages)\(shopDetailObject.value(forKey: "ID")as! String)/\(imageString)"
                        self.imageFromServerURL(urlString:imageFinalString , index:i ,imageView: myImageView)
                    }
                    let w = Int(self.myScrollView.contentSize.width - self.view.frame.size.width + 15)
                    self.myScrollView.contentOffset = CGPoint(x:w , y:0)
                    self.destinationLat = Double(shopDetailObject.value(forKey: "latitude") as! String)!
                    self.destinationLong = Double(shopDetailObject.value(forKey: "longitude") as! String)!
                    self.contactNumber = shopDetailObject.value(forKey: "contactNumber") as! String
                    self.lblShopName.text = shopDetailObject.value(forKey: "shopName")as? String
                    self.lblServiceType.text = shopDetailObject.value(forKey: "shopType")as? String
                    self.shopDetail.text = shopDetailObject.value(forKey: "shopDescription")as? String
                    self.lblShopNameForYellow.text = shopDetailObject.value(forKey: "shopName")as? String
                    self.lblServiceTypeForYellow.text = shopDetailObject.value(forKey: "shopType")as? String
                    self.lblServiceTypeForOrderNow.text = shopDetailObject.value(forKey: "shopType")as? String
                    self.lblCity.text = shopDetailObject.value(forKey: "city") as? String
                    let averageRating = shopDetailObject.value(forKey: "shopRating") as? String
                    let reviewCount = shopDetailObject.value(forKey: "reviewCount") as? String
                    let avgRatingWithOneDigit = String(format: "%.1f", Double(averageRating!)!)
                    let avgRatingWithSlash = "\(avgRatingWithOneDigit)/5"
                    self.btnReview.layer.cornerRadius = self.btnReview.frame.size.width / 2
                    self.btnReview.clipsToBounds = true
                    self.btnReview.setTitle(avgRatingWithSlash, for:.normal)
                    if let detail = shopsDetail.firstObject as? [String:Any], let discountPercent = detail["discountPercent"] as? String
                    {
                        self.discountLabel.isHidden = false;
                        self.discountLabel.text = "\(discountPercent) % خصم";
                        self.discountLabelHeightConstraint.constant = 21;
                    }else if let detail = shopsDetail.firstObject as? [String:Any], let discountPercent = detail["discountPercent"] as? Float {
                        self.discountLabel.isHidden = false;
                        self.discountLabel.text = "\(discountPercent) % خصم";
                        self.discountLabelHeightConstraint.constant = 21;
                    } else {
                        self.discountLabel.isHidden = true;
                    }
                    if avgRatingWithOneDigit == "0.0"
                    {
                        self.btnReview.isHidden = true
                    }
                    else
                    
                    {
                        self.btnReview.isHidden = false
                    }
                    let numberFormatter = NumberFormatter()
                    let number = numberFormatter.number(from: avgRatingWithOneDigit)
                    if let totalRatingShop = number?.doubleValue {
                        //let totalRatingShop =
                        if (totalRatingShop > 4.4) {
                           // aQuery.id(R.id.tv_rating_type).text(getResources().getString(R.string.tv_excelent));
                            self.btnReview.backgroundColor = UIColor.green
                            self.lblAverageRating.text = "ممتاز"
                            
                        } else if (totalRatingShop > 3.4) {
                           // aQuery.id(R.id.tv_rating_type).text(getResources().getString(R.st ring.tv_good));
                            let color = UIColor(red: 8/255, green: 145/255, blue: 28/255, alpha: 1.0)
                            self.btnReview.backgroundColor = color
                            self.lblAverageRating.text = "جيد"
                            
                            
                        } else if (totalRatingShop > 2.4) {
                          //  aQuery.id(R.id.tv_rating_type).text(getResources().getString(R.string.tv_average));
                            self.btnReview.backgroundColor = UIColor.blue
                            
                            self.lblAverageRating.text = "مقبول"
                            
                        } else  {
                           // aQuery.id(R.id.tv_rating_type).text(getResources().getString(R.string.tv_lower));
                            self.btnReview.backgroundColor = UIColor.gray
                            self.lblAverageRating.text = "سيئ"
                            
                        }
                    }
                    if reviewCount != nil && reviewCount != "0"
                    {
                       
                        self.lblTotalReviews.isHidden = false
                        self.lblAverageRating.isHidden = false
                        self.lblTotalReviews.text = "إظهار كل \(reviewCount!) التعليقات"
                        self.lblReviews.font = UIFont(name:Constants.kShahidFont,size:16)
                    }
                    else
                    {
                       
                        self.lblTotalReviews.isHidden = true
                        self.lblAverageRating.isHidden = true
                        self.lblReviews.text = "هذه الورشة لايوجد لديها تعليقات"
                        self.lblReviews.font = UIFont(name:Constants.kShahidFont,size:12)
                    }
                    if shopDetailObject.value(forKey: "provideWarranty")as? String == "1"
                    {
                        self.imgProvideWarranty.image = UIImage(named:"tick-icon")
                    //self.lblProvideWarrantySwitch.text = "نعم"
                    }
                    else
                    {
                        self.imgProvideWarranty.image = UIImage(named:"close-icon")
                     //self.lblProvideWarrantySwitch.text = "لا"
                    }
                    if shopDetailObject.value(forKey: "provideReplaceParts")as? String == "1"
                    {
                     // self.lblProvidePartsSwitch.text = "نعم"
                        self.imgReplaceParts.image = UIImage(named:"tick-icon")
                    }
                        
                    else
                    {
                     //  self.lblProvidePartsSwitch.text = "لا"
                        self.imgReplaceParts.image = UIImage(named:"close-icon")
                    }
                    
                    print(shopDetailObject)
                   // let lblserviceTypeTitle = shopDetailObject.value(forKey: "serviceType")as! String
                    let height = self.heightDetailLabel(text:shopDetailObject.value(forKey: "brands")as! String , font: UIFont(name:Constants.kShahidFont,size:16)!, width:self.lblserviceTypeValue.frame.size.width)
                   // let str = lblserviceTypeTitle
                    self.lblServicesHeightConstraint.constant = height
                    
                    if shopDetailObject.value(forKey: "specialisedBrand")as? String != nil && shopDetailObject.value(forKey: "specialisedBrand")as? String != ""
                    {
                        
                        
                        
                      self.lblSpecialBandValue.text = shopDetailObject.value(forKey: "specialisedBrand")as? String
                        self.lblSpecialBrandHeightConstraint.constant = 21
                        self.lblSpecialBrandValueHeightConstraint.constant = 21
                    }
                    else
                    {
                       self.lblSpecialBrandHeightConstraint.constant = 0
                        self.lblSpecialBrandValueHeightConstraint.constant = 0
                    }
                    
                    let heightofNationalityLabel = self.heightDetailLabel(text:shopDetailObject.value(forKey: "nationality")as! String , font: UIFont(name:Constants.kShahidFont,size:16)!, width:self.lblserviceTypeValue.frame.size.width)
                    // let str = lblserviceTypeTitle
                    self.lblNationalityHeightConstraint.constant = heightofNationalityLabel
                    self.lblNationalityValue.text = shopDetailObject.value(forKey: "nationality")as? String
                    self.lblserviceTypeValue.text = shopDetailObject.value(forKey: "brands")as? String
                   
                    // set custom font
                    
                    

                    
                    
                    self.txtShopFullDescription.text = shopDetailObject.value(forKey: "shopDescription")as! String
                    self.lblNationalityTitleForShopDescription.text = shopDetailObject.value(forKey: "shopName")as? String
                    
                    let numLines = shopDetailObject.value(forKey: "shopDescription")as! String
                    let cont  = NSMutableAttributedString(string:numLines)
                    let lines = cont.numberOfLines(with: self.shopDetail.frame.size.width)
                    //self.btnFullDescriptionHeightConstraint.constant = 0
                    if lines > 4
                    {
                        
                        self.btnFullDescriptionHeightConstraint.constant = 30
                        self.btnFullDescriptionButton.isHidden = false
                        //self.btnFullDescriptionButton.isHidden = false
                    print("greater than four line")
                    }
                    
                    
                    let rating = shopDetailObject.value(forKey: "shopRating")as! String
                    self.btnFavourite.setImage(UIImage(named:"star-icon"), for:UIControlState.normal)
                    self.isFavourite = false
                    self.updateFavoriteStatus();
                    self.ratingView.rating = Double(rating)!
                    self.ratingViewForYellowStars.rating = Double(rating)!
                                        
                     self.ShopDetailScrollView.contentSize = CGSize(width:self.ShopDetailScrollView.frame.size.width ,height :self.ShopDetailScrollView.contentSize.height + 100)
        
                    self.ShopDetailScrollViewContentView.frame = CGRect(x:0,y:0,width:self.ShopDetailScrollView.frame.size.width,height:self.ShopDetailScrollView.contentSize.height)
                    self.ShopDetailScrollView.addSubview( self.ShopDetailScrollViewContentView)
                    
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
        }
        else
        {
            let alert = UIAlertController(title: "Carefer", message: "لا يتوفر انترنت …!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)}
        
    }
    
    func updateFavoriteStatus()
    {
        let isAvailableNet = appDelegate.isInternetAvailable()
        let userId = UserDefaults.standard.value(forKey: "ID") as? String
        if isAvailableNet == true && userId != nil
        {
            let urlString = "\(Constants.kMyFavouriteShopsList)\(userId!)"
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(urlString, method: .get, parameters:nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let arrayOfService = serviceTypeObject?.value(forKey:"favouriteShops") as! NSArray
                        for i in 0..<arrayOfService.count {
                            let serviceObject = arrayOfService[i] as! NSDictionary
                            if let currentShopID = serviceObject.value(forKey: "ID") as? String
                            {
                                if currentShopID == self.shopId
                                {
                                    self.btnFavourite.setImage(UIImage(named:"star-balck-icon"), for:UIControlState.normal)
                                    self.isFavourite = true;
                                    break;
                                }
                            }
                        }
                    }
                    break
                    
                case .failure(_):
                    print(response.result.error as Any)
                    break
                }
            }
        }
    }
    
       func heightDetailLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }

    
    
    func imageFromServerURL(urlString: String ,index:Int,imageView:UIImageView) {
        
        //MBProgressHUD.showAdded(to: self.view, animated:true)
        let urlStr : NSString = urlString.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
      // let trimmedString = urlString.trim()
        
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x:imageView.frame.size.width / 2 - 20, y:imageView.frame.size.height / 2 - 24, width: 40, height: 40)
        
        // Add the UIActivityIndicatorView as a subview on the cell
        imageView.addSubview(activityIndicator)
        // Start the UIActivityIndicatorView animating
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: searchURL as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                 MBProgressHUD.hide(for:self.view, animated:true)
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                MBProgressHUD.hide(for:self.view, animated:true)
                if index == 0
                {
                   
                    if image != nil
                    {
                    let context = CIContext(options: nil)
                    let currentFilter = CIFilter(name: "CIGaussianBlur")
                    let beginImage = CIImage(image: image!)
                    currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
                    currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
                    
                    let cropFilter = CIFilter(name: "CICrop")
                    cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
                    cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
                    
                    let output = cropFilter!.outputImage
                    let cgimg = context.createCGImage(output!, from: output!.extent)
                    let processedImage = UIImage(cgImage: cgimg!)
                    self.ShoupRectangleImageView.image = processedImage
                    
                    self.ShoupRoundedImageView.image = image
                    }
                    
                }
                self.arrayToStoreIamges.add(image)
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
               let size = CGSize(width: 200, height: 200)
                if image != nil
                {
                    imageView.image = self.resizeImage(image:image! , targetSize:size)
                    
                    
                }
                
                
                 MBProgressHUD.hide(for:self.view, animated:true)
                
                
            })
            
        }).resume()
    }
    func getSwipeAction( _ recognizer : UISwipeGestureRecognizer){
        let imageView = recognizer.view as! UIImageView
        
         print(imageIndex)
        if recognizer.direction == .right{
            print("Right Swiped")
            
           imageIndex = imageIndex + 1
           if  imageIndex < self.arrayToStoreIamges.count
           {
            
            
            let image = self.arrayToStoreIamges[imageIndex] as! UIImage
            imageView.image = image
            }
            else
           {
            imageIndex = self.arrayToStoreIamges.count
            }
        } else if recognizer.direction == .left {
            
            if  imageIndex > 0
            {
            imageIndex = imageIndex - 1
            let image = self.arrayToStoreIamges[imageIndex] as! UIImage
            print("Left Swiped")
            imageView.image = image
            }
        }
        
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func imageTapped(_ sender: UITapGestureRecognizer) {
     
        
        
        let tagint = sender.view as! UIImageView
        print(tagint)
        if arrayToStoreIamges.count > 0
        {
        var images = [SKPhoto]()
        for i in 0..<arrayToStoreIamges.count
            
        {
            let photo = SKPhoto.photoWithImage(arrayToStoreIamges[i]as! UIImage)
            images.append(photo)
        }
        let browser = SKPhotoBrowser(photos: images)
        
        browser.initializePageIndex(tagint.tag)
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        SKPhotoBrowserOptions.displayCounterLabel = false
        present(browser, animated: false, completion: {})
        }
        

    }
    
      
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 3
        {
            //let count =  self.arrayOfReviews.count + 1
            return self.arrayOfReviews.count
        }
        else
        if tableView.tag == 0
        {
            return self.aarayserviceType.count
        }
        else
        if tableView.tag == 1
        {
            return self.arrayCararnd.count
        }
        else
        {
        return self.arrayModel.count
        }
        //return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView.tag == 3
        {
            
            let identifier = "reviewsCell"
            var cell: ReviewsTableViewCell! = tblReviews.dequeueReusableCell(withIdentifier: identifier) as? ReviewsTableViewCell
            if cell == nil
            {
                tblReviews.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tblReviews.dequeueReusableCell(withIdentifier: identifier) as? ReviewsTableViewCell
            }
            if indexPath.row == 0
            {
                let ob = self.arrayOfReviews[indexPath.row] as! NSDictionary
                cell.sepratorView.isHidden = true
                cell.lblAverage.isHidden = true
                cell.imageViewBeyondAverage.isHidden = true
                cell.lblDateAdded.isHidden = true
                //cell.lblName.text = "\(self.btnReview.titleLabel!.text!)/5   \(self.lblAverageRating.text!)"
                let myString:NSString = "\(self.btnReview.titleLabel!.text!)   \(self.lblAverageRating.text!)" as NSString
                var myMutableString = NSMutableAttributedString()
               
                
                
                
                
                let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                
                // 2. check the idiom
                switch (deviceIdiom) {
                    
                case .pad:
                     myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: Constants.kShahidFont, size: 22.0)!])
                   myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: Constants.kShahidFont, size: 14.0)!, range: NSRange(location:3,length:2))
                    
                case .phone:
                     myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: Constants.kShahidFont, size: 20.0)!])
                    print("iPhone and iPod touch style UI")
                    myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: Constants.kShahidFont, size: 12.0)!, range: NSRange(location:3,length:2))
                    
                case .tv:
                    print("tvOS style UI")
                    
                default:
                    print("Unspecified UI idiom")
                }

                cell.lblName.attributedText = myMutableString
                
                let p = ob.value(forKey: "priceAVG") as? String
                let q = ob.value(forKey: "qualityAVG") as? String
                let t = ob.value(forKey: "timeAVG") as? String
                
                var priceRating = 0.0
                var qualityRating = 0.0
                var  timeRating = 0.0
                if p == ""
                {
                    
                }
                else
                {
                    priceRating = NumberFormatter().number(from:p!)!.doubleValue
                    
                }
                if q == ""
                {
                    
                }
                else
                {
                    qualityRating = NumberFormatter().number(from:q!)!.doubleValue
                    
                }
                if t == ""
                {
                    
                }
                else
                {
                    
                    timeRating = NumberFormatter().number(from:t!)!.doubleValue
                }
                

                cell.priceRatingView.rating = Double(priceRating)
                cell.TimeRatingView.rating = Double(timeRating)
                cell.QualityRatingView.rating = Double(qualityRating)
            }
            else
            
            {
                
                cell.sepratorView.isHidden = false
                cell.lblAverage.isHidden = false
                cell.imageViewBeyondAverage.isHidden = false
                cell.lblDateAdded.isHidden = false

            let dic = self.arrayOfReviews[indexPath.row] as! NSDictionary
           
            print(dic)
            let comment = dic.value(forKey: "comment")as? String
            let hidAction = dic.value(forKey:"hidAction")as? String
            let dateAdded = dic.value(forKey: "dateAdded")as? String
            //let hidAction = dic.value(forKey: "hidAction")as! String
            let p = dic.value(forKey: "priceRating") as? String
            let q = dic.value(forKey: "qualityRating") as? String
            let t = dic.value(forKey: "timeRating") as? String
                
                var priceRating = 0.0
                var qualityRating = 0.0
                var  timeRating = 0.0
            if p == ""
            {
            
            }
            else
            {
                priceRating = NumberFormatter().number(from:p!)!.doubleValue
                
            }
            if q == ""
            {
                
            }
            else
            {
                 qualityRating = NumberFormatter().number(from:q!)!.doubleValue
                
            }
            if t == ""
            {
                
            }
            else
            {
               
                timeRating = NumberFormatter().number(from:t!)!.doubleValue
            }
            
            
            let totalRating = Double(priceRating) + Double(timeRating) + Double(qualityRating)
            let avgRating = totalRating/3
            let avgInString = String(format:"%.1f", avgRating)
            cell.lblAverage.text = avgInString
            if hidAction == "0"
            {
                cell.lblComment.text = comment
            }
            cell.priceRatingView.rating = Double(priceRating)
            cell.TimeRatingView.rating = Double(timeRating)
            cell.QualityRatingView.rating = Double(qualityRating)
            
            var customername:String!
            if (dic.value(forKey: "customerName")as? String) != nil && (dic.value(forKey: "customerName")as? String) != ""
            {
            cell.lblName.text = dic.value(forKey: "customerName")as? String
                customername = dic.value(forKey: "customerName")as? String
            }
            else
            {
             cell.lblName.text = "مجهول الإسم"
                customername = "مجهول الإسم"
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            // read input date string as NSDate instance
            if let date = formatter.date(from: dateAdded!) {
                
                // set locale to "ar_DZ" and format as per your specifications
                formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
                formatter.dateFormat = "yyyy-MM-dd"
                let outputDate = formatter.string(from: date)
                cell.lblDateAdded.text = String(outputDate)
                
                print(outputDate) // الأربعاء, 9 مارس, 2016 10:33 ص
            }
            }
            
            cell.backGroundView.layer.shadowOpacity = 0.5
            cell.backGroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.backGroundView.layer.shadowRadius = 2.0
            cell.backGroundView.layer.shadowColor = UIColor.black.cgColor
            
            //let name = customername
            
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            
            // 2. check the idiom
            switch (deviceIdiom) {
                
            case .pad:
                print("iPad style UI")
                if indexPath.row != 0
                {
                cell.lblName.font = UIFont(name:Constants.kShahidFont ,size:20)
                }
                cell.lblDateAdded.font = UIFont(name:Constants.kShahidFont ,size:20)
                cell.lblComment.font = UIFont(name:Constants.kShahidFont ,size:20)
                cell.lblAverage.font = UIFont(name:Constants.kShahidFont ,size:20)
                
            case .phone:
                print("iPhone and iPod touch style UI")
                if indexPath.row != 0
                {
                cell.lblName.font = UIFont(name:Constants.kShahidFont ,size:18)
                }
                cell.lblDateAdded.font = UIFont(name:Constants.kShahidFont ,size:18)
                cell.lblComment.font = UIFont(name:Constants.kShahidFont ,size:16)
                
                           case .tv:
                print("tvOS style UI")
                
            default:
                print("Unspecified UI idiom")
            }

           
              return cell
        }
        else
        if tableView.tag == 0
        {
            let cell:DropDownTableViewCell = self.tblserviceType.dequeueReusableCell(withIdentifier:"ServiceAndBrandCell") as! DropDownTableViewCell!
            let dic = self.aarayserviceType[indexPath.row] as! NSMutableDictionary
             cell.lblServicetypeOrBrand.text = (dic.value(forKey: "serviceTypeName")as? String)
             cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont , size:16)
            return cell
        }
        else
            if tableView.tag == 1
        {
            let cell:DropDownTableViewCell = self.tblCarbrand.dequeueReusableCell(withIdentifier:"ServiceAndBrandCell") as! DropDownTableViewCell!
            let dic = self.arrayCararnd[indexPath.row] as! NSMutableDictionary
            cell.lblServicetypeOrBrand.text = dic.value(forKey: "brandName")as? String
             cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont , size:16)
            return cell
        }
        else
            {
                let cell:DropDownTableViewCell = self.tblModel.dequeueReusableCell(withIdentifier:"ServiceAndBrandCell") as! DropDownTableViewCell!
                let dic = self.arrayModel[indexPath.row] as! NSMutableDictionary
                cell.lblServicetypeOrBrand.text = dic.value(forKey: "modelName")as? String
                cell.lblServicetypeOrBrand.font = UIFont(name:Constants.kShahidFont , size:16)
                return cell

        }
        
        // set the text from the data model
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dic = NSMutableDictionary()
      
        
        
        if tableView.tag == 0
        {
            dic = self.aarayserviceType[indexPath.row]as! NSMutableDictionary
            self.lblService.text = dic.value(forKey: "serviceTypeName") as? String
            self.serviceTypeId = dic.value(forKey: "ID") as? String
            self.lblService.font = UIFont(name:Constants.kShahidFont,size:16)
            self.btnMyNext.isHidden = false
            self.tblserviceType.isHidden = true
            self.tblCarbrand.isHidden = true
            self.tblModel.isHidden = true
        }
        else
            if tableView.tag == 1
        {
            self.arrayModel = []
            self.brandID = ""
            self.lblModel.text = "اختار السنة"
            dic = self.arrayCararnd[indexPath.row]as! NSMutableDictionary
            self.lblCarBrand.text = dic.value(forKey: "brandName") as? String
            self.brandID = dic.value(forKey: "ID") as? String
            self.lblCarBrand.font = UIFont(name:Constants.kShahidFont,size:16)
            self.btnMyNext.isHidden = false
            self.tblserviceType.isHidden = true
            self.tblCarbrand.isHidden = true
            self.tblModel.isHidden = true
            self.getModels()
        }
        else
                if tableView.tag == 2
            {
                dic = self.arrayModel[indexPath.row]as! NSMutableDictionary
                self.lblModel.text = dic.value(forKey: "modelName") as? String
                self.modelId = dic.value(forKey: "ID") as? String
                self.lblModel.font = UIFont(name:Constants.kShahidFont,size:16)
                self.btnMyNext.isHidden = false
                self.tblserviceType.isHidden = true
                self.tblCarbrand.isHidden = true
                self.tblModel.isHidden = true
              }
        
        print("You tapped cell number \(indexPath.row).")
    }
    func getReviews()
    {
     
        
        let isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        if self.shopId != ""
        {
            
            self.arrayOfReviews = []
            var parameter = [String:Any]()
            parameter = ["shopID":self.shopId]
            
            MBProgressHUD.showAdded(to: self.view, animated:true)
            Alamofire.request(Constants.getShopReviews, method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                      
                        
                        print(response.result.value as Any)
                    
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        let AVGRatings = serviceTypeObject?.value(forKey:"AVGRatings") as? NSArray
                        let arrayOfService = serviceTypeObject?.value(forKey:"shopReviews") as! NSArray
                        for i in 0..<arrayOfService.count {
                            let  dic =  NSMutableDictionary()
                            let serviceObject = arrayOfService[i] as! NSDictionary
                            print(serviceObject)
                            let id = serviceObject.value(forKey: "ID") as? String
                            let dateAdded = serviceObject.value(forKey: "dateAdded") as? String
                            let comment = serviceObject.value(forKey: "comment") as? String
                            let customerName = serviceObject.value(forKey: "customerName") as? String
                            let hidAction = serviceObject.value(forKey: "hidAction") as? String
                            let priceRating = serviceObject.value(forKey: "priceRating") as? String
                            let qualityRating = serviceObject.value(forKey: "qualityRating") as? String
                            let timeRating = serviceObject.value(forKey: "qualityRating") as? String
                            dic.setValue(customerName, forKey:"customerName")
                            dic.setValue(priceRating, forKey:"priceRating")
                            dic.setValue(hidAction, forKey:"hidAction")
                            dic.setValue(qualityRating, forKey:"qualityRating")
                            dic.setValue(timeRating, forKey:"timeRating")
                            dic.setValue(id, forKey:"ID")
                            dic.setValue(dateAdded, forKey:"dateAdded")
                            dic.setValue(comment, forKey:"comment")
                            self.arrayOfReviews.add(dic)
                        }
                        
                        if self.arrayOfReviews.count == 0
                        {
                            let alert = UIAlertController(title: "Carefer", message: "لم يتم العثور على أي سجل حتى الآن!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.ReviewsView.isHidden = true
                            
                        }
                        else
                        
                        {
                            if (AVGRatings?.count)! > 0
                            {
                        self.arrayOfReviews.insert(AVGRatings?[0] as! NSDictionary, at:0)
                            }
                        }
                        self.tblReviews.reloadData()
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
            let alert = UIAlertController(title: "Carefer", message: "الرجاء الاختيار من القائمة المنسدلة", preferredStyle: UIAlertControllerStyle.alert)
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

 func getModels()
    {
        var isAvailableNet = appDelegate.isInternetAvailable()
        if isAvailableNet == true
        {
        if self.brandID != ""
        {
       
            
            var parameter = [String:Any]()
             parameter = ["brandID":self.brandID]
        
        MBProgressHUD.showAdded(to: self.view, animated:true)
        Alamofire.request(Constants.getbrandmodels, method: .post, parameters:parameter, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                    let  serviceTypeObject = response.result.value as? NSDictionary
                    let arrayOfService = serviceTypeObject?.value(forKey:"models") as! NSArray
                    for i in 0..<arrayOfService.count {
                        let  dic =  NSMutableDictionary()
                        let serviceObject = arrayOfService[i] as! NSDictionary
                        print(serviceObject)
                        let id = serviceObject.value(forKey: "ID") as! String
                        let dateAdded = serviceObject.value(forKey: "dateAdded") as! String
                        let serviceTypeName = serviceObject.value(forKey: "modelName") as! String
                        
                        dic.setValue(id, forKey:"ID")
                        dic.setValue(dateAdded, forKey:"dateAdded")
                        dic.setValue(serviceTypeName, forKey:"modelName")
                        self.arrayModel.add(dic)
                    }
                    if self.arrayModel.count == 0
                    {
                        let alert = UIAlertController(title: "Carefer", message: "لم يتم العثور على أي سجل حتى الآن!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "موافق", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.btnMyNext.isHidden = false
                        self.tblserviceType.isHidden = true
                        self.tblCarbrand.isHidden = true
                        self.tblModel.isHidden = true
                    }
                    MBProgressHUD.hide(for:self.view, animated:true)
                    self.tblModel.reloadData()
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
            let alert = UIAlertController(title: "Carefer", message: "الرجاء الاختيار من القائمة المنسدلة", preferredStyle: UIAlertControllerStyle.alert)
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
    // MARK: - CLLocationManagerDelegate
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 3
        if status == .authorizedWhenInUse {
            
            // 4
            locationManager.startUpdatingLocation()
            
            //5
            
        }
    }
    
    // 6
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            
            // 7
            
            
            // 8
            locationManager.stopUpdatingLocation()
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func didRegister()
    {
        self.removeRequireRegistrationView();
        self.postRegisterationFinishedNotfication();
    }
    
    override func didCancelRegistration()
    {
        if self.addReqRegViewOnDemand {
            self.removeRequireRegistrationView();
        }
    }
    
    func addRegistrationFinishedObserver()
    {
        if !self.isUserDataAccessible {
            NotificationCenter.default.addObserver(self, selector: #selector(didFinishRegisterLater(notification:)), name: Notification.Name.kNotifRegLaterFinish, object: nil);
        }
    }
    
    func didFinishRegisterLater(notification: Notification)
    {
        
    }


}
extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
extension NSAttributedString {
    
    func numberOfLines(with width: CGFloat) -> Int {
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        let frameSetterRef : CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef: CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)
        
        let linesNS: NSArray  = CTFrameGetLines(frameRef)
        
        guard let lines = linesNS as? [CTLine] else { return 0 }
        return lines.count
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
// MARK: - CLLocationManagerDelegate
//1


