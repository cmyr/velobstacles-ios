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

@interface VOReport : NSObject <MKAnnotation, NSCoding, NSCopying>
@property (nonatomic, strong) NSNumber* reportID;
@property (nonatomic, strong) NSDate* timestamp;
@property (nonatomic, strong) NSNumber* category;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* reportDescription;
@property (nonatomic) BOOL debug;
@property (nonatomic) BOOL hasPhoto;

@property (nonatomic, strong) UIImage* reportImage;

-(NSString*)categoryString;

//class methods
+(VOReport*)reportWithDict:(NSDictionary*)dict;
+(VOReport*)testReport;
+(NSDictionary*)categories;

@end
