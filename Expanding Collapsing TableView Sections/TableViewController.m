//
//  TableViewController.m
//  Expanding and Collapsing TableView Sections
//
//  Created by Fabrice Masachs on 22/03/16.
//  Copyright © 2016 Fabrice Masachs. All rights reserved.
//

#import "TableViewController.h"
#import "CustomColoredAccessory.h"
#import "DetailViewController.h"

@interface TableViewController ()

@property NSMutableArray *objects;

@end

@implementation TableViewController

- (void)viewDidLayoutSubviews
{
    if ([NSIndexPath indexPathForRow:0 inSection:0] || [NSIndexPath indexPathForRow:0 inSection:1] || [NSIndexPath indexPathForRow:0 inSection:2]) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    } else {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (!expandedSections) {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section {
    if (section >= 0) return YES;
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self tableView:tableView canCollapseSection:section]) {
        if ([expandedSections containsIndex:section]) {
            return 5; // return rows when expanded
        }
    }
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    /*
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     */
    
    // Configure the cell...
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {
        if (!indexPath.row) {
            // First row
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Expandable cell %ld", (long)indexPath.section]; // only top row showing
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:16];
            cell.textLabel.textColor = [UIColor whiteColor];
            
            cell.backgroundColor = [UIColor darkGrayColor];
            
            if ([expandedSections containsIndex:indexPath.section]) {
                cell.accessoryView = [CustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:CustomColoredAccessoryTypeTriangleDown];
            } else {
                cell.accessoryView = [CustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:CustomColoredAccessoryTypeTriangleRight];
            }
        } else {
            // All the other rows
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Section %ld", (long)indexPath.section];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            cell.textLabel.textColor = [UIColor blackColor];
            
            cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:10];
            cell.detailTextLabel.textColor = [UIColor grayColor];
            
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else {
        // Normal rows
        /*
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         
         cell.accessoryView = nil;
         cell.textLabel.text = @"Normal Cell";
         */
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {
        if (!indexPath.row) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        } else {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {
        if (!indexPath.row) {
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded) {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            } else {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++) {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                               inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded) {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                cell.accessoryView = [CustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:CustomColoredAccessoryTypeTriangleRight];
            } else {
                NSLog(@"%@", expandedSections);
                
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                cell.accessoryView =  [CustomColoredAccessory accessoryWithColor:[UIColor whiteColor] type:CustomColoredAccessoryTypeTriangleDown];
            }
        } else {
            [self performSegueWithIdentifier:@"showDetail" sender:self];
            
            NSLog(@"Selected Section %ld - Row %ld ", (long)indexPath.section , (long)indexPath.row);
        }
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *detailViewController = [segue destinationViewController];
        
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        //UITableViewCell *selectedCell = (UITableViewCell *)sender;
        
        detailViewController.cellData = [NSString stringWithFormat:@"Segue from %@ - %@", selectedCell.textLabel.text, selectedCell.detailTextLabel.text];
    }
}

@end