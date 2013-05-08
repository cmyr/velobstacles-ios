//
//  VODescriptionEntryVC.m
//  Velobstacles
//
//  Created by Colin Rothfels on 13-05-08.
//  Copyright (c) 2013 Velobstacles. All rights reserved.
//

#import "VODescriptionEntryVC.h"

@interface VODescriptionEntryVC ()

@end

@implementation VODescriptionEntryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setText:nil];
    [super viewDidUnload];
}
@end
