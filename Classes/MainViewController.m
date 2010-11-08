//
//  MainViewController.m
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "MainViewController.h"

char oldDifficulty = 'e';	/* helps determine if we should switch questions. */



@implementation MainViewController

@synthesize delegate;

#define DEFAULT_ANSWER 4

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

#ifndef DEBUG
	[devHelpLabel setHidden:TRUE];
	[printDiffBtn setHidden:TRUE];
#endif
}
/**/


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
	
	// Go to next question only if the difficulty has changed.
	if (oldDifficulty != [self cDifficulty]) {
		oldDifficulty = [self cDifficulty];
		[self goToNextQuestion];
	}
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
	
	oldDifficulty = [self cDifficulty];
	
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
	[self goToNextQuestion];
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

}

#pragma mark -

- (IBAction)switchAnswerLeft:(id)sender {
	
	NSUInteger newIndex = intervalPickerIndex;	// collect new index specimens
	NSUInteger numNextPossibilies = 0;		// 1 possibility => new option is the last (so hide)
	
	// We're going to start this loop at the far end, so that the last
	//   newIndex assigned is the first one past the current index.
	for (NSUInteger i = 0; i < intervalPickerIndex; i++) {
		if ([delegate intervalIsEnabled:i]) {
			newIndex = i;
			numNextPossibilies++;
		}
	}
	
	// hide if switching to the only remaining option
	if (numNextPossibilies<=1) { [switchAnswerLeftBtn setHidden:TRUE];	}
	
	// if we can move left, it implies there's >=1 option to the right
	if (intervalPickerIndex != newIndex) {
		[switchAnswerRightBtn setHidden:FALSE];
		intervalPickerIndex = newIndex;
		[self setOptionText:newIndex];
	}
}

- (IBAction)switchAnswerRight:(id)sender {
	
	NSUInteger newIndex = intervalPickerIndex;	// collect new index specimens
	NSUInteger numNextPossibilies = 0;		// 1 possibility => new option is the last (so hide)
	
	// We're going to start this loop at the far end, so that the last
	//   newIndex assigned is the first one past the current index.
	for (NSUInteger i = [intervalStrings count]-1; i > intervalPickerIndex; i--) {
		if ([delegate intervalIsEnabled:i]) {
			newIndex = i;
			numNextPossibilies++;
		}
	}
	
	// hide if switching to the only remaining option
	if (numNextPossibilies<=1) { [switchAnswerRightBtn setHidden:TRUE];	}
	
	// if we can move right, it implies there's >=1 option to the left
	if (intervalPickerIndex != newIndex) {
		[switchAnswerLeftBtn setHidden:FALSE];
		intervalPickerIndex = newIndex;
		[self setOptionText:newIndex];
	}
}

- (void)setOptionText:(NSUInteger)intervalIndex {
	intervalPickerIndex = intervalIndex;		// we won't assume that it's been set
	[currentAnswerLabel setText:[intervalStrings objectAtIndex:intervalIndex]];
}


#pragma mark -
#pragma mark View Controlling

- (void)displayInterval:(NSString *)theInterval {
	[intervalLabel setText:theInterval];
}

- (void) goToNextQuestion {
	// Set Answer option bar stuff.
	[nextOrGiveUpBarBtn setEnabled:TRUE];	// ensure the Give Up button is enabled
	[doneBarBtn setEnabled:TRUE];						// make the Select button the Select button again
	[doneBarBtn setTitle:@"Select"];					// * more
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

#pragma mark -

-(void)setDifficulty:(char)theDiff {
	if ([self cDifficulty] != theDiff) {
		[delegate setDifficulty:theDiff];
		[self setOptionText:DEFAULT_ANSWER];	// coming back from settings screen, reset answer option
		
		[switchAnswerLeftBtn setHidden:FALSE];
		[switchAnswerRightBtn setHidden:FALSE];
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
