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
	IBOutlet UIButton *replayButton;
	IBOutlet UIButton *nextOrGiveUpButton;
}

@property (nonatomic, assign) <ITApplicationDelegate> delegate;

- (IBAction)showInfo:(id)sender;	// flips to the settings view
- (IBAction)replayNote:(id)sender;	// replays the root note of the interval
- (IBAction)giveUp:(id)sender;		// displays the interval
- (IBAction)nextNote:(id)sender;    // tells delegate to generate another interval question

- (void)displayInterval:(NSString *)theInterval;	// sets the big label of MainView.xib

- (void)setDifficulty:(char)theDiff;	// tells the delegate to setDifficulty:

@end



@protocol ITApplicationDelegate
- (void)generateQuestion;
- (void)replayNote;
- (void)setDifficulty:(char)theDiff;
- (NSString *)intervalDifferenceBetween:(NSNumber *)first And:(NSNumber *)second;

@property (nonatomic, retain) NSNumber *iCurRoot;
@property (nonatomic, retain) NSNumber *iCurTarget;

@end