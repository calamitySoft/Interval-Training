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
	NSNumber *iCurRoot;
	NSNumber *iCurTarget;
	char cDifficulty;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) DJ *myDJ;
@property (nonatomic, retain) NSArray *aNoteStrings;
@property (nonatomic, retain) NSNumber *iCurRoot;
@property (nonatomic, retain) NSNumber *iCurTarget;
@property char cDifficulty;

- (void)initMyVars;	// Initialize my instance variables here. Called from -application:DidFinishLaunchingWithOptions:

- (void)replayNote;	// Play the root again
- (void)selectNextNote;	// Returns an NSNumber for the index of the note we'll be using
- (void)selectNextTarget;
- (void)setDifficulty:(char)theDiff;	// Sets the cDifficulty
	// IntervalDifference will return a string of the interval between the root
	// and target
- (NSString *)intervalDifferenceBetween:(NSNumber *)first And:(NSNumber *)second;

@end

