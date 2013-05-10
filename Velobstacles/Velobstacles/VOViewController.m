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
#import "VOReport.h"
#import "VOServerHandler.h"



@interface VOViewController ()
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSArray* reportsArray;
@end

@implementation VOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFirstLocation];
    [self setAnnotations];
	// Do any additional setup after loading the view, typically from a nib.
}

-(CLLocationManager*)locationManager{
    if (!_locationManager) _locationManager = [[CLLocationManager alloc]init];
    return _locationManager;
}

-(void)setAnnotations{
    if (DEBUG_MODE){
        [self.mapView removeAnnotations:[self.mapView annotations]];
        [self.mapView addAnnotations:[[VOServerHandler reportsForDebugging]copy]];
        NSLog(@"added %lu annotations", (unsigned long)[self.mapView.annotations count]);
        NSLog(@"%@", self.mapView.annotations);
              }else{
//        actually populate locations somehow
    }
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
    MKCoordinateSpan centerSpan = MKCoordinateSpanMake(.1, .1);
    MKCoordinateRegion centerRegion = MKCoordinateRegionMake(centerCoordinate, centerSpan);
    self.mapView.region = centerRegion;
    
}

-(void)debugCenterMap:(CLLocation*)location{
    
    CLLocationCoordinate2D centerCoordinate = location.coordinate;
    //    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(45.51, -73.57);
    MKCoordinateSpan centerSpan = MKCoordinateSpanMake(.02, .02);
    MKCoordinateRegion centerRegion = MKCoordinateRegionMake(centerCoordinate, centerSpan);
    self.mapView.region = centerRegion;
    
}

#pragma mark - CLLocationManagerDelegate

#define LOCATION_DEBUGGING_FLAG 0
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    //FIXME: this is messy because of debugging
    if (!self.location){
        self.location = location;
        [self centerMap:self.location];
    }
    if (!LOCATION_DEBUGGING_FLAG){
        self.locationManager.delegate = nil;
        [self.locationManager stopUpdatingLocation];
        NSLog(@"mapview received location: %@", self.location);
    }else{
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        CLLocationCoordinate2D coord = location.coordinate;
        self.debugLabel.text = [NSString stringWithFormat:@"lat:%g long:%g acc:%g", coord.latitude, coord.longitude, location.horizontalAccuracy];
        [self debugCenterMap:location];
        VOReport* rep = [[VOReport alloc]init];
        rep.coordinate = coord;
        [self.mapView removeAnnotations:[self.mapView annotations]];
        [self.mapView addAnnotation:rep];
    }
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setDebugLabel:nil];
    [super viewDidUnload];
}

#define REPORT_SEGUE @"reportSegue"


- (IBAction)reportAction:(UIBarButtonItem *)sender {
    if (DEBUG_MODE) {
        [self.mapView removeAnnotations:[self.mapView annotations]];
        [self.mapView addAnnotations:[[VOServerHandler reportsForDebugging]copy]];
    }
}
@end
