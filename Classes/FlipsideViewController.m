//
//  FlipsideViewController.m
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize noteNames, currentRootSetting;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      

	[self setDifficultyDisplay];
	
	noteNames = [[NSArray alloc] initWithObjects:@"any", @"C",@"C#",@"D",@"D#",@"E",
						  @"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil];
	[rootControl setNumberOfPages:[noteNames count]];
	// FIXME: Should get currentRootSetting from a delegate
	[self setCurrentRootSetting:0];
	[self updateRootDisplay];
}


- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	[noteNames release];
    [super dealloc];
}


#pragma mark -
#pragma mark Difficulty Control

//	Sets the trainer's difficulty.
//	See AppDelegate for details.
- (IBAction)setDifficulty:(UISegmentedControl*)segmentedControl {
	switch ([segmentedControl selectedSegmentIndex]) {
		case 0:
			[self.delegate setDifficulty:'e'];
			break;
		case 1:
			[self.delegate setDifficulty:'m'];
			break;
		case 2:
			[self.delegate setDifficulty:'h'];
			break;
		default:
			NSLog(@"(Flipside) Attempting to set unrecognized difficulty.");
			break;
	}
}

//	Sets indication of the current difficulty
//	Side effect: This will invoke [setDifficulty:] (above), due to setting the
//		selection. (~It doesn't just respond to hardware UI events.)
- (void)setDifficultyDisplay {
	switch ([delegate getDifficulty]) {
		case 'e':
			[difficultySegmentedControl setSelectedSegmentIndex:0];
			break;
		case 'm':
			[difficultySegmentedControl setSelectedSegmentIndex:1];
			break;
		case 'h':
			[difficultySegmentedControl setSelectedSegmentIndex:2];
			break;			
		default:
			NSLog(@"(Flipside) Current difficulty unrecognized.");
			break;
	}
}


#pragma mark -
#pragma mark Root Control

// 
- (IBAction)updateRootSelection {
	[self setCurrentRootSetting:[rootControl currentPage]];
	[self updateRootDisplay];
}

- (void)updateRootDisplay {
	[rootControl setCurrentPage:currentRootSetting];
	[rootName setText:[noteNames objectAtIndex:currentRootSetting]];	
}


@end
