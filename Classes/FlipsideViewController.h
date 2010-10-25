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
	
	IBOutlet UIButton *easyBtn;
	IBOutlet UIButton *mediumBtn;
	IBOutlet UIButton *hardBtn;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

-(IBAction) diffEasy;	// tells the delegate to set difficulty to 'e'
-(IBAction) diffMed;	// tells the delegate to set difficulty to 'm'
-(IBAction) diffHard;	// tells the delegate to set difficulty to 'h'

@end



@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)setDifficulty:(char)theDiff;
- (char)getDifficulty;
@end

