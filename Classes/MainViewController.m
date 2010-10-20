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
NSArray *nextBtnActions;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	nextBtnActions = [NSArray alloc];
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
	[nextOrGiveUpButton setTitle:@"Next" forState:UIControlStateNormal];
	[nextOrGiveUpButton removeTarget:self action:@selector(giveUp:) forControlEvents:UIControlEventTouchUpInside];
	[nextOrGiveUpButton addTarget:self action:@selector(nextNote:) forControlEvents:UIControlEventTouchUpInside];

	// Used for seeing which actions will occur.
	// nextBtnActions = [nextOrGiveUpButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
}

-(IBAction)nextNote:(id)sender {
	// Indicate new interval.
	[self displayInterval:@"Listen"];
	
	// Pick and play new interval.
	[delegate generateQuestion];

	// Set UI stuff.
	[nextOrGiveUpButton setTitle:@"Give Up" forState:UIControlStateNormal];
	[nextOrGiveUpButton removeTarget:self action:@selector(nextNote:) forControlEvents:UIControlEventTouchUpInside];
	[nextOrGiveUpButton addTarget:self action:@selector(giveUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)replayNote:(id)sender {
	[delegate replayNote];
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
