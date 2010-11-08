//
//  Interval_TrainingAppDelegate.m
//  Interval-Training
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "Interval_TrainingAppDelegate.h"
#import "MainViewController.h"

@implementation Interval_TrainingAppDelegate


@synthesize window;
@synthesize mainViewController;
@synthesize myDJ, aNoteStrings, aEnabledIntervals, enabledRoot, iCurRoot, iCurTarget, cDifficulty, scoreBoard;

#define INTERVAL_RANGE 13	// defines how many intervals we can have. 13 half tones --> unison to octave

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.  
	[self initMyVars];
	[self generateQuestion];

    // Add the main view controller's view to the window and display.
    [window addSubview:mainViewController.view];
    //[window addSubview:FlipsideViewController.view];
	
	[window makeKeyAndVisible];
	
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: nil
						  message: @"Use the bottom half to select\nyour interval answer."
						  delegate: nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
    return YES;
}

- (void)initMyVars {
	/*** Initialize myDJ ***/
	DJ *tempDJ = [[DJ alloc] init];
	[self setMyDJ:tempDJ];
	[tempDJ release];
	[myDJ echo];	// Verify myDJ has been initialized correctly. (Print to NSLog)
	
	Scorekeeper *tempScore = [[Scorekeeper alloc] initScore];
	[self setScoreBoard:tempScore];
	[tempScore release];
	
	/*** Initialize aNoteStrings ***/
	NSArray *noteNames = [[NSArray alloc] initWithObjects:@"C",@"C#",@"D",@"D#",@"E",
						  @"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil];
	NSArray *noteOctaves = [[NSArray alloc] initWithObjects:@"2",@"3",@"4",nil];
		// This is mutable because we want to be changing it. Previous solution was
		// NSArray alloc init'd pointer that was pointing to larger and larger arrays.
		// That may have only been part of the crashing problem, but I think this is
		// more proper anyway.
	NSMutableArray *tempNoteStrings = [[NSMutableArray alloc] initWithCapacity:1];
	for(NSUInteger i = 0; i < [noteOctaves count]; i++)
	{
		for (NSUInteger k = 0; k < [noteNames count]; k++) 
		{
			NSString *tempStr = [[NSString alloc] initWithString:[[noteNames objectAtIndex:k] stringByAppendingString:[noteOctaves objectAtIndex:i]]];
			[tempNoteStrings addObject:tempStr];
		}
	}
	//NSString *tempStrA3 = [[NSString alloc] initWithString:@"A3"];
	[self setANoteStrings:tempNoteStrings];
	[tempNoteStrings release];
	
	
	/*** Create array for determining which notes have been enabled ***/
	// initially all disabled
	aEnabledIntervals = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i < INTERVAL_RANGE; i++) {
		[aEnabledIntervals addObject:[NSNumber numberWithInt:0]];
	}
	[self setAllIntervals:[NSNumber numberWithInt:0]];
	
	
	/*** Initialize array of interval names ***/
	intervalStrings = [[NSArray alloc] initWithObjects:@"Unison", @"Minor\nSecond", @"Major\nSecond",
					   @"Minor\nThird", @"Major\nThird", @"Perfect\nFourth", @"Tritone",
					   @"Perfect\nFifth", @"Minor\nSixth", @"Major\nSixth", @"Minor\nSeventh",
					   @"Major\nSeventh", @"Octave", nil];
	
	
	/*** Set default difficulty - easy. ***/
	[self setDifficulty:'e'];
	
	
	/*** Set default root - any. ***/
	[self setEnabledRoot:@"any"];
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

/*
 - (void)init {
	aNoteStrings = [[NSArray alloc] initWithObjects:[[NSString alloc ]initWithString:@"A"], nil];
}*/

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[myDJ release];
	[aNoteStrings release];
	[enabledRoot release];
	[iCurRoot release];
	[iCurTarget release];
	
    [mainViewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark App Delegation

- (void)generateQuestion{
	NSLog(@"**** New Question ****");
	[self selectNextRoot];
	[self replayNote];
}	

- (void)replayNote {
	NSLog(@"(Delegate) replayNote: root = %d, tar = %d", [iCurRoot intValue], [iCurTarget intValue]);
	[myDJ playNote:[aNoteStrings objectAtIndex:[iCurRoot intValue]]];
	[myDJ playNote:[aNoteStrings objectAtIndex:[iCurTarget intValue]]];
}


/*
 *	selectNextRoot
 *
 *	Purpose:	
 */
- (void)selectNextRoot {
	NSLog(@"(Delegate) aNoteStrings count = %i", [aNoteStrings count]);
	
	
	// Generate a valid root.
	NSUInteger tempRootInt;
	do {
		tempRootInt = arc4random() % ([aNoteStrings count] - INTERVAL_RANGE);	// pick random note that'd be within our array
	} while (![self rootIsEnabled:tempRootInt]);
	[self setICurRoot:[NSNumber numberWithUnsignedInteger:tempRootInt]];	// once the loop finding is complete, use it
	
	
	NSLog(@"(Delegate) selectNextRoot: %i (%@) (random() mod %i)",
		  [iCurRoot intValue],
		  [aNoteStrings objectAtIndex:[iCurRoot intValue]],
		  [aNoteStrings count]);
	[self selectNextTarget];
}

- (void)selectNextTarget {
	// Generate a target interval.
	NSUInteger tempInterval;	// we don't have to use an NSNumber here
	do {
		tempInterval = arc4random() % INTERVAL_RANGE;	// mod 13 for the size of an octave+1
														// we're constraining from unison to octave
	} while (![self intervalIsEnabled:tempInterval]);
	
	
	// Add the temp dude to root to get the target
	tempInterval += [iCurRoot intValue];
	[self setICurTarget:[NSNumber numberWithUnsignedInteger:tempInterval]];
		
	
	NSLog(@"(Delegate) selectNextTarget: %i (%@)",
		  [iCurTarget intValue],
		  [aNoteStrings objectAtIndex:[iCurTarget intValue]]);
}
		
- (void)setDifficulty:(char)theDiff {
	if (cDifficulty != theDiff) {
		[self setAllIntervals:[NSNumber numberWithInt:0]];
		NSNumber* trueValue = [NSNumber numberWithInt:1];
		[self setCDifficulty:theDiff];
		
		switch (theDiff) {
			case 'e':
				[aEnabledIntervals replaceObjectAtIndex:0 withObject:trueValue];	// Unison
				[aEnabledIntervals replaceObjectAtIndex:3 withObject:trueValue];	// Minor Third
				[aEnabledIntervals replaceObjectAtIndex:4 withObject:trueValue];	// Major Third
				[aEnabledIntervals replaceObjectAtIndex:7 withObject:trueValue];	// Perfect Fifth
				[aEnabledIntervals replaceObjectAtIndex:12 withObject:trueValue];	// Octave
				break;
			case 'm':
				[aEnabledIntervals replaceObjectAtIndex:0 withObject:trueValue];	// Unison
				[aEnabledIntervals replaceObjectAtIndex:2 withObject:trueValue];	// Major Second
				[aEnabledIntervals replaceObjectAtIndex:3 withObject:trueValue];	// Minor Third
				[aEnabledIntervals replaceObjectAtIndex:4 withObject:trueValue];	// Major Third
				[aEnabledIntervals replaceObjectAtIndex:5 withObject:trueValue];	// Perfect Fourth
				[aEnabledIntervals replaceObjectAtIndex:7 withObject:trueValue];	// Perfect Fifth
				[aEnabledIntervals replaceObjectAtIndex:8 withObject:trueValue];	// Minor Sixth
				[aEnabledIntervals replaceObjectAtIndex:9 withObject:trueValue];	// Major Sixth
				break;
			case 'h':
				[self setAllIntervals:trueValue];
				break;

			default:
				break;
		}
		[trueValue release];
	}
	NSLog(@"(Delegate) Just changed the difficulty to %c", theDiff);
}

- (void)printDifficulty {
	NSLog(@"******************");
	NSLog(@"** cDifficulty: %c\n", cDifficulty);
	NSLog(@"** index\tenabled?");
	int i=0;
	for (NSNumber *num in aEnabledIntervals) {
		NSLog(@"** %i\t\t%i", i, [num intValue]);
		i++;
	}
}

-(NSString*) getScoreString
{
	NSString *temp = [NSString stringWithFormat:@"%@ out of %@ (%@)",
					  [[scoreBoard iNumSuccesses] stringValue],
					  [[scoreBoard iNumAttempts] stringValue],
					  [scoreBoard percentage]];
//	[temp autorelease];		// This was the cause of the crash. I believe [NSString stringWithString:] returns
							//  a string which is already marked for "autorelease".  This either duped that
							//  functionality-->crash or it actually released it from memory-->crash.
	return temp;
}

/*
 *	submitAnswer:
 *
 *	Takes an interval, does scorekeeping, then tells the caller
 *	whether the interval was correct.
 *
 *	Usually methods that return something say it in the name,
 *	e.g. [NSString stringWithString:], but that'd be saying it
 *	doesn't do the scorekeeping.  Stuck with more general name.
 */
- (BOOL)submitAnswer:(NSUInteger)intervalGuessed{
	if ([self getCurrentInterval] == intervalGuessed) {	// if it's the right answer
		[self.scoreBoard success];
		return TRUE;
	}
	
	else {		// if it's the wrong answer
		[self.scoreBoard failure];
		return FALSE;
	}
}


#pragma mark -
#pragma mark Interval Control

- (int)getCurrentInterval {
	return [iCurTarget intValue]-[iCurRoot intValue];
}

- (void)setAllIntervals:(NSNumber *)mode {
	for (NSUInteger i = 0; i < 13; i++) {
		[aEnabledIntervals replaceObjectAtIndex:i withObject:mode];
	}
}


- (BOOL)intervalIsEnabled:(NSUInteger)distance {
	// NSUInteger will always be >=0
	if (distance >= INTERVAL_RANGE) {  // must be >= 0 or < range (because 0 is valid)
		return false;
	}
	
	if([[aEnabledIntervals objectAtIndex:distance]boolValue]) {	// don't know why this wasn't working before.
//		NSLog(@"The interval %d is enabled!",distance);
		return true;
	}
	else {
		return false;
	}
}


- (NSString *)intervalDifferenceBetween:(NSNumber *)first And:(NSNumber *)second {
	interval theInterval = [second intValue] - [first intValue];
	NSLog(@"(Delegate) The target is: %i the root is: %i", [second intValue], [first intValue]);
	
	if (theInterval<0 || theInterval>=INTERVAL_RANGE)	// must be >= 0 or < range (because 0 is valid)
		return @"Invalid interval";
	return [intervalStrings objectAtIndex:theInterval];
}


#pragma mark -
#pragma mark Root Control

//	Is aNoteStrings[root] an allowed root to use?
//	use enabledRoot to determine
- (BOOL)rootIsEnabled:(NSUInteger)root {
	
	// if ANY root is acceptable
	if ([enabledRoot isEqualToString:@"any"]) { return TRUE; }
	
	// if enabledRoot is specified, check if given root is valid
	else {
		NSString *tempRootStr = [aNoteStrings objectAtIndex:root];		// convert rand() to usable str for checking
			// removes octave num from the end, so any note that's, say, "C" will do.
		if ([enabledRoot isEqualToString:[tempRootStr substringToIndex:[tempRootStr length]-1]])
			return TRUE;
	}
	
	return FALSE;
}


@end
