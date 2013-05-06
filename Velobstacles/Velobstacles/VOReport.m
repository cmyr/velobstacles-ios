//
//  VOReport.m
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-06.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOReport.h"

@implementation VOReport

//takes a dict as returned by server and converts to a VOReport object
+(VOReport*)reportWithDict:(NSDictionary *)dict
{
    return nil;
}

+(VOReport*)testReport
{
   
    VOReport* report = [[VOReport alloc]init];
    //generate a random coordinate:
    float randLat, randLong;
    randLat = (arc4random() % 400)*0.0001f;
    randLat += 45.49;
    randLong = (arc4random() % 500)*0.0001f;
    randLong += -73.6;
    CLLocationCoordinate2D coord; coord.longitude = randLong; coord.latitude = randLat;
    report.location = coord;
    
    return report;
}
@end
