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
+(void)postReport:(NSDictionary*)report
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:BASE_URL]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
}

#pragma mark tests

+ (NSDictionary*)getTest{
    return [self fetchQueryWithArgs:nil];
}

+(UIImage*)getImageTest{
    NSDictionary* args = [NSDictionary dictionaryWithObject:@"/5118fe5ab821d90005c1a24d/content" forKey:@"string"];
    
    NSDictionary* results = [self fetchQueryWithArgs:args];
    NSLog(@"%@", results);
    //    return [UIImage imageWithData:results[@"photo"]];
//    return nil;
//    return [UIImage imageWithData:imgData];
    return nil;
}

#pragma mark helper methods

// takes a dictionary of API arguments, returns an NSDictionary with results
+ (NSDictionary*)fetchQueryWithArgs:(NSDictionary*)args 
{
    // if we only have one argument treat it as a string
    // else treat key/obj pairs as "k=o" arguments
    NSMutableString* queryArgs = [[NSMutableString alloc]init];
    if (args.count == 1){
        queryArgs = [args allValues][0];
    }else{
        NSArray* keys = [args allKeys];
        for (NSString* key in keys){
            [queryArgs appendFormat:@"%@=%@&", key, args[key]];
        }
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
    return (NSDictionary*)results;
}

@end
