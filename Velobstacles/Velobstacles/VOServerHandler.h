//
//  VOServerHandler.h
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-06.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

// Server Handler handles interactions with the Server.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define VO_LATITUDE @"lat"
#define VO_LONGITUDE @"long"
#define VO_RADIUS @"rad"
#define VO_DATA @"data"
#define VO_ID @"id"
#define VO_FORMAT @"format"


typedef enum VOImageFormat : NSUInteger{
    VOImageFormatThumb,
    VOImageFormatNormal
}VOImageFormat;


@interface VOServerHandler : NSObject
+(NSArray*)reportsForLocation:(CLLocationCoordinate2D)location radius:(CLLocationDistance)radius;
+(UIImage*)imageForReport:(NSNumber*)reportID format:(VOImageFormat)format;
+(void)postReport:(id)report;

//tests
+(NSDictionary*)getTest;
@end
