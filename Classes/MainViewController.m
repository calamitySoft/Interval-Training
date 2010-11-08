//
//  MainViewController.m
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "MainViewController.h"
#import "PageControlDelegate.h"

@implementation MainViewController

@synthesize delegate;
@synthesize answerPickingDelegate;

#define DEFAULT_ANSWER 0

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	intervalStrings = [[NSArray alloc] initWithObjects:@"Unison", @"Minor\nSecond", @"Major\nSecond",
					   @"Minor\nThird", @"Major\nThird", @"Perfect\nFourth", @"Tritone",
					   @"Perfect\nFifth", @"Minor\nSixth", @"Major\nSixth", @"Minor\nSeventh",
					   @"Major\nSeventh", @"Octave", nil];
	intervalPickerIndex = DEFAULT_ANSWER;
	
	// REMOVE ME before launch
	// Show the answer in the top left
	[devHelpLabel setText:[NSString stringWithFormat:@"%@,\t\t%c,\t\t%@",		// help a dev out
						   [intervalStrings objectAtIndex:[delegate getCurrentInterval]],
						   [self cDifficulty],
						   [self enabledRoot]]];
	
	[self setAnswerPickerToDifficulty:[self cDifficulty]];
	
#ifndef DEBUG
	[devHelpLabel setHidden:TRUE];
	[printDiffBtn setHidden:TRUE];
#endif
}
/**/


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	
	[answerPickingDelegate clearPages];		// clear previous text before setting next text
	
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
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

#pragma mark -

- (IBAction)giveUp:(id)sender {
	// Set UI stuff.
	[nextOrGiveUpBarBtn setEnabled:FALSE];
	[doneBarBtn setTitle:@"Next"];	// let the Done button act as the Next button (==submitAnswer:)
	[doneBarBtn setAction:@selector(nextNote:)];
	
	// Reinforce the sound while showing answer.
	[delegate replayNote];
	
	// Show the answer.
	[self displayInterval:[delegate intervalDifferenceBetween:[delegate iCurRoot] And:[delegate iCurTarget]]];
}

- (IBAction)nextNote:(id)sender {
	// Set Answer option bar stuff.
	[nextOrGiveUpBarBtn setEnabled:TRUE];	// ensure the Give Up button is enabled
	[doneBarBtn setEnabled:TRUE];						// make the Done button the Done button again
	[doneBarBtn setTitle:@"Done"];						// * more
	[doneBarBtn setAction:@selector(submitAnswer:)];	// * more
	
	// Show current score.
	[scoreTextItem setTitle:[self.delegate getScoreString]];	// set score display in top bar
	[scoreBar setTintColor:[UIColor blackColor]];	// set the top bar color back to black
	
	// Pick and play new interval.
	[delegate generateQuestion];
	
	// Indicate new interval.
	[self displayInterval:@"Listen"];
	
	// REMOVE ME before launch
	// Show the answer in the top left
	[devHelpLabel setText:[NSString stringWithFormat:@"%@,\t\t%c,\t\t%@",		// help a dev out
						   [intervalStrings objectAtIndex:[delegate getCurrentInterval]],
						   [self cDifficulty],
						   [self enabledRoot]]];
}

- (IBAction)replayNote:(id)sender {
	[delegate replayNote];
}

- (IBAction)submitAnswer:(id)sender {
	// Set Answer option bar stuff.
	[nextOrGiveUpBarBtn setEnabled:FALSE];	// disable the Give Up button
	[doneBarBtn setTitle:@"Next"];	// let the Done button act as the Next button (==giveUp:)
	[doneBarBtn setAction:@selector(nextNote:)];

	// Reinforce the sound while showing the answer.
	[delegate replayNote];
	
	// Show the answer.
	[self displayInterval:[intervalStrings objectAtIndex:[delegate getCurrentInterval]]];

	// Show whether the user got it right.
	if ([delegate submitAnswer:intervalPickerIndex]) {		// if our choice matches the interval being played
		[scoreTextItem setTitle:@"Correct!"];
		[scoreBar setTintColor:[UIColor colorWithRed:0 green:0.92 blue:0 alpha:1]];	// slightly dark shade of green
	}
	else {
		[scoreTextItem setTitle:@"Nope"];
		[scoreBar setTintColor:[UIColor redColor]];
	}

	NSLog(@"(MainVC) intervalPickerIndex: %u", intervalPickerIndex);
}

#pragma mark -

- (void)setAnswerPickerToDifficulty:(char)difficulty {
	NSMutableArray *enabledIntervals = [delegate aEnabledIntervals];
	
	NSMutableArray *availableAnswers = [[NSMutableArray alloc] init];
	
	// Construct picker's available answers from the arrays of
	//   enabled intervals and interval strings.
	for (NSUInteger i = 0; i < [enabledIntervals count]; i++) {
		NSNumber *num = [enabledIntervals objectAtIndex:i];
		if ([num boolValue]) {
			[availableAnswers addObject:[intervalStrings objectAtIndex:i]];
		}
	}
	
	[answerPickingDelegate initWithStrings:availableAnswers];
	[answerPickingDelegate startAtPage:0];
}

/*
 *	changedPageTo:
 *
 *	Purpose:	Maintain the user's current interval answer.
 *	Argument:	newPage is the index in the current Page Control (changes with difficulty).
 *	Strategy:	Get the string shown for the page (answer) seen.
 *				Get the correct interval number for that string.
 *
 */
- (void)changedPageTo:(NSUInteger)newPage {
	NSString *answerChosen = [[answerPickingDelegate optionsStrArray] objectAtIndex:newPage];	/* get shown str */
	intervalPickerIndex = [intervalStrings indexOfObject:answerChosen];		/* get interval index for said string */	
}


#pragma mark -
#pragma mark View Controlling

- (void) displayInterval:(NSString *)theInterval {
	[intervalLabel setText:theInterval];
}

#pragma mark -

-(void)setDifficulty:(char)theDiff {
	if ([self cDifficulty] != theDiff) {
		[delegate setDifficulty:theDiff];
		[self setAnswerPickerToDifficulty:theDiff];
		[answerPickingDelegate startAtPage:DEFAULT_ANSWER];		// coming back from settings screen, reset answer option
	}
}

-(char)cDifficulty {
	return [delegate cDifficulty];
}

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
