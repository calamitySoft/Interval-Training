//
//  MainViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@protocol ITApplicationDelegate;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	id <ITApplicationDelegate> delegate;
	IBOutlet UILabel *intervalLabel;
}

@property (nonatomic, assign) <ITApplicationDelegate> delegate;

- (IBAction)showInfo:(id)sender;
- (IBAction)replayNote:(id)sender;
- (void) setDifficulty:(char)theDiff;
- (void) displayInterval:(NSString *)theInterval;
@end



@protocol ITApplicationDelegate
- (void)replayNote;
@end