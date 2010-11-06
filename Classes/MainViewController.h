//
//  MainViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "PageControlDelegate.h"

@protocol ITApplicationDelegate;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, PageControlDelegateDelegate> {
	id <ITApplicationDelegate> delegate;
	
	// Score bar @ top
	IBOutlet UINavigationBar *scoreBar;
	IBOutlet UINavigationItem *scoreTextItem;

	IBOutlet UILabel *devHelpLabel;		// ** dev help ** //
	IBOutlet UIButton *printDiffBtn;	// ** dev help ** //
	
	// Output
	IBOutlet UILabel *intervalLabel;
	
	// Answer/interval control bar
	IBOutlet UIBarButtonItem *replayBarBtn;
	IBOutlet UIBarButtonItem *nextOrGiveUpBarBtn;
	IBOutlet UIBarButtonItem *doneBarBtn;
	
	// Answering
	IBOutlet UIButton *switchAnswerLeftBtn;
	IBOutlet UIButton *switchAnswerRightBtn;
	IBOutlet UIButton *currentAnswerLabel;	// actually a UIButton because they look better
	PageControlDelegate *answerPickingDelegate;
	
	NSArray *intervalStrings;
	NSUInteger intervalPickerIndex;	// accompanies currentAnswerLabel. This is a uint of the current interval answer.
}

@property (nonatomic, assign) <ITApplicationDelegate> delegate;
@property (nonatomic, retain) IBOutlet PageControlDelegate *answerPickingDelegate;

- (IBAction)showSettings:(id)sender;	// flips to the settings view
- (IBAction)replayNote:(id)sender;	// replays the root note of the interval
- (IBAction)giveUp:(id)sender;		// displays the interval
- (IBAction)nextNote:(id)sender;    // tells delegate to generate another interval question
- (IBAction)submitAnswer:(id)sender;	// answers with the interval displayed

// This and [startAtPage:] in my setDifficulty: take care of answer picking.
- (void)changedPageTo:(NSUInteger)newPage;	// invoked by the PageControlDelegate upon page changing

- (void)displayInterval:(NSString *)theInterval;	// sets the big label of MainView.xib

- (void)setDifficulty:(char)theDiff;	// tells the delegate to setDifficulty:
- (char)cDifficulty;	// get the difficulty from the delegate
- (IBAction)printDifficulty:(id)sender;

- (void)setEnabledRoot:(NSString*)str;	// passes along to AppDelegate
- (NSString*)enabledRoot;	// gets from AppDelegate

@end



@protocol ITApplicationDelegate

- (void)generateQuestion;
- (void)replayNote;
- (int)getCurrentInterval;
- (void)setDifficulty:(char)theDiff;
- (void)printDifficulty;
- (BOOL)intervalIsEnabled:(NSUInteger)distance;
- (NSString *)intervalDifferenceBetween:(NSNumber *)first And:(NSNumber *)second;
- (NSString *)getScoreString;
- (BOOL)submitAnswer:(NSUInteger)intervalGuessed;

@property (nonatomic, retain) NSNumber *iCurRoot;
@property (nonatomic, retain) NSNumber *iCurTarget;
@property char cDifficulty;
@property (nonatomic, retain) NSString *enabledRoot;

@end