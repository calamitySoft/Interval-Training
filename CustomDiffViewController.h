//
//  CustomDiffViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 11/22/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDiffTableViewController.h"


@protocol CustomDiffViewControllerDelegate;


@interface CustomDiffViewController : UIViewController {
	id <CustomDiffViewControllerDelegate> delegate;
	
	IBOutlet CustomDiffTableViewController* tableController;
}

@property (nonatomic, assign) id <CustomDiffViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;

@end





@protocol CustomDiffViewControllerDelegate
- (void)customDiffViewControllerDidFinish:(CustomDiffViewController *)controller;
@end
