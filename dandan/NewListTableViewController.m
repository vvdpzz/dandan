//
//  NewListTableViewController.m
//  dandan
//
//  Created by  on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewListTableViewController.h"
#import "PickCategoryTableViewController.h"

@interface NewListTableViewController ()

@end

@implementation NewListTableViewController
@synthesize listNameTextField, isShare, selectedCategoryIndex, categoryName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    
    if (row == 0) {
        listNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 11, 300, 30.0f)];
        listNameTextField.borderStyle = UITextBorderStyleNone;
        listNameTextField.placeholder = @"列表名称";
        listNameTextField.font = [UIFont systemFontOfSize:16];
        listNameTextField.returnKeyType = UIReturnKeyDone;
        listNameTextField.delegate = self;
        [cell addSubview:listNameTextField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [listNameTextField becomeFirstResponder];
    } else if (row == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"类别";
        cell.detailTextLabel.text = @"请选择";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        isShare = [[UISwitch alloc] initWithFrame:CGRectZero];
        isShare.on = YES;
        cell.textLabel.text = @"分享";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = isShare;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    UIImageView *separatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, cell.frame.size.height-1.0f, cell.frame.size.width, 1.0f)];
    separatorLine.image = [[UIImage imageNamed:@"dot"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [cell.contentView addSubview:separatorLine];
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.listNameTextField resignFirstResponder];
	return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row == 1) {
        PickCategoryTableViewController *detailViewController = [[PickCategoryTableViewController alloc] init];
        detailViewController.delegate = self;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - CategoryPickerDelegate
- (void)SelectedCategory:(NSString *)category{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailTextLabel.text = category;
    categoryName = category;
}

- (IBAction)SaveList:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)CancelModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
