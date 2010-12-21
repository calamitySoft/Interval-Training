//
//  OTG_ChordsAppDelegate.h
//  OTG-Intervals
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DJ.h"
#import "Scorekeeper.h"
#import "Chord.h"
#import <stdlib.h>

@class MainViewController;


@interface OTG_IntervalsAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate, IntervalsApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	FlipsideViewController *flipsideViewController;
	DJ *myDJ;
	Chord *myChord;
	
	Scorekeeper *scoreBoard;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) DJ *myDJ;
@property (nonatomic, retain) Chord *myChord;
@property (nonatomic, retain) Scorekeeper *scoreBoard;

- (void)generateQuestion; // An organizer function to put the main workflow in one centralized place

- (void)initMyVars;	// Initialize my instance variables here. Called from -application:DidFinishLaunchingWithOptions:
- (void)replayNote;	// Play the root again
- (void)printDifficulty;	// lets us see the difficulty settings
- (NSString *)getScoreString;	// Generates the score string to be handed off to MainVC
- (BOOL)submitAnswer:(NSString*)chordTypeGuessed;	// determines if answer is correct for MainVC; appropriately Scorekeeps

- (void)arpeggiate;	// Plays both the root and the target


@end

