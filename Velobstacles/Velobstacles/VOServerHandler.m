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

#define BASE_URL @"http://api.velobstacles.com"

@implementation VOServerHandler

//fetches a list of reports from the server for a given lat/long/rad
//returns reports as an NSArray
+(NSArray*)reportsForLocation:(CLLocationCoordinate2D)location radius:(CLLocationDistance)radius
{
    NSString* queryString = [NSString stringWithFormat:@"/media/lat=%g&long=%g&rad=%g",
                   location.latitude,
                   location.longitude,
                   radius];

    NSDictionary* queryResult = [self fetchQuery:queryString];
    return queryResult[@"data"];
}

// fetches an image for a given report
+(UIImage*)imageForReport:(NSNumber *)reportID format:(VOImageFormat)format
{
    return nil;
}

// posts a new report
+(void)postReport:(id)report
{
    
}

#pragma mark helper methods

+ (NSDictionary*)fetchQuery:(NSString*)query
{
    query = [NSString stringWithFormat:@"%@%@", BASE_URL, query];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil];
    NSError* error = nil;
    NSDictionary* results = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error){
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        return nil;
    }
    return results;
}

@end
