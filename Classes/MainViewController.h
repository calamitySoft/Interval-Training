//
//  MainViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@protocol ITApplicationDelegate;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	id <ITApplicationDelegate> delegate;
	IBOutlet UILabel *intervalLabel;
}

@property (nonatomic, assign) <ITApplicationDelegate> delegate;

- (IBAction)showInfo:(id)sender;
- (IBAction)giveUp:(id)sender;
- (IBAction)replayNote:(id)sender;

- (void)displayInterval:(NSString *)theInterval;

- (void)setDifficulty:(char)theDiff;

@end



@protocol ITApplicationDelegate
- (void)replayNote;
- (void)setDifficulty:(char)theDiff;
@end