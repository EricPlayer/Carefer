//
//  Constant.swift
//  Carefer
//
//  Created by Fatoo on 4/14/17.
//  Copyright © 2017 Fatoo. All rights reserved.
//

import Foundation
struct Constants
{
    
    // live base url
    
     static let  kBaseUrl = "https://carefer.co/public/api/";
     static let  kBaseUrlImages = "https://carefer.co/public/uploads/shop-";
    

    // developement
    // static let  kBaseUrl = "http://carefer.dtechsystems.co/public/api/";
    // static let  kBaseUrlImages = "http://carefer.dtechsystems.co/public/uploads/shop-";
    
    // developement client test
       //  static let  kBaseUrl = "https://test.carefer.co/public/api/";
        // static let  kBaseUrlImages = "https://test.carefer.co/public/uploads/shop-";

    
    //test.carefer.co
    
     static let  kCareferPolicy = kBaseUrl + "policy-data";
     static let  kBrandData = kBaseUrl + "get-brands-data";
     static let  kServiceTypeData = kBaseUrl + "get-service-types";
     static let  kShopsListData = kBaseUrl + "shops-data";
     static let  kShopsDetailsData = kBaseUrl + "shop-details-ios/id/";
     static let  kOrderDetailsData = kBaseUrl + "get-order-details/id/";
     static let  kShopsDetailsOrderModel = kBaseUrl + "get-models";
     static let  kMyOrdersList = kBaseUrl + "get-customer-orders/id/";
     static let  kMyFavouriteShopsList = kBaseUrl + "user-favourite-shops/id/";
     static let  kRatingShop = kBaseUrl + "user-favourite-shops/id/";
     static let  kDoneOrder = kBaseUrl + "save-api-order"
     static let  kGetUserProfile = kBaseUrl + "get-customer-detail/id/"
     static let  kUploadUser = kBaseUrl + "save-customer-detail"
     static let  kUpdateUserProfile =  kBaseUrl + "edit-customer-detail/id/"
     static let  kUploadcomments  =  kBaseUrl  + "save-api-comments"
     static let  kshopfavourite   =  kBaseUrl  + "shop-favourite"
     static let  kreceivemobilenumber = kBaseUrl + "receive-mobile-number"
     static let  verifycustomer = kBaseUrl + "verify-customer"
     static let  verifypolicy = kBaseUrl + "verify-policy"
     static let getbrandmodels = kBaseUrl  + "get-brand-models"
     static let getPlaceType = kBaseUrl  + "get-place-type"
     static let filtertypes = kBaseUrl  + "filter-types"
     static let getShopReviews = kBaseUrl + "get-shop-reviews/"
     static let getCities = kBaseUrl + "get-city-list/"
     static let getShopListByCityWise = kBaseUrl + "city-shops-data/"
     static let  kchangemobilenumber = kBaseUrl + "change-mobile-number"
     static let  kverifycustomernumberchange = kBaseUrl + "verify-customer-number-change"
     static let kRegistrationSkipped = "registrationSkipped"
     static let  kCarBrandUrl = kBaseUrl + "get-brands-data"
     static let  kCarModleUrl = kBaseUrl + "get-brand-models"
     static let  kCarServiceTypeUrl = kBaseUrl + "get-service-types"
     static let  kMovedShopPriceUrl = kBaseUrl + "get-price"
    static let  kGetAddressUrl = kBaseUrl + "get-map-address"
     static let  kGetMovedShopDescriptionUrl = kBaseUrl + "get-service-description/id/1"
     static let  kGetReceivedCarDescriptionUrl = kBaseUrl + "get-service-description/id/2"

    
     // static let  kShahidFont   =  "HSN_Shahd_Regular" // shahid font
      static let  kShahidFont   =  "JFFlat-Regular" // JF Flat Regular
    

}
struct shop {
    
    var shopType:String!
    var provideWarranty:String!
    var provideReplaceParts:String!
    var shopRating:String!
    var city:String!
    var ID:String!
    var latitude:String!
    var longitude:String!
    var serviceType:String!
    var shopDescription:String!
    var shopName:String!
    var brands:String!
    var isCollapsed:Bool!
    var shopImage:String!
    
}

//Notifications
extension Notification.Name {
    static let kNotifRegLaterFinish = Notification.Name("registrationLaterFinished");
    static let kNotifHideListForMap = Notification.Name("hideShopListInFavorOfMap");
}

