//
//  FlipsideViewController.m
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "PageControlDelegate.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize rootSettingDelegate, noteNames, currentRootSetting;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      

	
	// Difficulty setup
	[self setDifficultyDisplay];
	
	
	// Root setup
	noteNames = [[NSArray alloc] initWithObjects:@"any", @"C",@"C#",@"D",@"D#",@"E",
						  @"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil];
		// intermediate str->int step means this list can be in whatever order we want
	NSString *currentRootSettingStr = [delegate enabledRoot];
	[self setCurrentRootSetting:[noteNames indexOfObject:currentRootSettingStr]];
	
	
	// Apple style page control
	// Init the root paging delegate with our strings.
	[rootSettingDelegate initWithStrings:noteNames];
	[rootSettingDelegate startAtPage:currentRootSetting];
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
	switch ([delegate cDifficulty]) {
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

- (void)changedPageTo:(NSUInteger)newPage {
	currentRootSetting = newPage;
	[self.delegate setEnabledRoot:[noteNames objectAtIndex:currentRootSetting]];	// tell AppDelegate
}


@end
