//
//  Interval_TrainingAppDelegate.h
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DJ.h"
#import "Scorekeeper.h"
#import <stdlib.h>

@class MainViewController;


@interface Interval_TrainingAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	FlipsideViewController *flipsideViewController;
	DJ *myDJ;
	NSArray *aNoteStrings;
	NSString *enabledRoot;		// ** This is a string so it can be compared to any octave. **
								// Maybe it could be done with some ints and math, but then the ordering of
								// Setting's list (seen by user) would be bound to aNoteStrings (programmatic).
								// That'd mean loss of UI/data independence.  :(  i think...
	NSNumber *iCurRoot;
	NSNumber *iCurTarget;
	
	Scorekeeper *scoreBoard;
	NSArray *intervalStrings;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) DJ *myDJ;
@property (nonatomic, retain) NSArray *aNoteStrings;
@property (nonatomic, retain) NSString *enabledRoot;
@property (nonatomic, retain) NSNumber *iCurRoot;
@property (nonatomic, retain) NSNumber *iCurTarget;
@property (nonatomic, retain) Scorekeeper *scoreBoard;

- (void)generateQuestion; // An organizer function to put the main workflow in one centralized place

- (void)initMyVars;	// Initialize my instance variables here. Called from -application:DidFinishLaunchingWithOptions:
- (void)replayNote;	// Play the root again
- (void)selectNextRoot;	// Sets iCurRoot for the index of the root note we'll be using
- (void)selectNextTarget;	// Sets iCurTarget for the index of the target note
- (void)printDifficulty;	// lets us see the difficulty settings
- (NSString *)getScoreString;	// Generates the score string to be handed off to MainVC
- (BOOL)submitAnswer:(NSUInteger)intervalGuessed;	// determines if answer is correct for MainVC; appropriately Scorekeeps

- (int)getCurrentInterval;	// returns an int of the interval being played
- (BOOL)intervalIsEnabled:(NSUInteger)distance;	// intervals enabled are dependent on difficulty setting
- (NSString *)intervalDifferenceBetween:(NSNumber *)first And:(NSNumber *)second;

- (void)arrpegiate;	// Plays both the root and the target

- (BOOL)rootIsEnabled:(NSUInteger)root;	// root enabled is dependent on the whim of the user


@end

