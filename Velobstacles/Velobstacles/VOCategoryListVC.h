//
//  VOCategoryListVC.h
//  Velobstacles
//
//  Created by Colin Rothfels on 13-05-08.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VOReport;

@protocol VOCategoryTableViewDelegate <NSObject>
-(void)selectionDidFinishWithCategory:(NSString*)category;
-(VOReport*)report;
//@property (strong, nonatomic) VOReport *report;
@end

@interface VOCategoryListVC : UITableViewController
@property (weak, nonatomic) id<VOCategoryTableViewDelegate> delegate;
@end
