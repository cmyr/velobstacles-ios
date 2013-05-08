//
//  VODescriptionEntryVC.h
//  Velobstacles
//
//  Created by Colin Rothfels on 13-05-08.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VODescriptionDelegateProtocol <NSObject>

-(void)descriptionReceived:(NSString*)description;

@end
@interface VODescriptionEntryVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *text;
@end
