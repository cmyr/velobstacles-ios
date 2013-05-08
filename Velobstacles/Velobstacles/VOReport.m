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

//returns a dictionary categories mapped to their id n°s
+(NSDictionary*)categories{
    NSDictionary* categories = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Éclairage insuffisant",%'0',
                                @"Qualité de la chaussée", %'1',
                                @"Piste cyclable discontinue", %'2',
                                @"Piste cyclable nonexistante", %'3',
                                @"Chantier", %'4',
                                @"voiture(s) stationnée(e)", %'5',
                                nil];
    return categories;
}

+(VOReport*)testReport
{
   
    VOReport* report = [[VOReport alloc]init];
    //generate a random coordinate:
    CLLocationCoordinate2D coord;
    coord.longitude = ((arc4random() % 500)*0.0001f) + -73.6;
    coord.latitude = ((arc4random() % 400)*0.0001f) + 45.49;
    report.location = coord;
    report.timestamp = [NSDate date];
    report.category = [NSString stringWithFormat:@"This Bike Path Sucks"];
    report.description = @"and so after all of this time it came to pass that many strange things had happened, and we decided ultimately to let it wash away, like dust in early rains, this mess we'd made of life";
    return report;
}


@end
