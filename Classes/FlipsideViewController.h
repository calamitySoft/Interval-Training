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
	IBOutlet UIPageControl *rootControl;
	IBOutlet UILabel *rootName;
	
	NSArray *noteNames;
	int currentRootSetting;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *noteNames;
@property int currentRootSetting;

- (IBAction)done:(id)sender;

- (IBAction)setDifficulty:(UISegmentedControl*)segmentedControl;	// tells the delegate to set difficulties
- (void)setDifficultyDisplay;		// adjust Settings' display to reflect current difficulty

- (IBAction)updateRootSelection;	// invoked by the UIPageControl upon its value changing
- (void)updateRootDisplay;			// tells the delegate which note should be root; updates display

@end



@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)setDifficulty:(char)theDiff;
- (char)cDifficulty;
- (void)setEnabledRoot:(NSString*)str;	// passes along to AppDelegate
- (NSString*)enabledRoot;	// gets from AppDelegate
@end

