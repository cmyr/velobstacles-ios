//
//  VOServerHandler.m
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-06.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOServerHandler.h"

@interface VOServerHandler ()


@end

#define BASE_URL @"http://api.velobstacles.com/media"

@implementation VOServerHandler

//fetches a list of reports from the server for a given lat/long/rad
//returns reports as an NSArray
+(NSArray*)reportsForLocation:(CLLocationCoordinate2D)location radius:(CLLocationDistance)radius
{
    NSMutableDictionary* args = [NSMutableDictionary dictionary];
    args[VO_LATITUDE] = [NSString stringWithFormat:@"%g", location.latitude];
    args[VO_LONGITUDE] = [NSString stringWithFormat:@"%g", location.longitude];
    args[VO_RADIUS] = [NSString stringWithFormat:@"%g", radius];
    return [self fetchQueryWithArgs:args][@"data"];
//    return queryResult[@"data"];
}

// fetches an image for a given report
+(UIImage*)imageForReport:(NSNumber *)reportID format:(VOImageFormat)format
{
    NSString* formatString = @"r";
    switch (format) {
        case VOImageFormatThumb:    formatString = @"t"; break;
        case VOImageFormatNormal:   formatString = @"r"; break;
    }
    NSMutableDictionary* args = [NSMutableDictionary dictionary];
    args[VO_ID] = [reportID stringValue];
    args[VO_FORMAT] = formatString;
    
    //    get NSData representation of image
    NSData* imgData = [self fetchQueryWithArgs:args][@"photo"];
    return [UIImage imageWithData:imgData];
}

// posts a new report
+(void)postReport:(id)report
{
    
}
#pragma mark tests

+ (NSDictionary*)getTest{
    return [self fetchQueryWithArgs:nil];
}

#pragma mark helper methods

// takes a dictionary of API arguments, returns an NSDictionary with results
+ (NSDictionary*)fetchQueryWithArgs:(NSDictionary*)args
{
    NSMutableString* queryArgs = [[NSMutableString alloc]init];
    NSArray* keys = [args allKeys];
    for (NSString* key in keys){
        [queryArgs appendFormat:@"%@=%@&", key, args[key]];
    }
   NSString* query = [NSString stringWithFormat:@"%@%@", BASE_URL, queryArgs];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query]
                                                 encoding: NSUTF8StringEncoding
                                                    error:nil]
                        dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSDictionary* results = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error){
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        return nil;
    }
    return results;
}

@end
