//
//  NewListTableViewController.h
//  dandan
//
//  Created by  on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickCategoryTableViewController.h"

@interface NewListTableViewController : UITableViewController
<UITextFieldDelegate, CategoryPickerDelegate>
- (IBAction)SaveList:(id)sender;
- (IBAction)CancelModal:(id)sender;
@property (strong, nonatomic) UITextField *listNameTextField;
@property (strong, nonatomic) UISwitch *isShare;
@property NSInteger selectedCategoryIndex;
@property (strong, nonatomic) NSString *categoryName;
@end
