//
//  VOReportViewController.h
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-07.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOCategoryListVC.h"

@interface VOReportViewController : UITableViewController <VOCategoryTableViewDelegate, UITextViewDelegate>

- (IBAction)cancelAction:(UIBarButtonItem *)sender;
//- (IBAction)submitAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

// cell outlets
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end
