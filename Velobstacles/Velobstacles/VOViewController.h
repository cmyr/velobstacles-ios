//
//  VOViewController.h
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-05.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@interface VOViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)reportAction:(UIBarButtonItem *)sender;
@end
