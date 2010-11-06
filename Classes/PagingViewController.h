//
//  RootOptionViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 11/4/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PagingViewController : UIViewController {
	UILabel *rootStringLabel;
	NSString *rootStr;
}

@property (nonatomic, retain) IBOutlet UILabel *rootStringLabel;
@property (nonatomic, retain) NSString *rootStr;

- (id)initWithString:(NSString*)_string;

@end
