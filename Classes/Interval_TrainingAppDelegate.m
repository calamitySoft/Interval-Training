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
@synthesize myDJ, aNoteStrings, aEnabledIntervals, iCurRoot, iCurTarget, cDifficulty;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.  

    // Add the main view controller's view to the window and display.
    [window addSubview:mainViewController.view];
    //[window addSubview:FlipsideViewController.view];
	
	[window makeKeyAndVisible];
		
	[self initMyVars];
	
	[self generateQuestion];
	
    return YES;
}

- (void)initMyVars {
	/*** Initialize myDJ ***/
	DJ *tempDJ = [[DJ alloc] init];
	[self setMyDJ:tempDJ];
	[tempDJ release];
	
	[myDJ echo];	// Verify myDJ has been initialized correctly. (Print to NSLog)
	
	
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
	
	// Creates array for determining which notes have been enabled
	aEnabledIntervals = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i < 13; i++) {
		[aEnabledIntervals addObject:[NSNumber numberWithInt:0]];
	}
	[self setAllIntervals:[NSNumber numberWithInt:0]];
	
	// Initialize default difficulty - easy.
	[self setCDifficulty:'m'];
	[self setDifficulty:'e'];
	
	/*** Initialize interval array ***/
	intervalStrings = [[NSArray alloc] initWithObjects:@"Unison", @"Minor\nSecond", @"Major\nSecond",
					   @"Minor\nThird", @"Major\nThird", @"Perfect\nFourth", @"Tritone",
					   @"Perfect\nFifth", @"Minor\nSixth", @"Major\nSixth", @"Minor\nSeventh",
					   @"Major\nSeventh", nil];
	
	
	/*** Initialize default difficulty - easy. ***/
	[self setCDifficulty:'e'];
}

-(void) setAllIntervals:(NSNumber *)mode
{
	for (NSUInteger i = 0; i < 13; i++) {
		[aEnabledIntervals replaceObjectAtIndex:i withObject:mode];
	}
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
		// count-12 because the target could be anywhere within the octave above the root
	[self setICurRoot:[NSNumber numberWithInt:arc4random() % ([aNoteStrings count]-12)]];
	NSLog(@"(Delegate) selectNextRoot: %i (%@) (random() mod %i)",
		  [iCurRoot intValue],
		  [aNoteStrings objectAtIndex:[iCurRoot intValue]],
		  [aNoteStrings count]);
	[self selectNextTarget];
	
}

- (void)selectNextTarget {
	// Generate a target note.
	int tempInterval;	// so we don't have to use an NSNumber here
	do {
		tempInterval = arc4random()%12;	// mod 12 for the size of an octave
										// we're constraining to one octave
	} while (![self intervalIsEnabled:[NSNumber numberWithInt:tempInterval]]);
	
	tempInterval += [iCurRoot intValue];	// add the dude to root to get the target
	[self setICurTarget:[NSNumber numberWithInt:tempInterval]];	// which is set here

	
	NSLog(@"(Delegate) selectNextTarget: %i (%@)",
		  [iCurTarget intValue],
		  [aNoteStrings objectAtIndex:[iCurTarget intValue]]);
}

- (int)getCurrentInterval {
	return [iCurTarget intValue]-[iCurRoot intValue];
}
		
- (void)setDifficulty:(char)theDiff{
	if (cDifficulty != theDiff) {
		[self setAllIntervals:[NSNumber numberWithInt:0]];
		NSNumber* trueValue = [NSNumber numberWithInt:1];
		[self setCDifficulty:theDiff];
		
		switch (theDiff) {
			case 'e':
				[aEnabledIntervals replaceObjectAtIndex:0 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:3 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:4 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:7 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:12 withObject:trueValue];
				break;
			case 'm':
				[aEnabledIntervals replaceObjectAtIndex:0 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:2 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:3 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:4 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:5 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:7 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:8 withObject:trueValue];
				[aEnabledIntervals replaceObjectAtIndex:9 withObject:trueValue];
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

-(BOOL)intervalIsEnabled:(NSNumber *)distance
{
	if ([distance intValue] > 12 || [distance intValue]< 0) {
		return false;
	}
	if([[aEnabledIntervals objectAtIndex:[distance intValue]]boolValue])
	{
		NSLog(@"The interval %d is enabled!",[distance intValue]);
		return true;
	}
	else {
		return false;
	}

}


-(NSString *) intervalDifferenceBetween:(NSNumber *)first And:(NSNumber *)second
{	
	interval theInterval = [second intValue] - [first intValue];
	NSLog(@"(Delegate) The target is: %i the root is: %i", [second intValue], [first intValue]);
	
	return [intervalStrings objectAtIndex:theInterval];
	NSLog(@"(ERROR) Couldn't use the array...");
	
	switch (theInterval) {
		case unison:
			return [NSString stringWithFormat:@"Unison"];
			break;
		case minSecond:
			return [NSString stringWithFormat:@"Minor\nSecond"];
			break;
		case majSecond:
			return [NSString stringWithFormat:@"Major\nSecond"];
			break;
		case minThird:
			return [NSString stringWithFormat:@"Minor\nThird"];
			break;
		case majThird:
			return [NSString stringWithFormat:@"Major\nThird"];
			break;
		case perFourth:
			return [NSString stringWithFormat:@"Perfect\nFourth"];
			break;
		case tritone:
			return [NSString stringWithFormat:@"Tritone"];
			break;
		case perFifth:
			return [NSString stringWithFormat:@"Perfect\nFifth"];
			break;
		case minSixth:	
			return [NSString stringWithFormat:@"Minor\nSixth"];
			break;
		case majSixth:
			return [NSString stringWithFormat:@"Major\nSixth"];
			break;
		case minSeventh:
			return [NSString stringWithFormat:@"Minor\nSeventh"];
			break;
		case majSeventh:
			return [NSString stringWithFormat:@"Major\nSeventh"];
			break;

		default:
			return [NSString stringWithFormat:@"(interval unknown)"];
			break;
	}
	return [NSString stringWithFormat:@"Interval nil?"];
}

@end
