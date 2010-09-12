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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
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
    [super dealloc];
}

#pragma mark difficulties

- (IBAction) diffEasy{
	NSLog(@"Setting difficulty to easy");
	[self.delegate setDifficulty:'e'];
	[self.delegate flipsideViewControllerDidFinish:self];	
}

-(IBAction) diffMed{
	NSLog(@"Setting difficulty to medium");
	[self.delegate setDifficulty:'m'];
	[self.delegate flipsideViewControllerDidFinish:self];	
}

-(IBAction) diffHard{
	NSLog(@"Setting difficulty to hard");
	[self.delegate setDifficulty:'h'];
	[self.delegate flipsideViewControllerDidFinish:self];	
}

@end
