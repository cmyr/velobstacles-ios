//
//  VOReportViewController.h
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-07.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOCategoryListVC.h"
#import <CoreLocation/CoreLocation.h>

extern BOOL DEBUG_MODE;

@interface VOReportViewController : UITableViewController <VOCategoryTableViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CLLocationManagerDelegate>

- (IBAction)cancelAction:(UIBarButtonItem *)sender;
@property (strong, nonatomic) VOReport* report;
@property (strong, nonatomic) CLLocationManager* locationManager;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
// cell outlets
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePhotoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UITableViewCell *categoryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *photoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *submitButtonCell;
@property (weak, nonatomic) IBOutlet UILabel *submitButtonLabel;

@end
