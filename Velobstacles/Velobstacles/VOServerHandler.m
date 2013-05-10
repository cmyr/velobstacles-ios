//
//  VOServerHandler.m
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-06.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOServerHandler.h"
// #import "SimpleHTTPRequest.h"
#import "VOReport.h"

@interface VOServerHandler ()


@end

#define BASE_URL @"http://api.velobstacles.com/media"

@implementation VOServerHandler

//fetches a list of reports from the server for a given lat/long/rad
//returns reports as an NSArray
+(NSArray*)reportsForRegion:(CLRegion *)region
{
    if (DEBUG_MODE){
        return [self reportsForDebugging];
    }else{
    NSMutableDictionary* args = [NSMutableDictionary dictionary];
    args[VO_LATITUDE] = [NSString stringWithFormat:@"%g", region.center.latitude];
    args[VO_LONGITUDE] = [NSString stringWithFormat:@"%g", region.center.longitude];
    args[VO_RADIUS] = [NSString stringWithFormat:@"%g", region.radius];
    return [self fetchQueryWithArgs:args][@"data"];
    }
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
#define REPORTS_KEY @"reports"
#define TEST_FILEPATH @"com.cmyr.velobstacles.testdata1"

+(void)postReport:(VOReport*)report
{
    if (DEBUG_MODE){
        //this is going to get ugly
        //retrieve user defaults:
        NSMutableArray* reportsArray = [[self class]reportsForDebugging];
        [reportsArray addObject:report];
        //archive data after adding report? sure.
        NSString* mypath  = [NSString stringWithFormat:@"%@/%@",
                             [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask,
                                                                  YES) lastObject],
                             TEST_FILEPATH];
        [NSKeyedArchiver archiveRootObject:reportsArray toFile:mypath];
    }else{
//        handle whatever we'd normally do with a report
    }


    
}

#pragma mark - DEBUG local data storage

+(NSMutableArray*)reportsForDebugging{
 //returns a singleton array that will hold our report objects
    static NSMutableArray* debugReports;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* mypath  = [NSString stringWithFormat:@"%@/%@",
                             [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask,
                                                                  YES) lastObject],
                             TEST_FILEPATH];
        NSLog(@"%@", mypath);
//        [NSKeyedArchiver archiveRootObject:report toFile:mypath];
        debugReports = [NSKeyedUnarchiver unarchiveObjectWithFile:mypath];
        if (!debugReports) debugReports = [NSMutableArray array];
    });
        
    return debugReports;
}

#pragma mark tests
+ (NSDictionary*)getTest{
    return [self fetchQueryWithArgs:nil];
}

//+ (void)postTest{
//    VOReport* report = [VOReport testReport];
//    UIImage* anImage = [UIImage imageNamed:@"pothole.jpg"];
//    NSDictionary* submission = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [NSString stringWithFormat:@"%g",report.location.latitude],
//                                @"latitude",
//                                [NSString stringWithFormat:@"%g", report.location.longitude],
//                                @"longitude",
//                                UIImageJPEGRepresentation(anImage, 1.0),
//                                @"content",
//                                nil];
//    NSURLRequest* request = [SimpleHTTPRequest multipartRequestWithURL:[NSURL URLWithString:BASE_URL]
//                                     andMethod:@"POST"
//                             andDataDictionary:submission];
//    
//    NSURLResponse* response = nil;
//    NSError* error = nil;
//    [NSURLConnection sendSynchronousRequest:request
//                          returningResponse:&response
//                                      error:&error];
//}

+ (UIImage*)getImageTest{
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
