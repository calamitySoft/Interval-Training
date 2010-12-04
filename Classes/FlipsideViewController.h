//
//  FlipsideViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDiffViewController.h"

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController <CustomDiffViewControllerDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	
	IBOutlet UISegmentedControl *difficultySegmentedControl;
	NSUInteger					tempDifficultySetting;
	IBOutlet UITextView			*intervalSettingsDisplay;
	IBOutlet UIButton			*arpeggiateOptionBtn;
	IBOutlet UILabel			*rootName;
	IBOutlet UIButton			*switchRootLeftBtn;
	IBOutlet UIButton			*switchRootRightBtn;
	NSArray						*noteNames;
	int							currentRootSetting;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic) NSUInteger tempDifficultySetting;
@property (nonatomic, retain) NSArray *noteNames;
@property int currentRootSetting;

- (IBAction)done:(id)sender;

- (IBAction)setDifficulty:(UISegmentedControl*)segmentedControl;	// tells the Settings to set difficulties
- (void)setCustomDifficulty;		// allow the player to set his own intervals to practice
- (void)setDifficultyDisplay;		// adjust Settings page's display to reflect current difficulty
- (IBAction)toggleArpeggiate;		// Switches arpeggiate mode off and on
- (IBAction)switchRootLeft;			// invoked by the "Set Root" left arrow; tells the delegate
- (IBAction)switchRootRight;		// invoked by the "Set Root" right arrow; tells the delegate
- (void)updateRootDisplay;			// updates display

@end



@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)setEnabledRoot:(NSString*)str;	// passes along to AppDelegate
- (NSString*)enabledRoot;	// gets from AppDelegate
@end

