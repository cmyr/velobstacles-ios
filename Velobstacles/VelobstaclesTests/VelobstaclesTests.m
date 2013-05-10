//
//  VelobstaclesTests.m
//  VelobstaclesTests
//
//  Created by Colin Rothfels on 2013-05-05.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VelobstaclesTests.h"
#import "VOServerHandler.h"
#import "VOReport.h"
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

//-(void)testFetch
//{
//    NSDictionary* dict = [VOServerHandler getTest];
//    NSArray* data = dict[@"data"];
//    
//    for (id obj in data){
//        NSLog(@"%@", obj);
//    }
//    
//    STAssertNotNil(dict, @"fetching dictionary from server");
//}

//-(void)testImageFetch
//{
//    UIImage* anImage = [VOServerHandler getImageTest];
//    STAssertNotNil(@"rups", @"cheating hi");
//}

-(void)testDataPersistence{
    NSMutableArray* reportsArray = [VOServerHandler reportsForDebugging];
    STAssertTrue((!reportsArray.count), @"reports array starts empty");
    VOReport* aReport = [VOReport testReport];
    [VOServerHandler postReport:aReport];
    reportsArray = [VOServerHandler reportsForDebugging];
    STAssertTrue((reportsArray.count == 1), @"reports array count == 1");
    VOReport* anotherReport = [aReport copy];
    [VOServerHandler postReport:anotherReport];
    STAssertTrue((reportsArray.count == 2), @"reports array count == 2");
    
}
-(void)testReportCopying{
    VOReport* report = [VOReport testReport];
    VOReport* reportCopy = [report copy];
    
    STAssertEqualObjects(report.category, reportCopy.category, @"report category copy equality");
    STAssertEquals(report.coordinate, reportCopy.coordinate, @"report coordinate copy equality");
    STAssertTrue([report.description isEqualToString:reportCopy.description], @"report description copy equality");
    STAssertEqualObjects(report.timestamp, reportCopy.timestamp, @"report timestampe copy equality");
//    STAssertEqualObjects(report.reportImage, reportCopy.reportImage, @"report image copy equality");
    
    UIImageWriteToSavedPhotosAlbum(reportCopy.reportImage, nil, nil, nil);

    
    
}

-(void)testSingleton
{
    NSDictionary *dictOne, *dictTwo;
    dictOne = [VOReport categories];
    dictTwo = [VOReport categories];
    STAssertEqualObjects(dictOne, dictTwo, @"singletons working");

}
#define TEST_FILEPATH @"test_file_path"
//-(void)testReportCoding
//{
//    VOReport* report = [VOReport testReport];
//    NSFileManager* manager = [NSFileManager defaultManager];
//    NSError* error;
//    NSURL *filepath = [manager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:[NSURL URLWithString:@"velotests"] create:YES error:&error];
//    NSURL *fuckingURL = [filepath URLByAppendingPathComponent:@"AREYOUFUCKINGHAPPYNOW"];
//    NSLog(@"%@", fuckingURL);
    
//    NSString* mypath  = [NSString stringWithFormat:@"%@/%@",
//                          [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                              NSUserDomainMask,
//                                                              YES) lastObject],
//                          TEST_FILEPATH];
//    NSLog(@"%@", mypath);
//    STAssertTrue([NSKeyedArchiver archiveRootObject:report toFile:mypath], @"archive success?");
//    VOReport *undeadReport = [NSKeyedUnarchiver unarchiveObjectWithFile:mypath];
//    STAssertTrue(undeadReport, @"unarchive successful?");
//    STAssertEqualObjects(report, undeadReport, @"reports equal?");
//    
    
//}

//-(void)testPost
//{
//    [VOServerHandler postTest];
//}

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
