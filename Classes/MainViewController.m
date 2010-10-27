//
//  MainViewController.m
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "MainViewController.h"


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
	[devHelpLabel setText:[NSString stringWithFormat:@"%@",		// help a dev out
						   [intervalStrings objectAtIndex:[delegate getCurrentInterval]]]];
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
	// Set UI stuff.
	[nextOrGiveUpBarBtn setEnabled:TRUE];	// ensure the Give Up button is enabled
	[doneBarBtn setEnabled:TRUE];	// make the Done button the Done button again
	[doneBarBtn setTitle:@"Done"];
	[doneBarBtn setAction:@selector(submitAnswer:)];
	[scoreTextItem setTitle:@"Score"];
	[scoreBar setTintColor:[UIColor blackColor]];
	
	// Pick and play new interval.
	[delegate generateQuestion];
	
	// Indicate new interval.
	[self displayInterval:@"Listen"];
	
	// REMOVE ME before launch
	// Show the answer in the top left
	[devHelpLabel setText:[NSString stringWithFormat:@"%@",		// help a dev out
						   [intervalStrings objectAtIndex:[delegate getCurrentInterval]]]];
}

- (IBAction)replayNote:(id)sender {
	[delegate replayNote];
}

- (IBAction)submitAnswer:(id)sender {
	// Set UI stuff.
	[nextOrGiveUpBarBtn setEnabled:FALSE];	// disable the Give Up button
	[doneBarBtn setTitle:@"Next"];	// let the Done button act as the Next button (==giveUp:)
	[doneBarBtn setAction:@selector(nextNote:)];

	// Reinforce the sound while showing the answer.
	[delegate replayNote];
	
	// Show the answer and whether the user got it right.
	if ([delegate getCurrentInterval] == intervalPickerIndex) {		// if our choice matches the interval being played
		[self displayInterval:[intervalStrings objectAtIndex:intervalPickerIndex]];
		[scoreTextItem setTitle:@"Correct!"];
		[scoreBar setTintColor:[UIColor greenColor]];
	}
	else {
		[self displayInterval:[intervalStrings objectAtIndex:[delegate getCurrentInterval]]];
		[scoreTextItem setTitle:@"Nope"];
		[scoreBar setTintColor:[UIColor redColor]];
	}

}

#pragma mark -

- (IBAction)switchAnswerLeft:(id)sender {
	NSUInteger placeholderIndex = intervalPickerIndex;	// in case no new option is set. index changed in loop below.
	
	while (intervalPickerIndex >= 1) {			// answer option must not go below 0
		intervalPickerIndex--;
		if ([delegate intervalIsEnabled:intervalPickerIndex]) {
			[self setOptionText:intervalPickerIndex];
			return;
		}
	}

	intervalPickerIndex = placeholderIndex;
}

- (IBAction)switchAnswerRight:(id)sender {
	NSUInteger placeholderIndex = intervalPickerIndex;	// in case no new option is set. index changed in loop below.
	
	while (intervalPickerIndex+1 < [intervalStrings count]) {	// answer option must not go above the last option available
		intervalPickerIndex++;
		if ([delegate intervalIsEnabled:intervalPickerIndex]) {
			[self setOptionText:intervalPickerIndex];
			return;
		}
	}

	intervalPickerIndex = placeholderIndex;
}

- (void)setOptionText:(NSUInteger)intervalIndex {
	intervalPickerIndex = intervalIndex;		// we won't assume that it's been set
	[currentAnswerLabel setTitle:[intervalStrings objectAtIndex:intervalIndex] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark View Controlling

- (void) displayInterval:(NSString *)theInterval {
	[intervalLabel setText:theInterval];
}

#pragma mark -

-(void)setDifficulty:(char)theDiff {
	[delegate setDifficulty:theDiff];
	[self setOptionText:DEFAULT_ANSWER];	// coming back from settings screen, reset answer option
}

-(char)getDifficulty {
	return [delegate cDifficulty];
}

- (IBAction)printDifficulty:(id)sender {
	[delegate printDifficulty];
}


@end
