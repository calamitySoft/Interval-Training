//
//  CustomDiffTableViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 11/22/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDiffTableViewController : UITableViewController {
	NSArray		*dataSourceArray;
}

@property (nonatomic, retain, readonly) NSArray *dataSourceArray;

@end