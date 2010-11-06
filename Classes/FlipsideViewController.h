//
//  FlipsideViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageControlDelegate.h"


@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <PageControlDelegateDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	
	// Difficulty
	IBOutlet UISegmentedControl *difficultySegmentedControl;
	
	// Root
	PageControlDelegate *rootSettingDelegate;
	NSArray *noteNames;
	NSUInteger currentRootSetting;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet PageControlDelegate *rootSettingDelegate;
@property (nonatomic, retain) NSArray *noteNames;
@property NSUInteger currentRootSetting;

- (IBAction)done:(id)sender;

- (IBAction)setDifficulty:(UISegmentedControl*)segmentedControl;	// tells the delegate to set difficulties
- (void)setDifficultyDisplay;		// adjust Settings' display to reflect current difficulty

- (void)changedPageTo:(NSUInteger)newPage;	// invoked by the PageControlDelegate upon page changing

@end



@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)setDifficulty:(char)theDiff;
- (char)cDifficulty;
- (void)setEnabledRoot:(NSString*)str;	// passes along to AppDelegate
- (NSString*)enabledRoot;	// gets from AppDelegate
@end

