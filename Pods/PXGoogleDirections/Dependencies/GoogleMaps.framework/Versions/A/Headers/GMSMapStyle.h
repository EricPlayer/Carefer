//
//  GMSMapStyle.h
//  Google Maps SDK for iOS
//
//  Copyright 2016 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <Foundation/Foundation.h>

#if __has_feature(modules)
@import GoogleMapsBase;
#else
#import <GoogleMapsBase/GoogleMapsBase.h>
#endif

GMS_ASSUME_NONNULL_BEGIN

/**
 * GMSMapStyle holds details about a style which can be applied to a map.
 *
 * With style options you can customize the presentation of the standard Google map styles, changing
 * the visual display of features like roads, parks, and other points of interest. As well as
 * changing the style of these features, you can also hide features entirely. This means that you
 * can emphasize particular components of the map or make the map complement the content of your
 * app.
 *
 * For more information see: https://developers.google.com/maps/documentation/ios-sdk/styling
 */
@interface GMSMapStyle : NSObject

/**
 * Creates a style using a string containing JSON.
 *
 * Returns nil and populates |error| (if provided) if |style| is invalid.
 */
+ (GMS_NULLABLE_INSTANCETYPE)styleWithJSONString:(NSString *)style
                                           error:(NSError *__autoreleasing GMS_NULLABLE_PTR *)error;

/**
 * Creates a style using a file containing JSON.
 *
 * Returns nil and populates |error| (if provided) if |style| is invalid, the file cannot be read,
 * or the URL is not a file URL.
 */
+ (GMS_NULLABLE_INSTANCETYPE)
    styleWithContentsOfFileURL:(NSURL *)fileURL
                         error:(NSError *__autoreleasing GMS_NULLABLE_PTR *)error;

@end

GMS_ASSUME_NONNULL_END
