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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	intervalStrings = [[NSArray alloc] initWithObjects:@"Unison", @"Minor\nSecond", @"Major\nSecond",
					   @"Minor\nThird", @"Major\nThird", @"Perfect\nFourth", @"Tritone",
					   @"Perfect\nFifth", @"Minor\nSixth", @"Major\nSixth", @"Minor\nSeventh",
					   @"Major\nSeventh", nil];
	intervalPickerIndex = 5;
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

- (IBAction)giveUp:(id)sender {
	// Set UI stuff.
	[nextOrGiveUpBarBtn setEnabled:FALSE];
	[doneBarBtn setTitle:@"Next"];	// let the Done button act as the Next button (==giveAnswer:)
	[doneBarBtn setAction:@selector(nextNote:)];
	
	[delegate replayNote];
	
	// Show the answer.
	[self displayInterval:[delegate intervalDifferenceBetween:[delegate iCurRoot] And:[delegate iCurTarget]]];
}

- (IBAction)nextNote:(id)sender {
	// Set UI stuff.
	[nextOrGiveUpBarBtn setEnabled:TRUE];	// ensure the Give Up button is enabled
	[doneBarBtn setEnabled:TRUE];	// make the Done button the Done button again
	[doneBarBtn setTitle:@"Done"];
	[doneBarBtn setAction:@selector(giveAnswer:)];
	
	// Indicate new interval.
	[self displayInterval:@"Listen"];
	
	// Pick and play new interval.
	[delegate generateQuestion];
	[devHelpLabel setText:[NSString stringWithFormat:@"%d",
						   [intervalStrings objectAtIndex:[delegate getCurrentInterval]]]];
}

- (IBAction)replayNote:(id)sender {
	[delegate replayNote];
}

- (IBAction)giveAnswer:(id)sender {
	// Set UI stuff.
	[nextOrGiveUpBarBtn setEnabled:FALSE];	// disable the Give Up button
	[doneBarBtn setTitle:@"Next"];	// let the Done button act as the Next button (==giveUp:)
	[doneBarBtn setAction:@selector(nextNote:)];

	[delegate replayNote];
	
	if ([delegate getCurrentInterval] == intervalPickerIndex) {		// if our choice matches the interval being played
		[self displayInterval:[NSString stringWithFormat:@"You got it!\n%@",
							   [intervalStrings objectAtIndex:intervalPickerIndex]]];
	}
	else {
		[self displayInterval:[NSString stringWithFormat:@"Nope, it was\n%@",
							   [intervalStrings objectAtIndex:[delegate getCurrentInterval]]]];
	}

}

#pragma mark -

- (IBAction)switchAnswerLeft:(id)sender {
	if (intervalPickerIndex >= 1) {
		intervalPickerIndex--;
		[currentAnswerLabel setTitle:[intervalStrings objectAtIndex:intervalPickerIndex] forState:UIControlStateNormal];
	}
}
- (IBAction)switchAnswerRight:(id)sender {
	if (intervalPickerIndex+1 < [intervalStrings count]) {
		intervalPickerIndex++;
		[currentAnswerLabel setTitle:[intervalStrings objectAtIndex:intervalPickerIndex] forState:UIControlStateNormal];
	}
}


#pragma mark -
#pragma mark View Controlling

- (void) displayInterval:(NSString *)theInterval {
	[intervalLabel setText:theInterval];
}

#pragma mark -

-(void) setDifficulty:(char)theDiff {
	[delegate setDifficulty:theDiff];
}

-(char)getDifficulty {
	return [delegate cDifficulty];
}

@end
