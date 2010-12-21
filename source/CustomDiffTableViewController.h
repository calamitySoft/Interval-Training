//
//  CustomDiffTableViewController.h
//  OTG-Chords
//
//  Created by Logan Moseley on 11/22/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDiffTableViewController : UITableViewController {
	NSArray					*dataSourceArray;
	NSArray					*switches;
	IBOutlet UITableView	*table;
}

@property (nonatomic, retain, readonly) NSArray *dataSourceArray;
@property (nonatomic, retain, readonly) NSArray *switches;

@end