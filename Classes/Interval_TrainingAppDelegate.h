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
#import <stdlib.h>

@class MainViewController;

typedef enum interval { unison, minSecond, majSecond, minThird, majThird, perFourth, tritone, 
	perFifth, minSixth, majSixth, minSeventh, majSeventh, octave} interval;

@interface Interval_TrainingAppDelegate : NSObject <UIApplicationDelegate, ITApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	FlipsideViewController *flipsideViewController;
	DJ *myDJ;
	NSArray *aNoteStrings;
	NSMutableArray *aEnabledIntervals;
	NSNumber *iCurRoot;
	NSNumber *iCurTarget;
	char cDifficulty;
	
	NSArray *intervalStrings;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) DJ *myDJ;
@property (nonatomic, retain) NSArray *aNoteStrings;
@property (nonatomic, retain) NSMutableArray *aEnabledIntervals;
@property (nonatomic, retain) NSNumber *iCurRoot;
@property (nonatomic, retain) NSNumber *iCurTarget;
@property char cDifficulty;

- (void)generateQuestion; // An organizer function to put the main workflow in one centralized place

- (void)initMyVars;	// Initialize my instance variables here. Called from -application:DidFinishLaunchingWithOptions:
- (void)setAllIntervals:(NSNumber *)mode;
- (void)replayNote;	// Play the root again
- (void)selectNextRoot;	// Sets iCurRoot for the index of the root note we'll be using
- (void)selectNextTarget;	// Sets iCurTarget for the index of the target note
- (void)setDifficulty:(char)theDiff;	// Sets the cDifficulty
										// IntervalDifference will return a string of the interval between the root
										// and target
- (void)printDifficulty;	// lets us see the difficulty settings

- (int)getCurrentInterval;	// returns an int of the interval being played
- (BOOL)intervalIsEnabled:(NSUInteger)distance;
- (NSString *)intervalDifferenceBetween:(NSNumber *)first And:(NSNumber *)second;

@end

