//
//  FlipsideViewController.h
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
	
	IBOutlet UISegmentedControl *difficultySegmentedControl;

	IBOutlet UILabel *rootName;
	IBOutlet UIButton *switchRootLeftBtn;
	IBOutlet UIButton *switchRootRightBtn;
	NSArray *noteNames;
	int currentRootSetting;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *noteNames;
@property int currentRootSetting;

- (IBAction)done:(id)sender;

- (IBAction)setDifficulty:(UISegmentedControl*)segmentedControl;	// tells the delegate to set difficulties
- (void)setDifficultyDisplay;		// adjust Settings' display to reflect current difficulty

- (IBAction)switchRootLeft;				// invoked by the "Set Root" left arrow; tells the delegate
- (IBAction)switchRootRight;			// invoked by the "Set Root" right arrow; tells the delegate
- (void)updateRootDisplay;			// updates display

@end



@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)setDifficulty:(char)theDiff;
- (char)cDifficulty;
- (void)setEnabledRoot:(NSString*)str;	// passes along to AppDelegate
- (NSString*)enabledRoot;	// gets from AppDelegate
@end

