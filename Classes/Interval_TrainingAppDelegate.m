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
@synthesize myDJ, aNoteStrings, iCurRoot, iCurTarget, cDifficulty;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.  

    // Add the main view controller's view to the window and display.
    [window addSubview:mainViewController.view];
    //[window addSubview:FlipsideViewController.view];
	
	[window makeKeyAndVisible];
	
	[mainViewController showInfo:self];
	
	[mainViewController displayInterval:@"Tritone"];
	
	[self initMyVars];
	
	[self selectNextNote];
	
	[self replayNote];
	
    return YES;
}

- (void)initMyVars {
	// Initialize myDJ
	DJ *tempDJ = [[DJ alloc] init];
	[self setMyDJ:tempDJ];
	[tempDJ release];
	
	[myDJ echo];	// Verify myDJ has been initialized correctly. (Print to NSLog)
	
	// Initialize aNoteStrings
	NSString *tempStr = [[NSString alloc] initWithString:@"A"];
	NSArray *tempNoteStrings = [[NSArray alloc] initWithObjects:tempStr, nil];
	[self setANoteStrings:tempNoteStrings];
	[tempNoteStrings release];
	[tempStr release];
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

- (void)replayNote {
	NSLog(@"Hello from delegate, replayNote.");
	[myDJ playNote:[aNoteStrings objectAtIndex:[iCurRoot intValue]]];
}

- (void)selectNextNote {
	[self setICurRoot:[NSNumber numberWithInt:random() % [aNoteStrings count]]];
}

- (void)selectNextTarget {
	[self setICurTarget:[NSNumber numberWithInt:random() % [aNoteStrings count]]];
	while([iCurTarget compare:iCurRoot] == 1 ) {
		[self setICurTarget:[NSNumber numberWithInt:random () % [aNoteStrings count]]];
	}
	
}
		
- (void)setDifficulty:(char)theDiff{
	[self setCDifficulty:theDiff];
	NSLog(@"Just changed the difficulty to %c", theDiff);
}

@end
