#import "SideSwipeTableViewCell.h"

@implementation SideSwipeTableViewCell
@synthesize supressDeleteButton;

-(UITableView*)getTableView:(UIView*)theView
{
  if (!theView.superview)
    return nil;
  
  if ([theView.superview isKindOfClass:[UITableView class]])
    return (UITableView*)theView.superview;
  
  return [self getTableView:theView.superview];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  if (supressDeleteButton){
    UITableView* tableView = [self getTableView:self];
    tableView.editing = NO;
  }
  else
    [super setEditing:editing animated:animated];
}

@end
