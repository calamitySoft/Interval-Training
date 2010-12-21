//
//  MainViewController.m
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "MainViewController.h"
#import "Settings.h"
#import "LoadFromFile.h"



@implementation MainViewController

@synthesize delegate, oldDifficulty, chordStrings, chordPickerIndex;

#define DEFAULT_ANSWER 4

// For knowing whether the nextOrGiveUpBarBtn should read
//	"Give Up" ..or.. "Separate" or "Together".
BOOL currentlyInGuessingState = YES;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	// Initialize chordStrings from file
	NSError *loadError;
	self.chordStrings = (NSArray*) [LoadFromFile newObjectForKey:@"IntervalNames" error:&loadError];
	if (!self.chordStrings) {
		NSLog(@"(MainVC) Error in loading interval names: %@", [loadError domain]);
	}
	
	
	NSUInteger randomAnswer = 0;
//	do {
//		// get a new random answer in integer form
//		// while that answer is not enabled
//		randomAnswer = arc4random()%[[[Settings sharedSettings] enabledChordsByName] count];
//	} while (![[[[Settings sharedSettings] enabledChords] objectAtIndex:randomAnswer] boolValue]);
	
	[self setOptionTextToChordIndex:randomAnswer];	// coming back from settings screen, reset answer option
	[self resetArrowVisibility];
	
	
	
	// REMOVE ME before launch
	// Show the answer in the top left
	[devHelpLabel setText:[NSString stringWithFormat:@"%@ %@,\t\t%@,\t\t%@",		// help a dev out
						   [[delegate myChord] rootName],
						   [[delegate myChord] chordType],
						   [[Settings sharedSettings] currentDifficulty],
						   [[Settings sharedSettings] enabledRoot]]];
	
	// Make sure we have the initial difficulty set
	self.oldDifficulty = [[NSArray alloc] initWithArray:[[Settings sharedSettings] enabledChords]];

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
    [super viewWillAppear:animated];

	//	Check isArpeggiated for the correct button title
	[self checkIsArpeggiatedForGiveUpBtn];
}

- (void)viewDidAppear:(BOOL)animated {
	//
	//	Only if the difficulty has changed:
	//		Go to the next question.
	//		Reset answer picker.
	//
	if (![self.oldDifficulty isEqualToArray:[[Settings sharedSettings] enabledChords]]) {

		// store the old difficulty so we know if we need to get a new quesiton when we come back
		//		i'm not sure why this works.  i would've thought it'd simply copy the pointer, making
		//		the two array always equal
		[oldDifficulty release];
		self.oldDifficulty = [[NSArray alloc] initWithArray:[[Settings sharedSettings] enabledChords]];
		
		[self goToNextQuestion];
		
		NSUInteger randomAnswer = 0;
//		do {
//			// get a new random answer in integer form
//			// while that answer is not enabled
//			randomAnswer = arc4random()%[[[Settings sharedSettings] enabledChordsByName] count];
//		} while (![[[[Settings sharedSettings] enabledChords] objectAtIndex:randomAnswer] boolValue]);
		
		[self setOptionTextToChordIndex:randomAnswer];	// coming back from settings screen, reset answer option
		
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
	[oldDifficulty release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Interface Elements

- (IBAction)showSettings:(id)sender {    
	
	// store the old difficulty so we know if we need to get a new quesiton when we come back
	//		i'm not sure why this works.  i would've thought it'd simply copy the pointer, making
	//		the two array always equal
	[oldDifficulty release];
	self.oldDifficulty = [[NSArray alloc] initWithArray:[[Settings sharedSettings] enabledChords]];
	
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
	[self displayChord:[[delegate myChord] chordType]];
}

- (IBAction)nextNote:(id)sender {
	[self goToNextQuestion];
	currentlyInGuessingState = YES;							// back to guessing (quizzing) state
}

- (IBAction)replayNote:(id)sender {
	[delegate replayNote];
}

- (IBAction)separate:(id)sender{
	[delegate arpeggiate];
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
	[self displayChord:[[delegate myChord] chordType]];

	
	// Show whether the user got it right.
	NSString *tempAnswerString = [[[Settings sharedSettings] enabledChordsByName] objectAtIndex:chordPickerIndex];
	[tempAnswerString retain];
	if ([delegate submitAnswer:tempAnswerString]) {		// if our choice matches the chord being played
		[scoreTextItem setTitle:@"Correct!"];
		[scoreBar setTintColor:[UIColor colorWithRed:0 green:0.92 blue:0 alpha:1]];	// slightly dark shade of green
	}
	else {
		[scoreTextItem setTitle:@"Nope"];
		[scoreBar setTintColor:[UIColor redColor]];
	}
	[tempAnswerString release];

}

#pragma mark -

- (IBAction)switchAnswerLeft:(id)sender {
	
	// if we're currently after the first one
	if (self.chordPickerIndex > 0) {
		self.chordPickerIndex--;
		[self setOptionTextToChordIndex:self.chordPickerIndex];
	}
	[self resetArrowVisibility];		// outside the IF just in case
}

- (IBAction)switchAnswerRight:(id)sender {
	
	// if we're currently before the last one
	if (self.chordPickerIndex < [[Settings sharedSettings] numChordsEnabled]-1) {
		self.chordPickerIndex++;
		[self setOptionTextToChordIndex:self.chordPickerIndex];
	}
	[self resetArrowVisibility];		// outside the IF just in case
}

- (void)resetArrowVisibility {
	
	if ([[Settings sharedSettings] numChordsEnabled]==1) {
		[switchAnswerLeftBtn setHidden:TRUE];
		[switchAnswerRightBtn setHidden:TRUE];
		return;
	}
	
	// if at first answer
	if (chordPickerIndex == 0) {
		[switchAnswerLeftBtn setHidden:TRUE];
		[switchAnswerRightBtn setHidden:FALSE];
	}
	
	// if at last answer
	else if (self.chordPickerIndex >= [[Settings sharedSettings] numChordsEnabled]-1) {
		[switchAnswerLeftBtn setHidden:FALSE];
		[switchAnswerRightBtn setHidden:TRUE];
	}
	
	// if inbetween
	else {
		[switchAnswerLeftBtn setHidden:FALSE];
		[switchAnswerRightBtn setHidden:FALSE];
	}
}

- (void)setOptionTextToChordIndex:(NSUInteger)chordIndex {
	self.chordPickerIndex = chordIndex;		// we won't assume that it's been set
	[currentAnswerLabel setText:[[[Settings sharedSettings] enabledChordsByName] objectAtIndex:chordIndex]];
}


#pragma mark -
#pragma mark View Controlling

- (void)displayChord:(NSString *)theChord {
	if (theChord == nil) {
		[chordLabel setText:@"Error: no interval"];
	} else {
		[chordLabel setText:theChord];
	}
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
	
	// Pick and play new chord.
	[delegate generateQuestion];
	
	// Indicate new chord.
	[self displayChord:@"Listen"];
	
	// REMOVE ME before launch
	// Show the answer in the top left
	[devHelpLabel setText:[NSString stringWithFormat:@"%@ %@,\t\t%@,\t\t%@",		// help a dev out
						   [[delegate myChord] rootName],
						   [[delegate myChord] chordType],
						   [[Settings sharedSettings] currentDifficulty],
						   [[Settings sharedSettings] enabledRoot]]];
}

#pragma mark -

- (IBAction)printDifficulty:(id)sender {
	[delegate printDifficulty];
}

@end
