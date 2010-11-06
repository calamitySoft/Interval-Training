//
//  RootOptionViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 11/4/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PagingViewController : UIViewController {
    UILabel *pageNumberLabel;
    int pageNumber;
}

@property (nonatomic, retain) IBOutlet UILabel *pageNumberLabel;

- (id)initWithPageNumber:(int)page;

@end
