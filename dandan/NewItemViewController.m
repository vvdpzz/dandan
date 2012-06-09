//
//  NewItemViewController.m
//  dandan
//
//  Created by  on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewItemViewController.h"

@interface NewItemViewController ()

@end

@implementation NewItemViewController

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)CancelModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)SaveItem:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
