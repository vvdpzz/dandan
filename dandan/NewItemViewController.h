//
//  NewItemViewController.h
//  dandan
//
//  Created by  on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewGeoViewController.h"

@interface NewItemViewController : UIViewController
<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,NewGeoDelegate>
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSArray *buttons;
- (IBAction)CancelModal:(id)sender;
- (IBAction)SaveItem:(id)sender;

// Image Processor
@property (strong, nonatomic) NSString *lastChosenMediaType;
@property (strong, nonatomic) UIImage *image;
@property BOOL imageSelected;

// Geo
@property(strong, nonatomic) UIView *geoInfoView;
@end
