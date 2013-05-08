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
    self.report = [VOReport testReport];
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

//#define INFO_CELL_ID @"Info Cell"
//#define CATEGORY_CELL_ID @"category"
//#define DESCRIPTION_CELL_ID @"description"
//#define PHOTO_CELL_ID @"photo"
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
        cell.textLabel.text = self.report.category;
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 1){
       VODescriptionCell* cell = (VODescriptionCell*)[tableView dequeueReusableCellWithIdentifier:descCellID];
        cell.textLabel.text = self.report.description;
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
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
@end
