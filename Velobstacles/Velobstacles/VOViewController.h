//
//  VOViewController.h
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-05.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class MKMapView;
@interface VOViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)reportAction:(UIBarButtonItem *)sender;

//debug
@property (weak, nonatomic) IBOutlet UILabel *debugLabel;
@end
