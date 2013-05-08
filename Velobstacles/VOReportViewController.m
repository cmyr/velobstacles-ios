//
//  VOReportViewController.m
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-07.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOReportViewController.h"
#import "VOReport.h"
#import "VOInfoCell.h"
#import "VOCategoryCell.h"
#import "VODescriptionCell.h"
#import "VOPhotoCell.h"


@interface VOReportViewController ()
@property (strong, nonatomic) VOReport* report;
@end

@implementation VOReportViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.report = [VOReport testReport];
        //TODO: this is for testing
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.report = [VOReport testReport];
    self.report = [[VOReport alloc]init];
    self.report.timestamp = [NSDate date];
    CLLocationCoordinate2D coord;
    coord.longitude = ((arc4random() % 500)*0.0001f) + -73.6;
    coord.latitude = ((arc4random() % 400)*0.0001f) + 45.49;
    self.report.location = coord;
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    switch (section) {
        case 0: return 1; break;
        case 1: return 3; break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *infoCellID = @"info";
    static NSString *catCellID = @"category";
    static NSString *descCellID = @"description";
    static NSString *photoCellID = @"photo";

    NSLog(@"%@",indexPath);
    if (indexPath.section == 0) {
       VOInfoCell* cell = (VOInfoCell*)[tableView dequeueReusableCellWithIdentifier:infoCellID];
        cell.dateLabel.text = [self.report.timestamp descriptionWithLocale:[NSLocale currentLocale]];
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0){
       VOCategoryCell* cell = (VOCategoryCell*)[tableView dequeueReusableCellWithIdentifier:catCellID];
        if (self.report.category) cell.textLabel.text = self.report.category;
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 1){
       VODescriptionCell* cell = (VODescriptionCell*)[tableView dequeueReusableCellWithIdentifier:descCellID];
       if (self.report.description) cell.textLabel.text = self.report.description;
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 2){
       VOPhotoCell* cell = (VOPhotoCell*)[tableView dequeueReusableCellWithIdentifier:photoCellID];
        return cell;
    }
    NSLog(@"indexPath not handled in cellForRowAtIndexPath?");
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 44.0;
    if (indexPath.section == 1 && indexPath.row == 1) cellHeight = 96.0;
    if (indexPath.section == 1 && indexPath.row == 2) cellHeight = 128.0;
    return cellHeight;
}


#pragma mark - Table view delegate
#define CATEGORY_SEGUE @"categorySegue"
#define DESCRIPTION_SEGUE @"descriptionSegue"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 1 && indexPath.row == 0){
        [self performSegueWithIdentifier:CATEGORY_SEGUE sender:self];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [self performSegueWithIdentifier:DESCRIPTION_SEGUE sender:self];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        //handle media picking here
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)submitAction:(UIBarButtonItem *)sender {
}
- (void)viewDidUnload {
    [self setSubmitButton:nil];
    [super viewDidUnload];
}

#pragma mark - segues and report delegates


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:CATEGORY_SEGUE]){
        VOCategoryListVC* vc = (VOCategoryListVC*)[segue destinationViewController];
        vc.delegate = self;
    }
}

-(void)categoryRecieved:(NSString *)category{
    self.report.category = category;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
