//
//  VOViewController.m
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-05.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOMapViewController.h"
#import "VOReportViewController.h"
#import "VOReport.h"
#import "VOServerHandler.h"



@interface VOMapViewController ()
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) NSArray* reportsArray;
@property (strong, nonatomic) CLRegion* reportsRegion; // the region for which we've retrieved reports
@end

@implementation VOMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getFirstLocation];
    self.mapView.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

-(CLLocationManager*)locationManager{
    if (!_locationManager) _locationManager = [[CLLocationManager alloc]init];
    return _locationManager;
}

-(void)setReportsArray:(NSArray *)reportsArray{
    _reportsArray = reportsArray;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.reportsArray];
}
//-(void)setAnnotations{
//    if (DEBUG_MODE){
//        [self.mapView removeAnnotations:[self.mapView annotations]];
//        [self.mapView addAnnotations:[[VOServerHandler reportsForDebugging]copy]];
//        NSLog(@"added %lu annotations", (unsigned long)[self.mapView.annotations count]);
//        NSLog(@"%@", self.mapView.annotations);
//              }else{
////        actually populate locations somehow
//    }
//}

#pragma mark - location handling
-(void)getFirstLocation{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
}

-(void)centerMap:(CLLocation*)location{
    
    CLLocationCoordinate2D centerCoordinate = location.coordinate;
    MKCoordinateSpan centerSpan = MKCoordinateSpanMake(.1, .1);
    MKCoordinateRegion centerRegion = MKCoordinateRegionMake(centerCoordinate, centerSpan);
    self.mapView.region = centerRegion;
    
}

#define INITIAL_REGION_RADIUS 5000.0 //metres
#define INITIAL_REGION_IDENTIFIER @"initial region"

-(void)getInitialReports{
    //retrieve reports for an initial area.
    //this is a pretty bad way of doing report fetching (we should be working from local
//    data) but for now it will work. To make it more responsive, we'll initially fetch
    // a fairly large area.
    self.reportsRegion = [[CLRegion alloc]initCircularRegionWithCenter:self.location.coordinate radius:INITIAL_REGION_RADIUS identifier:INITIAL_REGION_IDENTIFIER];
//    TODO: this will need to be a callback
    self.reportsArray = [VOServerHandler reportsForRegion:self.reportsRegion];
//    for debug:
    NSLog(@"added %lu annotations", (unsigned long)[self.mapView.annotations count]);
    NSLog(@"%@", self.mapView.annotations);
}

-(void)debugCenterMap:(CLLocation*)location{
    
    CLLocationCoordinate2D centerCoordinate = location.coordinate;
    //    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(45.51, -73.57);
    MKCoordinateSpan centerSpan = MKCoordinateSpanMake(.02, .02);
    MKCoordinateRegion centerRegion = MKCoordinateRegionMake(centerCoordinate, centerSpan);
    self.mapView.region = centerRegion;
    
}

#pragma mark - MKMapViewDelegate methods & related
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
// we need to check if we already have data points for the new region, or not.
    //this is a convoluted way of getting our top left and bottom right corner coordinates
    if (!self.reportsRegion) return;
    // return if we haven't set our initial region yet.
    MKMapRect mapRect = mapView.visibleMapRect;
    CLLocationCoordinate2D origin = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D corner = MKCoordinateForMapPoint(MKMapPointMake(mapRect.origin.x + mapRect.size.width, mapRect.origin.y + mapRect.size.height));
    
    if ([self.reportsRegion containsCoordinate:origin] && [self.reportsRegion containsCoordinate:corner]){
        NSLog(@"new region contained in existing reportsRegion");
    }else{
//        we need to fetch new reports for the new region;
        CLLocationDistance radius = MKMetersBetweenMapPoints(mapRect.origin, MKMapPointForCoordinate(mapView.centerCoordinate)) *2;
        // double radius to load nearby reports while we're at it;
        self.reportsRegion = [[CLRegion alloc]initCircularRegionWithCenter:mapView.centerCoordinate radius:radius identifier:INITIAL_REGION_IDENTIFIER];
        NSLog(@"fetching reports for new region: %g, %g, %f",self.reportsRegion.center.latitude, self.reportsRegion.center.longitude, self.reportsRegion.radius);
        self.reportsArray = [VOServerHandler reportsForRegion:self.reportsRegion];
    }
}

#pragma mark - CLLocationManagerDelegate

#define LOCATION_DEBUGGING_FLAG 0
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    //FIXME: this is messy because of debugging
    if (!self.location){
        self.location = location;
        [self centerMap:self.location];
        //check to see if we have set a reportsRegion yet
        if (!self.reportsRegion){
            [self getInitialReports];
        }
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

}
@end
