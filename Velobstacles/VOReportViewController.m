
 //
//  VOReportViewController.m
//  Velobstacles
//
//  Created by Colin Rothfels on 2013-05-07.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VOReportViewController.h"
#import "VOReport.h"



@interface VOReportViewController ()
@property (strong, nonatomic) VOReport* report;
@property (strong, nonatomic) UIImagePickerController* imagePicker;
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
}

-(UIImagePickerController*)imagePicker
{
	if (!_imagePicker) _imagePicker = [[UIImagePickerController alloc]init];
	return _imagePicker;
}

-(void)validateReportContents{
    BOOL reportValid = YES;
    if (!self.report.category) reportValid = NO;
    if (reportValid){
        //enable submission
    }else{
        //disable submission 
    }

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
    }
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
    if (self.descriptionText.isFirstResponder){
        [self.descriptionText resignFirstResponder];
        if ([self.descriptionText.text isEqualToString:@""]){
            self.descriptionText.text = @"Description";
        }else{
            self.report.description = self.descriptionText.text;
        }
        [self.navBar setRightBarButtonItem:nil animated:NO];
    }
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
    
//    self.photoImageView.frame = [[self.photoImageView superview] frame];
    //    if (self.report.image.size.width < self.photoImageView.bounds.size.width){
//    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
//    }else{
//    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
    //    [self newPatternFromImagePickerInfo:info];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#define TARGET_EDGE_LENGTH 800.0
//resizing uiimages:
- (UIImage*)scaledImageForImage:(UIImage*)image
{
    CGFloat edge, scale;
    edge = image.size.width > image.size.height ? image.size.width : image.size.height;
    if (edge > TARGET_EDGE_LENGTH) return image;
    scale = TARGET_EDGE_LENGTH / edge;
    CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
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
    [super viewDidUnload];
}

@end
