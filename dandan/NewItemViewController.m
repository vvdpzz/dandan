//
//  NewItemViewController.m
//  dandan
//
//  Created by  on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewItemViewController.h"
#import "NewGeoViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIColor+UIColor_Hex.h"

#import "PreviewViewController.h"

@interface NewItemViewController ()
static UIImage *shrinkImage(UIImage *original, CGSize size);
- (void)updateDisplay;
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType;
@end

@implementation NewItemViewController
@synthesize contentTextView;
@synthesize toolbar, buttons;
@synthesize lastChosenMediaType, image, imageSelected;
@synthesize geoInfoView,items;

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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    [self initToolbarItems];
    
    // 变量初始化
    self.imageSelected = false;
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

- (void)handleImage{
    [self pickPhotoByActionSheet];
}

-(void)pickPhotoByActionSheet{
    UIActionSheet *uploadImageActionSheet;
    if (self.imageSelected) {
        uploadImageActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"删除所选照片", @"查看所选照片", nil];
        uploadImageActionSheet.tag = 14;
    } else {
        uploadImageActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"选取现有的", nil];
        uploadImageActionSheet.tag = 16;
    }
    [uploadImageActionSheet showInView:self.view];
}

- (void)previewImage{
    PreviewViewController *previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"previewViewController"];
    previewVC.image = self.image;
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case 14:
            if (buttonIndex == [actionSheet cancelButtonIndex]) {
                [contentTextView becomeFirstResponder];
            } else {
                switch (buttonIndex) {
                    case 0:
                        NSLog(@"选择删除所选照片");
                        [self clearImage];
                        break;
                    case 1:
                        NSLog(@"选择查看所选照片");
                        [self previewImage];
                        break;
                    default:
                        break;
                }
            }
            break;
        case 16:
            if (buttonIndex == [actionSheet cancelButtonIndex]) {
                [contentTextView becomeFirstResponder];
            } else {
                switch (buttonIndex) {
                    case 0:
                        NSLog(@"选择拍照");
                        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
                        break;
                    case 1:
                        NSLog(@"选择选取现有的");
                        [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
                        break;
                    default:
                        break;
                }
            }
            break;
        default:
            break;
    }
}

- (void)clearImage{
    self.image = nil;
    self.imageSelected = NO;
    
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithTitle:@"Image" style:UIBarButtonItemStylePlain target:self action:@selector(handleImage)];
    NSMutableArray *items = [self.buttons mutableCopy];
    [items replaceObjectAtIndex:0 withObject:imageItem];
    [self.toolbar setItems:items animated:NO];
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

// Image Processor
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *shrunkenImage = shrinkImage(chosenImage, CGSizeMake(310, 310));
        self.image = shrunkenImage;
        self.imageSelected = YES;
    }
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

static UIImage *shrinkImage(UIImage *original, CGSize size){
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width*scale, size.height*scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width*scale, size.height*scale), original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    CGContextRelease(context);
    CGImageRelease(shrunken);
    
    return final;
}

- (void)updateDisplay{
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [button addTarget:self action:@selector(handleImage) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *sublayer = [button layer];
        sublayer.backgroundColor = [UIColor blueColor].CGColor;
        sublayer.shadowOffset = CGSizeMake(0, 0);
        sublayer.shadowRadius = 3.0;
        sublayer.shadowColor = [UIColor blackColor].CGColor;
        sublayer.shadowOpacity = 0.8;
        sublayer.frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15,30,30);
        sublayer.cornerRadius = 15;
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = sublayer.bounds;
        imageLayer.cornerRadius = 15.0;
        imageLayer.contents = (id) image.CGImage;
        imageLayer.borderWidth = 1;
        imageLayer.borderColor = [UIColor whiteColorWithAlpha:0.7].CGColor;
        imageLayer.masksToBounds = YES;
        [sublayer addSublayer:imageLayer];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        NSMutableArray *items = [self.buttons mutableCopy];
        
        [items replaceObjectAtIndex:0 withObject:barButtonItem];
        [self.toolbar setItems:items animated:NO];
    }
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error accessing media"
                              message:@"Device doesn't support that media source."
                              delegate:nil
                              cancelButtonTitle:@"Drat!"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)useLastPhotoTaken{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
     usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
         // Within the group enumeration block, filter to enumerate just photos.
         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
         
         // Chooses the photo at the last index
         [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1]
                                 options:0
                              usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                  // The end of the enumeration is signaled by asset == nil.
                                  if (alAsset) {
                                      ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                      UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                                      
                                      self.image = latestPhoto;
                                      self.imageSelected = YES;
                                  }
                              }];
     }
     failureBlock: ^(NSError *error) {
         // Typically you should handle an error more gracefully than this.
         NSLog(@"No groups");
     }];
}

// Call Geo
-(void)handleLocation 
{
    if (geoInfoView != nil) {
        NSLog(@"the view is there!");
        UIActionSheet *addGeoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                         destructiveButtonTitle:nil
                                                              otherButtonTitles:@"重新选择位置信息", nil];
        [addGeoActionSheet showInView:self.view];
    } else {
        NewGeoViewController *geoView =[self.storyboard instantiateViewControllerWithIdentifier:@"NewGeoViewController"];
        geoView.theNewGeoDelegate = self;
        [self.navigationController pushViewController:geoView animated:YES];
    }    
}

- (void)controller:(NewGeoViewController *)controller geoInfo:(NSString *)geoInfo
{
    geoInfoView = [[UIView alloc] initWithFrame:CGRectMake(self.toolbar.frame.origin.x+10,self.toolbar.frame.origin.y-20,260,20)];
    
    UILabel *geoInfoLabel = [[UILabel alloc]initWithFrame:geoInfoView.frame];
    geoInfoLabel.backgroundColor = [UIColor  colorWithRed: 240/255.0 green: 248/255.0 blue:250/255.0 alpha: 1.0];
    //    240,248,255
    geoInfoLabel.text = [NSString stringWithFormat:@"位置:%@",geoInfo];
    [self.view addSubview:geoInfoLabel];
}

- (void)controller:(NewGeoViewController *)controller geoImage:(UIImage *)geoImage
{
    UIImageView *imageToMove = [[UIImageView alloc] initWithImage:geoImage];
    imageToMove.frame = CGRectMake(self.toolbar.frame.origin.x+200,self.toolbar.frame.origin.y+5, 30, 30);
    [self.view addSubview:imageToMove];
    
    // Move the image
    [self moveImage:imageToMove duration:1.0 curve:UIViewAnimationCurveLinear x:-50.0 y:0.0];  
    
    UIButton *composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [composeButton setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
    [composeButton addTarget:self action:@selector(addGeoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *sublayer = [composeButton layer];
    sublayer.backgroundColor = [UIColor blueColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 0);
    sublayer.shadowRadius = 3.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.8;
    sublayer.frame = CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height/2-15,30,30);
    sublayer.cornerRadius = 15;
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = sublayer.bounds;
    imageLayer.cornerRadius = 15.0;
    imageLayer.contents = (id) geoImage.CGImage;
    imageLayer.borderWidth = 1;
    imageLayer.borderColor = [UIColor whiteColorWithAlpha:0.7].CGColor;
    imageLayer.masksToBounds = YES;
    [sublayer addSublayer:imageLayer];
    
    UIBarButtonItem *composePost = [[UIBarButtonItem alloc] initWithCustomView:composeButton];
    [items replaceObjectAtIndex:2 withObject:composePost];
    [self.toolbar setItems:items animated:NO];
}

- (void)moveImage:(UIImageView *)images duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    images.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}
@end
