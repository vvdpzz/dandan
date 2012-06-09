//
//  PickCategoryTableViewController.m
//  dandan
//
//  Created by  on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PickCategoryTableViewController.h"
#import "NewListTableViewController.h"

@interface PickCategoryTableViewController ()

@end

@implementation PickCategoryTableViewController
@synthesize delegate, categories;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.categories = [[NSArray alloc] initWithObjects:@"科技", @"电影", @"艺术", @"音乐", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger row = [indexPath row];
    cell.textLabel.text = [categories objectAtIndex:row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate SelectedCategory:[categories objectAtIndex:[indexPath row]]];
    NewListTableViewController *newListTableViewController = [[NewListTableViewController alloc]init];
    newListTableViewController.selectedCategoryIndex = [indexPath row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
