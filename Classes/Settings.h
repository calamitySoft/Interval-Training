//
//  Settings.h
//  Interval-Training
//
//  Created by Logan Moseley on 11/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *kEasyDifficulty = @"EasyDifficulty";
static NSString *kMediumDifficulty = @"MediumDifficulty";
static NSString *kHardDifficulty = @"HardDifficulty";
static NSString *kCustomDifficulty = @"CustomDifficulty";

typedef enum interval { unison, minSecond, majSecond, minThird, majThird, perFourth, tritone, 
	perFifth, minSixth, majSixth, minSeventh, majSeventh, octave} interval;


@interface Settings : NSObject {
	NSArray			*intervalNames;
	
	NSArray			*easyDifficulty;		// NSArray of NSNumbers
	NSArray			*mediumDifficulty;		// NSArray of NSNumbers
	NSArray			*hardDifficulty;		// NSArray of NSNumbers
	NSMutableArray	*customDifficulty;		// NSArray of NSNumbers
	NSString		*currentDifficulty;		// kEasyDifficulty, or kMediumDifficulty, etc
	NSArray			*enabledIntervals;		// always points to easyDifficulty, or mediumDifficulty, etc
}

@property (nonatomic, retain, readonly) NSArray *intervalNames;

@property (nonatomic, retain, readonly) NSArray *easyDifficulty;
@property (nonatomic, retain, readonly) NSArray *mediumDifficulty;
@property (nonatomic, retain, readonly) NSArray *hardDifficulty;
@property (nonatomic, retain) NSMutableArray *customDifficulty;
@property (nonatomic, retain) NSString *currentDifficulty;

@property (nonatomic, retain) NSArray *enabledIntervals;



+ (Settings *)sharedSettings;	// necessary for singelton-ness. DO NOT REMOVE.

// Change particulars of customDifficulty.
// Used in CustomDiffTableViewController.
- (BOOL)setCustomDifficultyAtIndex:(NSUInteger)_index toValue:(BOOL)_value;

- (char)getDifficulty;									// need this to easily get diff from other code. for now.
- (NSUInteger)getDifficultyAsUInt;						// need this to easily get diff from other code. for now.
- (void)setDifficulty:(char)_difficulty;				// need this to easily set diff from other code. for now.
- (void)setDifficultyWithUInt:(NSUInteger)_difficulty;	// need this to easily set diff from other code. for now.


@end
