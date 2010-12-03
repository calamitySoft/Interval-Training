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
	
	IBOutlet UILabel *intervalLabel;		// big "Listen" or "<interval>" label
	IBOutlet UIButton *intervalReplayBtn;	// invisible button atop intervalLabel to replayNote:
	
	IBOutlet UIBarButtonItem *replayBarBtn;
	IBOutlet UIBarButtonItem *nextOrGiveUpBarBtn;
	IBOutlet UIBarButtonItem *doneBarBtn;
	
	IBOutlet UIButton *switchAnswerLeftBtn;
	IBOutlet UIButton *switchAnswerRightBtn;
	IBOutlet UILabel *currentAnswerLabel;
	// helps determine if we should switch questions
	NSArray *oldDifficulty;

	
	NSArray *intervalStrings;
	NSUInteger intervalPickerIndex;	// accompanies currentAnswerLabel. This is an int of the current interval answer.
									// NOTE:	intervalPickerIndex is the index in the enabledIntervalsByName array.
									//			The index in relation to intervalStrings (all intervals) is figured
									//				immediately before submitting the answer.
}

@property (nonatomic, assign) <ITApplicationDelegate> delegate;
@property (nonatomic, retain) NSArray *oldDifficulty;

- (IBAction)showSettings:(id)sender;		// flips to the settings view
- (IBAction)showInstructions:(id)sender;	// repops the instruction alert
- (IBAction)replayNote:(id)sender;			// replays the root note of the interval
- (IBAction)giveUp:(id)sender;				// displays the interval
- (IBAction)nextNote:(id)sender;			// tells delegate to generate another interval question
- (IBAction)submitAnswer:(id)sender;		// answers with the interval displayed
- (IBAction)separate:(id)sender;			// plays the notes seperately
- (IBAction)switchAnswerLeft:(id)sender;	// sets the user's tentative answer
- (IBAction)switchAnswerRight:(id)sender;	// sets the user's tentative answer
- (void)resetArrowVisibility;				// rechecks and sets answer picker arrows
- (void)setOptionTextToIntervalIndex:(NSUInteger)intervalIndex;	// wrapper for easy answer option setting

- (void)displayInterval:(NSString *)theInterval;	// sets the big label of MainView.xib
- (void) goToNextQuestion;	// goes to the next question. can be used from anywhere - ex. nextNote:, flipsideViewControllerDidFinish:

- (IBAction)printDifficulty:(id)sender;

- (void)setEnabledRoot:(NSString*)str;	// passes along to AppDelegate
- (NSString*)enabledRoot;	// gets from AppDelegate

@end



@protocol ITApplicationDelegate

- (void)generateQuestion;
- (void)replayNote;
- (int)getCurrentInterval;
- (void)printDifficulty;
- (void)arrpegiate;
- (BOOL)intervalIsEnabled:(NSUInteger)distance;
- (NSString *)intervalDifferenceBetween:(NSNumber *)first And:(NSNumber *)second;
- (NSString *)getScoreString;
- (BOOL)submitAnswer:(NSUInteger)intervalGuessed;

@property (nonatomic, retain) NSNumber *iCurRoot;
@property (nonatomic, retain) NSNumber *iCurTarget;
@property (nonatomic, retain) NSString *enabledRoot;

@end