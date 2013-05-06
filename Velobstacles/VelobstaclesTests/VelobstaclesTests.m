//
//  VelobstaclesTests.m
//  VelobstaclesTests
//
//  Created by Colin Rothfels on 2013-05-05.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VelobstaclesTests.h"
#import "VOServerHandler.h"
#import <CoreLocation/CoreLocation.h>
@implementation VelobstaclesTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in VelobstaclesTests");
}

-(void)testFetch
{
    NSDictionary* dict = [VOServerHandler getTest];
    NSArray* data = dict[@"data"];
    
    for (id obj in data){
        NSLog(@"%@", obj);
    }
    
    STAssertNotNil(dict, @"fetching dictionary from server");
}

//-(void)testStringFormater
//{
//    CLLocationCoordinate2D coord;
//    coord.longitude = -73.5;
//    coord.latitude = 45.5;
//    
//    CLLocationDistance dist = 500;
//    
//    NSString* target = [NSString stringWithFormat:@"http://api.velobstacles.com/media/lat=45.5&long=-73.5&rad=500"];
//    NSString* result = [VOServerHandler reportsForLocation:coord radius:dist];
//    NSLog(@"%@,%@",target,result);
//    STAssertTrue([target isEqualToString:result], @"string testing");
//
//    
//    
//}
@end
