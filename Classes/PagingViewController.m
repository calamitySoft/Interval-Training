//
//  RootOptionViewController.m
//  Interval-Training
//
//  Created by Logan Moseley on 11/4/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "PagingViewController.h"

@implementation PagingViewController

@synthesize rootStringLabel, rootStr;

// Load the view nib and initialize the pageNumber ivar.
- (id)initWithString:(NSString*)_string {
    if (self = [super initWithNibName:@"PagingView" bundle:nil]) {
        rootStr = _string;
    }
	
    return self;
}

- (void)dealloc {
    [rootStringLabel release];
	[rootStr release];
    [super dealloc];
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
    rootStringLabel.text = rootStr;
}

@end