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
	
	IBOutlet UINavigationBar *scoreBar;
	IBOutlet UINavigationItem *scoreTextItem;

	IBOutlet UILabel *devHelpLabel;		// ** dev help ** //
	IBOutlet UIButton *printDiffBtn;	// ** dev help ** //
	
	IBOutlet UILabel *intervalLabel;
	
	IBOutlet UIBarButtonItem *replayBarBtn;
	IBOutlet UIBarButtonItem *nextOrGiveUpBarBtn;
	IBOutlet UIBarButtonItem *doneBarBtn;
	
	IBOutlet UIButton *switchAnswerLeftBtn;
	IBOutlet UIButton *switchAnswerRightBtn;
	IBOutlet UILabel *currentAnswerLabel;	// actually a UIButton because they look better
	
	NSArray *intervalStrings;
	NSUInteger intervalPickerIndex;	// accompanies currentAnswerLabel. This is an int of the current interval answer.
}

@property (nonatomic, assign) <ITApplicationDelegate> delegate;

- (IBAction)showSettings:(id)sender;	// flips to the settings view
- (IBAction)replayNote:(id)sender;	// replays the root note of the interval
- (IBAction)giveUp:(id)sender;		// displays the interval
- (IBAction)nextNote:(id)sender;    // tells delegate to generate another interval question
- (IBAction)submitAnswer:(id)sender;	// answers with the interval displayed

- (IBAction)switchAnswerLeft:(id)sender;	// sets the user's tentative answer
- (IBAction)switchAnswerRight:(id)sender;	// sets the user's tentative answer
- (void)setOptionText:(NSUInteger)intervalIndex;	// wrapper for easy answer option setting

- (void)displayInterval:(NSString *)theInterval;	// sets the big label of MainView.xib
- (void) goToNextQuestion;	// goes to the next question. can be used from anywhere - ex. nextNote:, flipsideViewControllerDidFinish:

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