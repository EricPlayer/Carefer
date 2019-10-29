//
//  StarbucksAnnotation.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/16/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import MapKit
import Cosmos
class StarbucksAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var id: Int!
    var address: String!
    var image: UIImage!
   
     var starOne:UIImage!
     var starTwo:UIImage!
     var starThree:UIImage!
     var starFour:UIImage!
     var starFive:UIImage!
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
