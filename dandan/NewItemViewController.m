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
@synthesize contentTextView;
@synthesize toolbar, buttons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initToolbarItems{
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];    
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithTitle:@"Image" style:UIBarButtonItemStylePlain target:self action:@selector(handleImage)];
    UIBarButtonItem *voiceItem = [[UIBarButtonItem alloc] initWithTitle:@"Voice" style:UIBarButtonItemStylePlain target:self action:@selector(handleVoice)];
    UIBarButtonItem *geoItem   = [[UIBarButtonItem alloc] initWithTitle:@"Map"   style:UIBarButtonItemStylePlain target:self action:@selector(handleLocation)];
    UIBarButtonItem *keyboardItem   = [[UIBarButtonItem alloc] initWithTitle:@"Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(handleKeyboard)];
    buttons = [NSArray arrayWithObjects: imageItem, geoItem, voiceItem, flexible, keyboardItem, nil];
    [self.toolbar setItems:buttons animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    [self initToolbarItems];
}

- (void)viewDidUnload
{
    [self setToolbar:nil];
    [self setContentTextView:nil];
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

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect frame;
    
    // 更改工具栏的位置
    frame = self.toolbar.frame;
    frame.origin.y =  kbFrame.origin.y - self.toolbar.frame.size.height - 64;
    [self.toolbar setFrame:frame];
    
    // 更改文本框的位置
    frame = self.contentTextView.frame;
    frame.size.height = self.toolbar.frame.origin.y;
    [self.contentTextView setFrame:frame];
}

- (void)print:(NSString *)whose frame:(CGRect)frame{
    NSLog(@"%@ %f %f %f %f", whose, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

- (void)handleKeyboard{
    if ([self.contentTextView isFirstResponder]) {
        [self.contentTextView resignFirstResponder];
    } else {
        [self.contentTextView becomeFirstResponder];
    }
}
@end
