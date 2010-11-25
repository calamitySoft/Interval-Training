//
//  Settings.m
//  Interval-Training
//
//  Created by Logan Moseley on 11/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Settings.h"
#import "SynthesizeSingleton.h"

@implementation Settings

SYNTHESIZE_SINGLETON_FOR_CLASS(Settings);	// necessary for singelton-ness. DO NOT REMOVE.

@synthesize currentDifficulty;

typedef enum interval { unison, minSecond, majSecond, minThird, majThird, perFourth, tritone, 
	perFifth, minSixth, majSixth, minSeventh, majSeventh, octave} interval;

static NSString *kEasyDifficulty = @"EasyDifficulty";
static NSString *kMediumDifficulty = @"MediumDifficulty";
static NSString *kHardDifficulty = @"HardDifficulty";


- (id)init {
	currentDifficulty = 'e';
	
	return self;
}

- (void)dealloc {
	[noteNames release];
	[easyDifficulty release];
	[mediumDifficulty release];
	[hardDifficulty release];
	[customDifficulty release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark Private Methods

- (NSArray*)loadDifficulty:(NSString*)_difficulty {
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	
	// read the _difficulty data from the plist
	NSString *thePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
	NSDictionary *rawConfigDict = [[NSDictionary alloc] initWithContentsOfFile:thePath];
	NSDictionary *difficultyDict = [[NSDictionary alloc] initWithDictionary:[rawConfigDict objectForKey:_difficulty]];
	
	for (NSUInteger i=0; i<[self.noteNames count]; i++) {
		NSString *intervalName = [self.noteNames objectAtIndex:i];
		Boolean isEnabled = [[difficultyDict valueForKey:intervalName] boolValue];		
		[tempArray addObject:[NSNumber numberWithBool:isEnabled]];
	}
	
	
	return tempArray;
}


#pragma mark -
#pragma mark Accessor Methods

/*
 *	lazy init of our vars
 */

- (NSArray*)noteNames {
	if (noteNames == nil) {
		NSString *thePath = [[NSBundle mainBundle]  pathForResource:@"Config" ofType:@"plist"];
		NSDictionary *rawConfigDict = [[NSDictionary alloc] initWithContentsOfFile:thePath];
		noteNames = [rawConfigDict objectForKey:@"IntervalNames"];
		
	}
	return noteNames;
}

#pragma mark -

- (NSArray*)easyDifficulty {
	if (easyDifficulty == nil) {
		easyDifficulty = [self loadDifficulty:kEasyDifficulty];
	}
	return easyDifficulty;
}

- (NSArray*)mediumDifficulty {
	if (mediumDifficulty == nil) {
		mediumDifficulty = [self loadDifficulty:kMediumDifficulty];
	}
	return mediumDifficulty;
}

- (NSArray*)hardDifficulty {
	if (hardDifficulty == nil) {
		hardDifficulty = [self loadDifficulty:kHardDifficulty];
	}
	return hardDifficulty;
}

- (NSArray*)customDifficulty {
    if (customDifficulty == nil) {
		
		customDifficulty = [[NSArray alloc] initWithObjects: nil];
    }
    return customDifficulty;	
}

- (void)setCustomDifficulty:(NSArray *)_customDifficulty {
	self.customDifficulty = _customDifficulty;
}



@end






