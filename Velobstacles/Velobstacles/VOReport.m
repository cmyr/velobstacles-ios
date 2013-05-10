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
    static NSDictionary* categories;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       //block for setting up our categories dictionary;
        categories = @{
                       @0: @"Éclairage insuffisant",
                       @1: @"Qualité de la chaussée",
                       @2: @"Piste cyclable discontinue",
                       @3: @"Piste cyclable nonexistante",
                       @4: @"Chantier",
                       @5: @"voiture(s) stationnée(e)"};

    });
    
    return categories;
}

+(VOReport*)testReport
{
   
    VOReport* report = [[VOReport alloc]init];
    //generate a random coordinate:
    CLLocationCoordinate2D coord;
    coord.longitude = ((arc4random() % 500)*0.0001f) + -73.6;
    coord.latitude = ((arc4random() % 400)*0.0001f) + 45.49;
    report.coordinate = coord;
    report.timestamp = [NSDate date];
    report.category = @2;
    report.description = @"and so after all of this time it came to pass that many strange things had happened, and we decided ultimately to let it wash away, like dust in early rains, this mess we'd made of life";
    report.image = [UIImage imageNamed:@"pothole.jpg"];
    return report;
}

-(NSString*)categoryString{
    return [[VOReport categories]objectForKey:self.category];
}

#pragma mark - NSCoding protocol methods

#define REPORT_ID_KEY @"report key"
#define TIMESTAMP_KEY @"timestamp key"
#define CATEGORY_KEY @"category key"
#define COORDINATE_KEY @"coordinate key"
#define LAT_KEY @"lat key"
#define LONG_KEY @"long key"
#define DESCRIPTION_KEY @"description key"
#define IMAGE_KEY @"image key"



-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.reportID forKey:REPORT_ID_KEY];
    [coder encodeObject:self.timestamp forKey:TIMESTAMP_KEY];
    [coder encodeObject:self.category forKey:CATEGORY_KEY];
//    [coder encodeObject:[NSValue valueWithMKCoordinate:self.coordinate] forKey:COORDINATE_KEY];
    [coder encodeDouble:self.coordinate.latitude forKey:LAT_KEY];
    [coder encodeDouble:self.coordinate.longitude forKey:LONG_KEY];
    [coder encodeObject:self.description forKey:DESCRIPTION_KEY];
    [coder encodeObject:self.image forKey:IMAGE_KEY];
    
}

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self) {
        _reportID = [decoder decodeObjectForKey:REPORT_ID_KEY];
        _timestamp = [decoder decodeObjectForKey:TIMESTAMP_KEY];
        _category = [decoder decodeObjectForKey:CATEGORY_KEY];
//        _coordinate = [(NSValue*)[decoder decodeObjectForKey:COORDINATE_KEY]MKCoordinateValue];
        _coordinate = CLLocationCoordinate2DMake([decoder decodeDoubleForKey:LAT_KEY], [decoder decodeDoubleForKey:LONG_KEY]);
        _description = [decoder decodeObjectForKey:DESCRIPTION_KEY];
        _image = [decoder decodeObjectForKey:IMAGE_KEY];
    }
    return self;
}
@end
