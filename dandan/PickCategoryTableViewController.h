//
//  PickCategoryTableViewController.h
//  dandan
//
//  Created by  on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryPickerDelegate <NSObject>
-(void)SelectedCategory:(NSString *)category;
@end

@interface PickCategoryTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *categories;
@property (nonatomic, weak) id <CategoryPickerDelegate> delegate;
@end
