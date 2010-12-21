//
//  FlipsideViewController.m
//  OTG-Intervals
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Settings.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize tempDifficultySetting;
@synthesize noteNames, currentRootSetting;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
	
	// Difficulty setup
	self.tempDifficultySetting = [[Settings sharedSettings] getDifficultyAsUInt];
	[self setDifficultyDisplay];
	
	
	// Root setup
	[self setNoteNames:[[NSArray alloc] initWithObjects:@"any", @"C",@"C#",@"D",@"D#",@"E",
						@"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil]];
	// intermediate str->int step means this list can be in whatever order we want
	NSString *currentRootSettingStr = [[Settings sharedSettings] enabledRoot];
	[self setCurrentRootSetting:[noteNames indexOfObject:currentRootSettingStr]];
	[self updateRootDisplay];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Arpeggiate setup
	[isArpeggiatedSwitch setOn:[[Settings sharedSettings] isArpeggiated] animated:NO];
	
	// Inversion setup
	[allowInversionsSwitch setOn:[[Settings sharedSettings] allowInversions] animated:NO];
}


- (IBAction)done:(id)sender {
	[[Settings sharedSettings] setDifficultyWithUInt:self.tempDifficultySetting];
	
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (void)customDiffViewControllerDidFinish:(CustomDiffViewController *)controller {
	[self setDifficultyDisplay];
	[self dismissModalViewControllerAnimated:YES];
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
#pragma mark Play Style Control

// tells Settings about the new isArpeggiated setting
- (IBAction)toggleArpeggiate:(id)sender {
	[[Settings sharedSettings] setIsArpeggiated:[sender isOn]];
}

// tells Settings about the new allowInversions setting
- (IBAction)toggleInversions:(id)sender {
	[[Settings sharedSettings] setAllowInversions:[sender isOn]];
}



#pragma mark -
#pragma mark Difficulty Control

//	Sets the trainer's difficulty.
//	See Settings.h for details.
- (IBAction)setDifficulty:(UISegmentedControl*)segmentedControl {
	self.tempDifficultySetting = [segmentedControl selectedSegmentIndex];
	[self setDifficultyDisplay];
	
	if (self.tempDifficultySetting == 3) {
		[self setCustomDifficulty];
	}
}

//	Allow the player to set his own set of intervals to practice.
//	Flips to a CustomDiffView.
- (void)setCustomDifficulty {
	
	CustomDiffViewController *controller = [[CustomDiffViewController alloc] initWithNibName:@"CustomDiffView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

//	Sets indication of the current difficulty, and of the text view
//		explaining the currently tested intervals.
//	Side effect: This will invoke [setDifficulty:] (above), due to setting the
//		selection. (~It doesn't only respond to hardware UI events.)
- (void)setDifficultyDisplay {
	[difficultySegmentedControl setSelectedSegmentIndex:self.tempDifficultySetting];
	
	NSArray *selectedDifficulty;
	switch (difficultySegmentedControl.selectedSegmentIndex) {
		case 0:
			selectedDifficulty = [[NSArray alloc] initWithArray:[Settings sharedSettings].easyDifficulty];
			break;
		case 1:
			selectedDifficulty = [[NSArray alloc] initWithArray:[Settings sharedSettings].mediumDifficulty];
			break;
		case 2:
			selectedDifficulty = [[NSArray alloc] initWithArray:[Settings sharedSettings].hardDifficulty];
			break;
		case 3:
			selectedDifficulty = [[NSArray alloc] initWithArray:[Settings sharedSettings].customDifficulty];
			break;
		default:
			return;
	}
	
	NSString *tempTestingString = [NSString stringWithString:@""];
	BOOL first = TRUE;
	for (NSUInteger i=0; i<[selectedDifficulty count]; i++) {
		if ([[selectedDifficulty objectAtIndex:i] boolValue]) {
			tempTestingString = first ?
			[tempTestingString stringByAppendingFormat:@"%@",
			 [self.abbrChordNames objectAtIndex:i]] :
			[tempTestingString stringByAppendingFormat:@", %@",
			 [self.abbrChordNames objectAtIndex:i]];
			first = FALSE;
		}
	}
	[selectedDifficulty release];
	
	[chordSettingsDisplay setText:tempTestingString];
}


#pragma mark -
#pragma mark Root Control

- (IBAction)switchRootLeft {
	[self setCurrentRootSetting:
	 currentRootSetting>0 ? currentRootSetting-1 : currentRootSetting];				// set local var for storage
	[[Settings sharedSettings] setEnabledRoot:[noteNames objectAtIndex:currentRootSetting]];	// tell AppDelegate
	[self updateRootDisplay];	// update display
}

- (IBAction)switchRootRight {
	[self setCurrentRootSetting:
	 currentRootSetting<[noteNames count]-1 ? currentRootSetting+1 : currentRootSetting];	// set local var for storage
	[[Settings sharedSettings] setEnabledRoot:[noteNames objectAtIndex:currentRootSetting]];		// tell AppDelegate
	[self updateRootDisplay];	// update display
}

- (void)updateRootDisplay {
	[rootName setText:[noteNames objectAtIndex:currentRootSetting]];	// always update name
	
	/*
	 *	Set visibility for unnecessary options. (i.e. left when at first in list)
	 *	Note:	This only works if the 0th and [count]-1th options are always
	 *			the first and last options. MainVC switchAnswerLeft/Right solution
	 *			provides an alternative, but it's still a bit sub-optimal.
	 *			(It needs to be in two functions -- left, right.)
	 */
	if (currentRootSetting <= 0) {							/* farthest left option */
		[switchRootLeftBtn setHidden:TRUE];
	} else if (currentRootSetting >= [noteNames count]-1) {	/* farthest right option */
		[switchRootRightBtn setHidden:TRUE];
	} else {												/* somewhere in between */
		[switchRootLeftBtn setHidden:FALSE];
		[switchRootRightBtn setHidden:FALSE];
	}
}


#pragma mark -
#pragma mark Accessor Methods


/*
 *	lazy init of our vars
 */

- (NSArray*)abbrChordNames {
	if (abbrChordNames == nil) {
		NSString *thePath = [[NSBundle mainBundle]  pathForResource:@"Config" ofType:@"plist"];
		NSDictionary *rawConfigDict = [[NSDictionary alloc] initWithContentsOfFile:thePath];
		abbrChordNames = [rawConfigDict objectForKey:@"AbbrIntervalNames"];
		[abbrChordNames retain];
		[rawConfigDict release];		// var must be released, but it's a part of abbrChordNames, so that one would be released as well (I think?)
	}
	return abbrChordNames;
}

@end
