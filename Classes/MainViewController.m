//
//  MainViewController.m
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "MainViewController.h"
#import "Settings.h"



@implementation MainViewController

@synthesize delegate, oldDifficulty;

#define DEFAULT_ANSWER 4

// For knowing whether the nextOrGiveUpBarBtn should read
//	"Give Up" ..or.. "Separate" or "Together".
BOOL currentlyInGuessingState = YES;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	intervalStrings = [[NSArray alloc] initWithObjects:@"Unison", @"Minor Second", @"Major Second",
					   @"Minor Third", @"Major Third", @"Perfect Fourth", @"Tritone",
					   @"Perfect Fifth", @"Minor Sixth", @"Major Sixth", @"Minor Seventh",
					   @"Major Seventh", @"Octave", nil];
	intervalPickerIndex = DEFAULT_ANSWER;
	
	// REMOVE ME before launch
	// Show the answer in the top left
	[devHelpLabel setText:[NSString stringWithFormat:@"%@,\t\t%@,\t\t%@",		// help a dev out
						   [intervalStrings objectAtIndex:[delegate getCurrentInterval]],
						   [[Settings sharedSettings] currentDifficulty],
						   [self enabledRoot]]];
	
	// Make sure we have the initial difficulty set
	oldDifficulty = [[Settings sharedSettings] enabledIntervals];

#ifndef DEBUG
	[devHelpLabel setHidden:TRUE];
	[printDiffBtn setHidden:TRUE];
#endif
}
/**/


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	//	Check isArpeggiated for the correct button title
	[self checkIsArpeggiatedForGiveUpBtn];
}

- (void)viewDidAppear:(BOOL)animated {
	//
	//	Only if the difficulty has changed:
	//		Go to the next question.
	//		Reset answer picker.
	//
	if (![oldDifficulty isEqualToArray:[[Settings sharedSettings] enabledIntervals]]) {

		// store the old difficulty so we know if we need to get a new quesiton when we come back
		//		i'm not sure why this works.  i would've thought it'd simply copy the pointer, making
		//		the two array always equal
		oldDifficulty = [[Settings sharedSettings] enabledIntervals];
		
		[self goToNextQuestion];
		
		NSUInteger randomAnswer;
		do {
			// get a new random answer in integer form
			// while that answer is not enabled
			randomAnswer = arc4random()%[[[Settings sharedSettings] enabledIntervalsByName] count];
		} while (![[[[Settings sharedSettings] enabledIntervals] objectAtIndex:randomAnswer] boolValue]);
		
		[self setOptionTextToIntervalIndex:randomAnswer];	// coming back from settings screen, reset answer option
		
		[self resetArrowVisibility];
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Interface Elements

- (IBAction)showSettings:(id)sender {    
	
	// store the old difficulty so we know if we need to get a new quesiton when we come back
	//		i'm not sure why this works.  i would've thought it'd simply copy the pointer, making
	//		the two array always equal
	oldDifficulty = [[Settings sharedSettings] enabledIntervals];
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)showInstructions:(id)sender{
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: nil
						  message: @"Use the bottom half to select\nyour interval answer."
						  delegate: nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -

- (IBAction)giveUp:(id)sender {
	// Set UI stuff.
	//[nextOrGiveUpBarBtn setEnabled:FALSE];
	[doneBarBtn setTitle:@"Next"];							// let the Done button act as the Next button (==submitAnswer:)
	[doneBarBtn setAction:@selector(nextNote:)];
	currentlyInGuessingState = NO;							// no longer guessing
	[self checkIsArpeggiatedForGiveUpBtn];					// give the GiveUp btn the right title
	[nextOrGiveUpBarBtn setAction:@selector(separate:)];
	[delegate replayNote];									// reinforce the sound while showing the answer
	
	// Show the answer.
	[self displayInterval:[delegate intervalDifferenceBetween:[delegate iCurRoot] And:[delegate iCurTarget]]];
}

- (IBAction)nextNote:(id)sender {
	[self goToNextQuestion];
	currentlyInGuessingState = YES;							// back to guessing (quizzing) state
}

- (IBAction)replayNote:(id)sender {
	[delegate replayNote];
}

- (IBAction)separate:(id)sender{
	[delegate arrpegiate];
}

- (IBAction)submitAnswer:(id)sender {
	// Set Answer option bar stuff.
	[doneBarBtn setTitle:@"Next"];							// let the Done button act as the Next button (==giveUp:)
	[doneBarBtn setAction:@selector(nextNote:)];
	currentlyInGuessingState = NO;							// no longer guessing
	[self checkIsArpeggiatedForGiveUpBtn];					// give the GiveUp btn the right title
	[nextOrGiveUpBarBtn setAction:@selector(separate:)];
	[delegate replayNote];									// reinforce the sound while showing the answer
	
	
	// Show the answer.
	[self displayInterval:[intervalStrings objectAtIndex:[delegate getCurrentInterval]]];

	
	// Show whether the user got it right.
	NSString *tempAnswerString = [[[Settings sharedSettings] enabledIntervalsByName] objectAtIndex:intervalPickerIndex];
	NSUInteger tempAnswerIndex = [intervalStrings indexOfObject:tempAnswerString];
	if ([delegate submitAnswer:tempAnswerIndex]) {		// if our choice matches the interval being played
		[scoreTextItem setTitle:@"Correct!"];
		[scoreBar setTintColor:[UIColor colorWithRed:0 green:0.92 blue:0 alpha:1]];	// slightly dark shade of green
	}
	else {
		[scoreTextItem setTitle:@"Nope"];
		[scoreBar setTintColor:[UIColor redColor]];
	}

}

#pragma mark -

- (IBAction)switchAnswerLeft:(id)sender {
	
	// if we're currently after the first one
	if (intervalPickerIndex > 0) {
		intervalPickerIndex--;
		[self setOptionTextToIntervalIndex:intervalPickerIndex];
	}
	[self resetArrowVisibility];		// outside the IF just in case
}

- (IBAction)switchAnswerRight:(id)sender {
	
	// if we're currently before the last one
	if (intervalPickerIndex < [[Settings sharedSettings] numIntervalsEnabled]-1) {
		intervalPickerIndex++;
		[self setOptionTextToIntervalIndex:intervalPickerIndex];
	}
	[self resetArrowVisibility];		// outside the IF just in case
}

- (void)resetArrowVisibility {
	
	// if at first answer
	if (intervalPickerIndex == 0) {
		[switchAnswerLeftBtn setHidden:TRUE];
		[switchAnswerRightBtn setHidden:FALSE];
	}
	
	// if at last answer
	else if (intervalPickerIndex >= [[Settings sharedSettings] numIntervalsEnabled]-1) {
		[switchAnswerLeftBtn setHidden:FALSE];
		[switchAnswerRightBtn setHidden:TRUE];
	}
	
	// if inbetween
	else {
		[switchAnswerLeftBtn setHidden:FALSE];
		[switchAnswerRightBtn setHidden:FALSE];
	}
}

- (void)setOptionTextToIntervalIndex:(NSUInteger)intervalIndex {
	intervalPickerIndex = intervalIndex;		// we won't assume that it's been set
	[currentAnswerLabel setText:[[[Settings sharedSettings] enabledIntervalsByName] objectAtIndex:intervalIndex]];
}


#pragma mark -
#pragma mark View Controlling

- (void)displayInterval:(NSString *)theInterval {
	[intervalLabel setText:theInterval];
}

- (void)checkIsArpeggiatedForGiveUpBtn {
	if (!currentlyInGuessingState) {
		if ([[Settings sharedSettings] isArpeggiated]) {
			[nextOrGiveUpBarBtn setTitle:@"Together"];
		} else {
			[nextOrGiveUpBarBtn setTitle:@"Separate"];
		}
	}
}

- (void) goToNextQuestion {
	// Set Answer option bar stuff.
	[nextOrGiveUpBarBtn setEnabled:TRUE];	// ensure the Give Up button is enabled
	[doneBarBtn setEnabled:TRUE];						// make the Select button the Select button again
	[doneBarBtn setTitle:@"Select"];					// * more
	[doneBarBtn setAction:@selector(submitAnswer:)];	// * more
	[nextOrGiveUpBarBtn setTitle:@"Give Up"];
	[nextOrGiveUpBarBtn setAction:@selector(giveUp:)];
	
	// Show current score.
	[scoreTextItem setTitle:[self.delegate getScoreString]];	// set score display in top bar
	[scoreBar setTintColor:[UIColor blackColor]];	// set the top bar color back to black
	
	// Pick and play new interval.
	[delegate generateQuestion];
	
	// Indicate new interval.
	[self displayInterval:@"Listen"];
	
	// REMOVE ME before launch
	// Show the answer in the top left
	[devHelpLabel setText:[NSString stringWithFormat:@"%@,\t\t%@,\t\t%@",		// help a dev out
						   [intervalStrings objectAtIndex:[delegate getCurrentInterval]],
						   [[Settings sharedSettings] currentDifficulty],
						   [self enabledRoot]]];
}

#pragma mark -

- (IBAction)printDifficulty:(id)sender {
	[delegate printDifficulty];
}


#pragma mark -
#pragma mark Wrapper

// Pass along to AppDelegate
- (void)setEnabledRoot:(NSString*)str {
	[delegate setEnabledRoot:str];
}

// Gets from AppDelegate
- (NSString*)enabledRoot {
	return [delegate enabledRoot];
}

@end
