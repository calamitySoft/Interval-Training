//
//  Interval_TrainingAppDelegate.h
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DJ.h"

@class MainViewController;

@interface Interval_TrainingAppDelegate : NSObject <UIApplicationDelegate, ITApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	DJ *myDJ;
	NSArray *aNoteStrings;
	NSNumber *iCurRoot;
	NSNumber *iCurTarget;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) DJ *myDJ;
@property (nonatomic, retain) NSArray *aNoteStrings;
@property (nonatomic, retain) NSNumber *iCurRoot;
@property (nonatomic, retain) NSNumber *iCurTarget;

- (void)init;
- (void)replayNote;
- (void) selectNextNote;	// Returns an NSNumber for the index of the note we'll be using
- (void) selectNextTarget;
@end

