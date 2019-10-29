//
//  MapViewController.swift
//  Carefer
//
//  Created by Muzammal Hussain on 11/7/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import MBProgressHUD
import Alamofire

class MapViewController : UIViewController
{
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var titleLabel : UILabel!
    
    var isFromMovedShop = false;
    var appDelegate = UIApplication.shared.delegate as! AppDelegate;
    var currentAddress : String! = nil;
    var location : CLLocation! = nil;
    weak var callerController : MoveShopReceiveCarBaseController! = nil;
    
    override func viewDidLoad()
    {
        self.mapView.delegate = self;
        self.titleLabel.text = isFromMovedShop ? "الورشة المتنقلة" : "استلام السيارة"
        if self.location == nil
        {
            //default location to Riaydh captial of KSA
             self.location = CLLocation(latitude: 24.7136, longitude: 46.6753);
            reverseGeoCodeLocation(location: self.location);
        }
        else
        {
            self.addressLabel.text = self.currentAddress;
        }
        //let annotation = StarbucksAnnotation(coordinate: self.location.coordinate);
        //self.mapView.addAnnotation(annotation);
        let span = MKCoordinateSpanMake(0.0275, 0.0275)
        let coodinate = self.location.coordinate;
        let region = MKCoordinateRegion(center: coodinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func reverseGeoCodeLocation(location : CLLocation)
    {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
        hud.labelText = "...جار الحصول على العنوان";
        DispatchQueue.global().async
        {
            _ = CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
                if let mark = placeMarks?.first {
                    if let address = mark.addressDictionary?["FormattedAddressLines"] as? [String] {
                        DispatchQueue.main.async {
                            self.addressLabel.text = address.joined(separator: ", ");
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:{
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                    MBProgressHUD.hide(for: self.view, animated: true);
                });
            })
        }
    }
    
    @IBAction func back(sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func done(sender: Any)
    {
        callerController.location = self.location;
        callerController.addressLabel.text = self.addressLabel.text;
        _ = self.navigationController?.popViewController(animated: true);
    }
    
}

extension MapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        self.location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude);
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
        hud.labelText = "...جار الحصول على العنوان ";
        self.getAddress();
        
    }
    
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
//    {
//        if annotation is MKUserLocation
//        {
//            return nil;
//        }
//        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "mapPin");
//        annotationView.image = UIImage(named: "map-pin");
//        annotationView.canShowCallout = false;
//        annotationView.isDraggable = true;
//        return annotationView;
//    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
//
//        if newState == MKAnnotationViewDragState.ending {
//
//            if let coordinates = view.annotation?.coordinate {
//
//                view.setDragState(MKAnnotationViewDragState.none, animated:false)
//                let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
//                hud.labelText = "...جار الحصول على العنوان ";
//                //self.reverseGeoCodeLocation(location: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude));
//                self.location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude);
//                self.getAddress();
//            }
//
//        }
//    }
//
    
    func getAddress()
    {
        if self.location == nil {return;}
        let parameters = ["longitude":self.location.coordinate.longitude , "latitude":self.location.coordinate.latitude]
        if appDelegate.isInternetAvailable()
        {
            Alamofire.request(Constants.kGetAddressUrl, method: .post, parameters:parameters, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print(response.result.value as Any)
                        let  serviceTypeObject = response.result.value as? NSDictionary
                        DispatchQueue.main.async {
                            if let add = serviceTypeObject?["address"] as? String {
                                self.addressLabel.text = add;
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:{
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                            MBProgressHUD.hide(for: self.view, animated: true);
                        });
                    }
                    break
                case .failure(_):
                    print(response.result.error as Any)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute:{
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: false);
                        MBProgressHUD.hide(for: self.view, animated: true);
                    });
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
}
