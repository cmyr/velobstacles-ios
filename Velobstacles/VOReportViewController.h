//
//  VOReportViewController.h
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-07.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOCategoryListVC.h"

@interface VOReportViewController : UITableViewController <VOCategoryTableViewDelegate>

- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)submitAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@end
