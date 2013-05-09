//
//  VOViewController.m
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-05.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOViewController.h"
#import <MapKit/MapKit.h>
#import "VOReportViewController.h"


@interface VOViewController ()
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation VOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFirstLocation];
	// Do any additional setup after loading the view, typically from a nib.
}

-(CLLocationManager*)locationManager{
    if (!_locationManager) _locationManager = [[CLLocationManager alloc]init];
    return _locationManager;
}

#pragma mark - location handling
-(void)getFirstLocation{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
}

-(void)centerMap:(CLLocation*)location{
    
    CLLocationCoordinate2D centerCoordinate = location.coordinate;
    //    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(45.51, -73.57);
    MKCoordinateSpan centerSpan = MKCoordinateSpanMake(.2, .2);
    MKCoordinateRegion centerRegion = MKCoordinateRegionMake(centerCoordinate, centerSpan);
    self.mapView.region = centerRegion;
    
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    NSLog(@"mapview received location: %@", location);
    [self centerMap:location];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

#define REPORT_SEGUE @"reportSegue"

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([[segue identifier]isEqualToString:REPORT_SEGUE]){
//         UINavigationController* vc = [segue destinationViewController];
//        VOReportViewController* reportVC = (VOReportViewController*)[vc topViewController];
////        change locationManager delegate to our report VC
////        set locationmanager accuracy to high for reporting & start update fetching
//        reportVC.locationManager = self.locationManager;
//        self.locationManager.delegate = reportVC;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        [self.locationManager startUpdatingLocation];
//
//    }
//}

- (IBAction)reportAction:(UIBarButtonItem *)sender {
}
@end
