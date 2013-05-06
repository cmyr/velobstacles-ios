//
//  VOReport.h
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-06.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface VOReport : NSObject <MKAnnotation>
@property (nonatomic, strong) NSNumber* reportID;
@property (nonatomic, strong) NSDate* timestamp;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString* description;
@property (nonatomic) BOOL debug;
@property (nonatomic) BOOL hasPhoto;

+(VOReport*)reportWithDict:(NSDictionary*)dict;
@end
