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

- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)giveUp:(id)sender {
	// Show the answer.
	[self displayInterval:[delegate intervalDifferenceBetween:[delegate iCurRoot] And:[delegate iCurTarget]]];
	
	// Set UI stuff.
	[nextOrGiveUpBarBtn setTitle:@"Next"];
	[nextOrGiveUpBarBtn setAction:@selector(nextNote:)];
}

-(IBAction)nextNote:(id)sender {
	// Indicate new interval.
	[self displayInterval:@"Listen"];
	
	// Pick and play new interval.
	[delegate generateQuestion];

	// Set UI stuff.
	[nextOrGiveUpBarBtn setTitle:@"Give Up"];
	[nextOrGiveUpBarBtn setAction:@selector(giveUp:)];
}

- (IBAction)replayNote:(id)sender {
	[delegate replayNote];
}

- (IBAction)switchAnswerLeft:(id)sender {
	if (intervalPickerIndex-1 >= 0) {
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


#pragma mark View Controlling

- (void) displayInterval:(NSString *)theInterval{
	[intervalLabel setText:theInterval];
}

#pragma mark -

- (void) setDifficulty:(char)theDiff
{
	[delegate setDifficulty:theDiff];
}

@end
