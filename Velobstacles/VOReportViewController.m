
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
    self.report = [[VOReport alloc]init];
    self.report.timestamp = [NSDate date];
    CLLocationCoordinate2D coord;
    coord.longitude = ((arc4random() % 500)*0.0001f) + -73.6;
    coord.latitude = ((arc4random() % 400)*0.0001f) + 45.49;
    self.report.location = coord;

    self.descriptionText.delegate = self;
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:self.report.timestamp
                                                         dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source
/*
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
////#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    switch (section) {
//        case 0: return 1; break;
//        case 1: return 3; break;
//    }
//    return 0;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *infoCellID = @"info";
//    static NSString *catCellID = @"category";
//    static NSString *descCellID = @"description";
//    static NSString *photoCellID = @"photo";
//
//    NSLog(@"%@",indexPath);
//    if (indexPath.section == 0) {
//       VOInfoCell* cell = (VOInfoCell*)[tableView dequeueReusableCellWithIdentifier:infoCellID];
//        cell.dateLabel.text = [self.report.timestamp descriptionWithLocale:[NSLocale currentLocale]];
//        return cell;
//    }else if (indexPath.section == 1 && indexPath.row == 0){
//       VOCategoryCell* cell = (VOCategoryCell*)[tableView dequeueReusableCellWithIdentifier:catCellID];
//        if (self.report.category) cell.textLabel.text = self.report.category;
//        return cell;
//    }else if (indexPath.section == 1 && indexPath.row == 1){
//       VODescriptionCell* cell = (VODescriptionCell*)[tableView dequeueReusableCellWithIdentifier:descCellID];
//       if (self.report.description) cell.textLabel.text = self.report.description;
//        return cell;
//    }else if (indexPath.section == 1 && indexPath.row == 2){
//       VOPhotoCell* cell = (VOPhotoCell*)[tableView dequeueReusableCellWithIdentifier:photoCellID];
//        return cell;
//    }
//    NSLog(@"indexPath not handled in cellForRowAtIndexPath?");
//    return nil;
//}
*/

#define DEFAULT_CELL_HEIGHT 44.0
#define DESCRIPTION_CELL_HEIGHT 96.0
#define PHOTO_CELL_HEIGHT 128.0
#define CELL_PADDING 16.0
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = DEFAULT_CELL_HEIGHT;
    if (indexPath.section == 1 && indexPath.row == 1){
       CGFloat calculated_height = [self heightForTextView:self.descriptionText containingString:self.report.description];
        cellHeight = DESCRIPTION_CELL_HEIGHT >  calculated_height ? DESCRIPTION_CELL_HEIGHT : calculated_height + CELL_PADDING;
    }
    if (indexPath.section == 1 && indexPath.row == 2) cellHeight = PHOTO_CELL_HEIGHT;
    return cellHeight;
}


#pragma mark - Table view delegate
#define CATEGORY_SEGUE @"categorySegue"
#define DESCRIPTION_SEGUE @"descriptionSegue"

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section == 1 && indexPath.row == 0){
        [self.descriptionText resignFirstResponder];
        [self performSegueWithIdentifier:CATEGORY_SEGUE sender:self];
    }else if (indexPath.section == 1 && indexPath.row == 1){
//        [self performSegueWithIdentifier:DESCRIPTION_SEGUE sender:self];
        [self.descriptionText becomeFirstResponder];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        [self.descriptionText resignFirstResponder];
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


#pragma mark - segues and report delegates

-(void)textViewDidBeginEditing:(UITextView *)textView{
//    show the done button, clear the textview if our report text is blank;
    if ([self.report.description isEqualToString:@""] || !self.report.description) self.descriptionText.text = @"";
    self.navBar.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(descriptionEditingFinished)];
}

//text view delegate methods:
- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
{
    //helping with resizing our description text field as the user enters input
    // simple solution courtesy of http://www.howlin-interactive.com/2013/01/creating-a-self-sizing-uitextview-within-a-uitableviewcell-in-ios-6/
    if (string.length > 0){
        if ([[string substringFromIndex:(string.length -1)] isEqualToString:@"\n"]) {
            string = [string stringByAppendingString:@"B"];
        }
    }
    float horizontalPadding = 16;
    float verticalPadding = 16;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
}

-(void)textViewDidChange:(UITextView *)textView{
    //recalculate height of textview as it is edited;
    self.report.description = textView.text;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}
-(void)descriptionEditingFinished{
    [self.descriptionText resignFirstResponder];
    if ([self.descriptionText.text isEqualToString:@""]){
        self.descriptionText.text = @"Description";
    }else{
        self.report.description = self.descriptionText.text;
    }
    [self.navBar setRightBarButtonItem:nil animated:NO];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:CATEGORY_SEGUE]){
        VOCategoryListVC* vc = (VOCategoryListVC*)[segue destinationViewController];
        vc.delegate = self;
    }
}

-(void)categoryRecieved:(NSString *)category{
    self.report.category = category;
    self.categoryLabel.text = category;
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewDidUnload {
    [self setDateLabel:nil];
    [self setCategoryLabel:nil];
    [self setPhotoLabel:nil];
    [self setPhotoImageView:nil];
    [self setDescriptionText:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}

@end
