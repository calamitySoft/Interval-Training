//
//  Settings.m
//  OTG-Chords
//
//  Created by Logan Moseley on 11/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Settings.h"
#import "SynthesizeSingleton.h"
#import "LoadFromFile.h"

@implementation Settings

SYNTHESIZE_SINGLETON_FOR_CLASS(Settings);	// necessary for singelton-ness. DO NOT REMOVE.

@synthesize userDefaults, currentDifficulty, isArpeggiated, allowInversions, enabledRoot;

#define kIsArpeggiated		@"isArpeggiated"
#define kAllowInversions	@"allowInversions"
#define kEnabledRoot		@"enabledRoot"
#define kCurrentDifficulty	@"currentDifficulty"

- (id)init {
	/*** Get and use user settings ***/
	self.userDefaults = [NSUserDefaults standardUserDefaults];
	
	// We care about saving these settings:
	//	isArpeggiated, allowInversions, customDifficulty, currentDifficulty, and enabledRoot
	// Notice: We do NOT care about enabledChords, as it is taken care of in
	//	setCurrentDifficulty.

	NSString *testValue = [self.userDefaults stringForKey:kCurrentDifficulty];
	if (testValue != nil) {
		[self setIsArpeggiated:[self.userDefaults boolForKey:kIsArpeggiated]];
		[self setAllowInversions:[self.userDefaults boolForKey:kAllowInversions]];
		[self setEnabledRoot:[self.userDefaults stringForKey:kEnabledRoot]];
		NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[self.userDefaults arrayForKey:kCustomDifficulty]];
		[self setCustomDifficulty:tempArray];
		[self setCurrentDifficulty:[self.userDefaults stringForKey:kCurrentDifficulty]];
	}

	else {
		[self setIsArpeggiated:FALSE];
		[self setAllowInversions:YES];
		[self customDifficulty];				// invoke customDifficulty so that we can set the obj below
		[self setCurrentDifficulty:kEasyDifficulty];
		
		// Set all of the userDefaults we load to something.
		// We don't want testValue!=nil and have one of them missing. (-> maybe crash?)
		[self.userDefaults setBool:self.isArpeggiated forKey:kIsArpeggiated];
		[self.userDefaults setBool:self.allowInversions forKey:kAllowInversions];
		[self.userDefaults setObject:self.enabledRoot forKey:kEnabledRoot];
		[self.userDefaults setObject:self.customDifficulty forKey:kCustomDifficulty];
		[self.userDefaults setObject:self.currentDifficulty forKey:kCurrentDifficulty];
		[self.userDefaults synchronize];
	}
	
	return self;
}

- (void)dealloc {
	[chordNames release];
	[enabledRoot release];
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
	NSDictionary *rawConfigDict = [NSDictionary dictionaryWithContentsOfFile:thePath];
	NSDictionary *difficultyDict = [NSDictionary dictionaryWithDictionary:[rawConfigDict objectForKey:_difficulty]];
	
	for (NSUInteger i=0; i<[self.chordNames count]; i++) {
		NSString *chordName = [self.chordNames objectAtIndex:i];
		Boolean isEnabled = [[difficultyDict valueForKey:chordName] boolValue];		
		[tempArray addObject:[NSNumber numberWithBool:isEnabled]];
	}
	
	[tempArray autorelease];
	
	return tempArray;
}

- (NSUInteger)numChordsEnabledInCustomDifficulty {
	NSUInteger numEnabled = 0;
	NSEnumerator *e = [self.customDifficulty objectEnumerator];
	NSNumber *obj;
	while (obj = [e nextObject]) {
		if ([obj boolValue]) {
			numEnabled++;
		}
	}
	
	return numEnabled;
}

#pragma mark -
#pragma mark Inter-file Methods

/*
 *	enabledChordsByName
 *
 *	Purpose:	Currently used in MainVC to show the correct answer options
 *	Returns:	NSArray of NSStrings -- ONLY the ones enabled.
 *				[enabledChordsByName count] should == [numChordsEnabled]
 */
- (NSArray*)enabledChordsByName {
	NSMutableArray *enabledChordNames = [[NSMutableArray alloc] init];
	for (NSUInteger i=0; i<[self.chordNames count] && i<[self.enabledChords count]; i++) {
		if ([[self.enabledChords objectAtIndex:i] boolValue]) {
			[enabledChordNames addObject:[self.chordNames objectAtIndex:i]];
		}
	}
	
	// there should always be at least one chord enabled
	// but this guards against 0 enabled anyway
	if ([enabledChordNames count]==0) {
		[enabledChordNames release];
		return nil;
	}
	
	[enabledChordNames autorelease];
		
	return (NSArray*)enabledChordNames;
}


/*
 *	numChordsEnabled
 *
 *	Purpose:	Exactly like the private numChordsEnabledInCustomDifficulty,
 *				except it's public and for current difficulty only.
 */
- (NSUInteger)numChordsEnabled {
	NSUInteger numEnabled = 0;
	NSEnumerator *e = [self.enabledChords objectEnumerator];
	NSNumber *obj;
	while (obj = [e nextObject]) {
		if ([obj boolValue]) {
			numEnabled++;
		}
	}
	
	return numEnabled;
}


- (BOOL)chordIsEnabled:(NSString*)_chordName {
	NSString *str;
	for (str in [self enabledChordsByName]) {
		if ([str isEqualToString:_chordName]) {
			return YES;
		}
	}
	return NO;
}


/*
 *	setCustomDifficultyAtIndex: toValue:
 *
 *	Purpose:	Allows other classes/views to change the settings one at a time.
 *	Arguments:	(NSUInteger)_index:	index of self.customDifficulty
 *				(BOOL)_value:		chord is ON/OFF
 *	Returns:	(BOOL):				1 if the change leaves >=1 chord enabled
 *									0 if there would be 0 chords enabled
 *										(the last chord is NOT disabled)
 */
- (BOOL)setCustomDifficultyAtIndex:(NSUInteger)_index toValue:(BOOL)_value {
	
	// If making the change would mean 0 chords enabled
	if (_value == FALSE && [self numChordsEnabledInCustomDifficulty] == 1) {
		return 0;
	}
	
	// All other situations should be acceptable
	else {
		NSNumber *tempValue = [[NSNumber alloc] initWithBool:_value];
		[self.customDifficulty replaceObjectAtIndex:_index withObject:tempValue];
		[tempValue release];
		
		// Set user default
		[self.userDefaults setObject:self.customDifficulty forKey:kCustomDifficulty];
		[self.userDefaults synchronize];
		
		return 1;
	}
}

- (char)getDifficulty {
	char char0 = [self.currentDifficulty characterAtIndex:0];
	NSLog(@"\t\t(Settings)\t\t%c", char0);
	
	return char0;
}

- (NSUInteger)getDifficultyAsUInt {
	// easy
	if ([self.currentDifficulty isEqualToString:kEasyDifficulty]) {
		return 0;
	}
	
	// medium
	else if ([self.currentDifficulty isEqualToString:kMediumDifficulty]) {
		return 1;
	}
	
	// hard
	else if ([self.currentDifficulty isEqualToString:kHardDifficulty]) {
		return 2;
	}
	
	// custom
	else if ([self.currentDifficulty isEqualToString:kCustomDifficulty]) {
		return 3;
	}
	
	else {
		return 4;
	}
}

- (void)setDifficulty:(char)_difficulty {
	switch (_difficulty) {
		case 'e':
			[self setCurrentDifficulty:kEasyDifficulty];
			break;
		case 'm':
			[self setCurrentDifficulty:kMediumDifficulty];
			break;
		case 'h':
			[self setCurrentDifficulty:kHardDifficulty];
			break;
		case 'c':
			[self setCurrentDifficulty:kCustomDifficulty];
			break;
		default:
			break;
	}	
}

- (void)setDifficultyWithUInt:(NSUInteger)_difficulty {
	switch (_difficulty) {
		case 0:
			[self setCurrentDifficulty:kEasyDifficulty];
			break;
		case 1:
			[self setCurrentDifficulty:kMediumDifficulty];
			break;
		case 2:
			[self setCurrentDifficulty:kHardDifficulty];
			break;
		case 3:
			[self setCurrentDifficulty:kCustomDifficulty];
			break;
		default:
			break;
	}
}


#pragma mark -
#pragma mark Accessor Methods

/*
 *	lazy init of our vars
 */

- (NSArray*)chordNames {
	if (chordNames == nil) {
		NSString *thePath = [[NSBundle mainBundle]  pathForResource:@"Config" ofType:@"plist"];
		NSDictionary *rawConfigDict = [[NSDictionary alloc] initWithContentsOfFile:thePath];
		chordNames = [rawConfigDict objectForKey:@"ChordNames"];
		[chordNames retain];
		[rawConfigDict release];
	}
	return chordNames;
}

#pragma mark -

- (void)setIsArpeggiated:(BOOL)_isArpeggiated {
	isArpeggiated = _isArpeggiated;
	
	// Set user default
	[self.userDefaults setBool:isArpeggiated forKey:kIsArpeggiated];
	[self.userDefaults synchronize];
}

- (void)setAllowInversions:(BOOL)_allowInversions {
	allowInversions = _allowInversions;
	
	// Set user default
	[self.userDefaults setBool:allowInversions forKey:kAllowInversions];
	[self.userDefaults synchronize];
}

#pragma mark -

- (NSString*)enabledRoot {
	if (enabledRoot == nil) {
		NSString *temp = [[NSString alloc] initWithString:@"any"];
		[self setEnabledRoot:temp];
		[temp release];
	}
	return enabledRoot;
}

- (void)setEnabledRoot:(NSString *)_enabledRoot {
	if (enabledRoot	!= _enabledRoot) {
		[_enabledRoot retain];
		[enabledRoot release];
		enabledRoot = _enabledRoot;
	}
	
	// Set user default
	[self.userDefaults setObject:enabledRoot forKey:kEnabledRoot];
	[self.userDefaults synchronize];
}

#pragma mark -

- (NSArray*)easyDifficulty {
	if (easyDifficulty == nil) {
		easyDifficulty = [self loadDifficulty:kEasyDifficulty];			// returns an autoreleased (+0 retain count) object
		[easyDifficulty retain];
	}
	return easyDifficulty;
}

- (NSArray*)mediumDifficulty {
	if (mediumDifficulty == nil) {
		mediumDifficulty = [self loadDifficulty:kMediumDifficulty];		// returns an autoreleased (+0 retain count) object
		[mediumDifficulty retain];
	}
	return mediumDifficulty;
}

- (NSArray*)hardDifficulty {
	if (hardDifficulty == nil) {
		hardDifficulty = [self loadDifficulty:kHardDifficulty];			// returns an autoreleased (+0 retain count) object
		[hardDifficulty retain];
	}
	return hardDifficulty;
}

- (NSMutableArray*)customDifficulty {
    if (customDifficulty == nil) {
		customDifficulty = (NSMutableArray*) [self loadDifficulty:kCustomDifficulty];	// returns an autoreleased (+0 retain count) object
		[customDifficulty retain];
    }
    return customDifficulty;	
}

- (void)setCustomDifficulty:(NSMutableArray *)_customDifficulty {
	if (customDifficulty != _customDifficulty) {
		[_customDifficulty retain];
		[customDifficulty release];
		customDifficulty = _customDifficulty;
		
		// Set user default
		[self.userDefaults setObject:customDifficulty forKey:kCustomDifficulty];
		[self.userDefaults synchronize];
	}
}

- (NSString*)currentDifficulty {
	if (currentDifficulty == nil) {
		currentDifficulty = kEasyDifficulty;
	}
	return currentDifficulty;
}

- (void)setCurrentDifficulty:(NSString*)_difficulty {
	if (currentDifficulty != _difficulty) {
		[_difficulty retain];
		[currentDifficulty release];
		currentDifficulty = _difficulty;
		
		// easy
		if ([_difficulty isEqualToString:kEasyDifficulty]) {
			[self setEnabledChords:self.easyDifficulty];
		}
		
		// medium
		else if ([_difficulty isEqualToString:kMediumDifficulty]) {
			[self setEnabledChords:self.mediumDifficulty];
		}
		
		// hard
		else if ([_difficulty isEqualToString:kHardDifficulty]) {
			[self setEnabledChords:self.hardDifficulty];
		}
		
		// custom
		else if ([_difficulty isEqualToString:kCustomDifficulty]) {
			[self setEnabledChords:self.customDifficulty];
		}
		
		// default
		else {
			[self setEnabledChords:self.easyDifficulty];
		}
		
		NSLog(@"(Settings)Difficulty is now %@", currentDifficulty);
		
		// Set user default
		[self.userDefaults setObject:currentDifficulty forKey:kCurrentDifficulty];
		[self.userDefaults synchronize];
	}
}

#pragma mark -

- (NSArray*)enabledChords {
	if (enabledChords == nil) {
		enabledChords = self.easyDifficulty;
	}
	return enabledChords;
}

- (void)setEnabledChords:(NSArray*)_enabledChords; {
	if (enabledChords != _enabledChords) {
		[_enabledChords retain];
		[enabledChords release];
		enabledChords = _enabledChords;
	}
}



@end






