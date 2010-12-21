//
//  OTG_ChordsAppDelegate.m
//  OTG-Intervals
//
//  Created by Logan Moseley on 8/20/10.
//  Copyright CalamitySoft 2010. All rights reserved.
//

#import "OTG_IntervalsAppDelegate.h"
#import "MainViewController.h"
#import "Settings.h"
#import "LoadFromFile.h"

@implementation OTG_IntervalsAppDelegate


@synthesize window;
@synthesize mainViewController;
@synthesize myDJ, myChord, scoreBoard;

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
	
	
	/*** Initialize myChord ***/
	Chord *tempChord = [[Chord alloc] init];
	[self setMyChord:tempChord];
	[tempChord release];
	[myChord echo];
	
	
	/*** Initialize scoreBoard ***/
	Scorekeeper *tempScore = [[Scorekeeper alloc] initScore];
	[self setScoreBoard:tempScore];
	[tempScore release];
	
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
	[myChord release];
	[scoreBoard release];
	
    [mainViewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark App Delegation

- (void)generateQuestion{
	NSLog(@"**** New Question ****");
	
	NSArray *chordToPlay = [myChord createChord];
	if (chordToPlay == nil) {
		NSLog(@"Interval could not be generated.");
	} else {
		[self replayNote];
	}
}	

- (void)replayNote {
	[myDJ stop];
	[myDJ playNotes:[myChord chord] isArpeggiated:[[Settings sharedSettings] isArpeggiated]];
}

- (void)arpeggiate{
	[myDJ stop];
	[myDJ playNotes:[myChord chord] isArpeggiated:![[Settings sharedSettings] isArpeggiated]];
}

- (void)setDifficulty:(char)theDiff {			
	switch (theDiff) {
		case 'e':
			[[Settings sharedSettings] setCurrentDifficulty:kEasyDifficulty];
			break;
		case 'm':
			[[Settings sharedSettings] setCurrentDifficulty:kMediumDifficulty];
			break;
		case 'h':
			[[Settings sharedSettings] setCurrentDifficulty:kHardDifficulty];
			break;
		case 'c':
			[[Settings sharedSettings] setCurrentDifficulty:kCustomDifficulty];
			break;
		default:
			break;
	}
	
	NSLog(@"(Delegate) Just changed the difficulty to %c", theDiff);
}

- (void)printDifficulty {
	NSLog(@"******************");
	NSLog(@"** cDifficulty: %@\n", [[Settings sharedSettings] currentDifficulty]);
	NSLog(@"** index\tenabled?");
	int i=0;
	for (NSNumber *num in [[Settings sharedSettings] enabledChords]) {
		NSLog(@"** %@\t\t%i", [[[Settings sharedSettings] chordNames] objectAtIndex:i], [num intValue]);
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
 *	Takes a string, does scorekeeping, then tells the caller
 *	whether the string was correct.
 *
 *	Usually methods that return something say it in the name,
 *	e.g. [NSString stringWithString:], but that'd be saying it
 *	doesn't do the scorekeeping.  Stuck with more general name.
 */
- (BOOL)submitAnswer:(NSString*)chordTypeGuessed{
	if ([[myChord chordType] isEqualToString:chordTypeGuessed]) {	// if it's the right answer
		[self.scoreBoard success];
		return TRUE;
	}
	
	else {		// if it's the wrong answer
		[self.scoreBoard failure];
		return FALSE;
	}
}



@end
