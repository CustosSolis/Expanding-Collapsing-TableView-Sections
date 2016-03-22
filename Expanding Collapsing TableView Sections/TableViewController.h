//
//  TableViewController.h
//  Expanding and Collapsing TableView Sections
//
//  Created by Fabrice Masachs on 22/03/16.
//  Copyright © 2016 Fabrice Masachs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController {
    NSMutableIndexSet *expandedSections;
}

@end