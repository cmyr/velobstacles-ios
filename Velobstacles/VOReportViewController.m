
 //
//  VOReportViewController.m
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-07.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOReportViewController.h"
#import "VOViewController.h"
#import "VOReport.h"
#import "VOServerHandler.h"


@interface VOReportViewController ()
@property (strong, nonatomic) VOReport* report;
@property (strong, nonatomic) UIImagePickerController* imagePicker;
@property (strong, nonatomic) CLLocation* location;


@end

@implementation VOReportViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.report = [[VOReport alloc]init];
    self.report.timestamp = [NSDate date];
//    CLLocationCoordinate2D coord;
//    coord.longitude = ((arc4random() % 500)*0.0001f) + -73.6;
//    coord.latitude = ((arc4random() % 400)*0.0001f) + 45.49;
//    self.report.location = coord;
    self.descriptionText.delegate = self;
//    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:self.report.timestamp
                                                         dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    [self startLocationManager];
}

//lazy instantiators
-(CLLocationManager*)locationManager{
    if (!_locationManager) _locationManager = [[CLLocationManager alloc]init];
    return _locationManager;
}

-(UIImagePickerController*)imagePicker
{
	if (!_imagePicker) _imagePicker = [[UIImagePickerController alloc]init];
	return _imagePicker;
}

//check to see if we have a valid reoprt
-(void)validateReportContents{
    BOOL reportValid = YES;
    if (!self.report.category || [self.report.category isEqualToString:@""]) reportValid = NO;
//TODO: add location validation
    if (reportValid){
        [self enableSubmission:YES];
    }else{
        [self enableSubmission:NO];
    }

}

//enable/disable the submission button
-(void)enableSubmission:(BOOL)flag{
    if (flag){
        self.submitButtonCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.submitButtonLabel.textColor = [UIColor blackColor];
    }else{
        self.submitButtonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.submitButtonLabel.textColor = [UIColor grayColor];
    }
}

-(void)submitReport{
    //TODO: if report doesn't include some fields, show alert
    [VOServerHandler postReport:self.report];
    //probably show a spinner or something?
    [self dismissSelf];
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self dismissSelf];
}

-(void)dismissSelf{
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark - Table view data source

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
        [self descriptionEditingFinished];
        [self performSegueWithIdentifier:CATEGORY_SEGUE sender:self];
    }else if (indexPath.section == 1 && indexPath.row == 1){
//        [self performSegueWithIdentifier:DESCRIPTION_SEGUE sender:self];
        [self.descriptionText becomeFirstResponder];
        
    }else if (indexPath.section == 1 && indexPath.row == 2){
        [self descriptionEditingFinished];
        [self showImagePickerActionSheet];
    }else if ([indexPath isEqual:[tableView indexPathForCell:self.submitButtonCell]]){
        [self submitReport];
    }
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
    if (self.descriptionText.isFirstResponder){
        [self.descriptionText resignFirstResponder];
        if ([self.descriptionText.text isEqualToString:@""]){
            self.descriptionText.text = @"Description";
        }else{
            self.report.description = self.descriptionText.text;
        }
        [self.navBar setRightBarButtonItem:nil animated:NO];
    }
    [self validateReportContents];
}

//used for selecting our category
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:CATEGORY_SEGUE]){
        VOCategoryListVC* vc = (VOCategoryListVC*)[segue destinationViewController];
        vc.delegate = self;
    }
}

//VOCategoryTableViewDelegate method:
-(void)categoryRecieved:(NSString *)category{
    self.report.category = category;
    self.categoryLabel.text = category;
    [self validateReportContents];
}

#define CAMERA_TITLE_STRING @"From Camera"
#define PHOTOPICKER_TITLE_STRING @"From Photo Roll"

-(void)showImagePickerActionSheet{
    UIActionSheet* imagePickerActionSheet = [[UIActionSheet alloc]initWithTitle:@"Add Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:CAMERA_TITLE_STRING, PHOTOPICKER_TITLE_STRING, nil];
    [imagePickerActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString* action = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ([action isEqualToString:CAMERA_TITLE_STRING]){
		[self takePhoto];
	}else if ([action isEqualToString:PHOTOPICKER_TITLE_STRING]){
		[self choosePhoto];
    }
}

-(void)takePhoto
{
    
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		[self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
		[self.imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
		self.imagePicker.allowsEditing = YES;
	}
	else{
		[self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		self.imagePicker.allowsEditing = YES;
	}
	[self.imagePicker setDelegate:self];
	[self presentViewController:self.imagePicker animated:YES completion:NULL];
}

-(void)choosePhoto
{
	[self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	[self.imagePicker setDelegate:self];
	[self presentViewController:self.imagePicker animated:YES completion:NULL];
	self.imagePicker.allowsEditing = YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
	[self dismissModalViewControllerAnimated:YES];
    self.report.image = [self scaledImageForImage:info[@"UIImagePickerControllerEditedImage"]];
    self.photoLabel.hidden = YES;
    self.changePhotoLabel.hidden = NO;
    self.photoImageView.image = self.report.image;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - location handling

-(void)startLocationManager{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    if (location.horizontalAccuracy < self.location.horizontalAccuracy) self.location = location;
    NSLog(@"report recieved location: %@ accuracy: %g", location, location.horizontalAccuracy);
    if (self.location.horizontalAccuracy <= 10){
//        desired accuracy: stop location updating
        self.locationManager.delegate = nil;
        [self.locationManager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error domain] == kCLErrorDomain) {
        switch ([error code]){
            case kCLErrorLocationUnknown: NSLog(@"%@",error); break;
            case kCLErrorDenied:
                [manager stopUpdatingLocation];
                self.location = nil;
                [self locationManagerFailed];
                //handling location == nil in report validation?
                //TODO: see if we want to do this differently
                break;
            default:
                NSLog(@"other location manager error: %@",error);
        }
    }
    
}

-(void)locationManagerFailed{
//    TODO: check if it's an authorization problem or not?
    //and then show an alert or something probably
}
    

#pragma mark - helper methods

#define TARGET_EDGE_LENGTH 800.0
//resizing uiimages:
- (UIImage*)scaledImageForImage:(UIImage*)image
{
    //no idea why resizing UIImages is still this involved
    CGFloat edge, scale;
    edge = image.size.width > image.size.height ? image.size.width : image.size.height;
    if (edge > TARGET_EDGE_LENGTH) return image;
    scale = TARGET_EDGE_LENGTH / edge;
    CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidUnload {
    [self setDateLabel:nil];
    [self setCategoryLabel:nil];
    [self setPhotoLabel:nil];
    [self setPhotoImageView:nil];
    [self setDescriptionText:nil];
    [self setNavBar:nil];
    [self setChangePhotoLabel:nil];
    [self setSubmitButtonCell:nil];
    [self setSubmitButtonLabel:nil];
    [super viewDidUnload];
}

@end
