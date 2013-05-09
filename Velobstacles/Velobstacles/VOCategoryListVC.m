//
//  VOCategoryListVC.m
//  Velobstacles
//
//  Created by Colin Rothfels on 13-05-08.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOCategoryListVC.h"
#import "VOReport.h"
@interface VOCategoryListVC ()
@property (strong, nonatomic) NSDictionary* categories;
@end

@implementation VOCategoryListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.categories = [VOReport categories];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"categoryListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.categories objectForKey:[NSNumber numberWithUnsignedInteger:indexPath.row]];
    if ([cell.textLabel.text isEqualToString:[[self.delegate report]categoryString]]) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate categoryRecieved:[NSNumber numberWithInteger:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];

}

//-(NSString*)categoryForIndexPath:(NSIndexPath *)indexPath{
//    NSNumber *key = [NSNumber numberWithUnsignedInteger:indexPath.row];
//    return self.categories[key];
//}

@end
