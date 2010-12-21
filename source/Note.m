//
//  Note.m
//  OTG-Intervals
//
//  Created by Sam on 7/31/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Note.h"


@implementation Note

@synthesize hertz, noteName, wholeSample;

- (id)init
{
	Note *newNote = [[Note alloc] initWithNoteName:@"A4" withHertz:440];
	NSLog(@"(Note) Created default note: A4");

	return newNote;
}

-(void)dealloc {
	[noteName release];
	[wholeSample release];
	
	[super dealloc];
}

- (id)initWithNoteName:(NSString *)_noteName {
	self = [super init];
	if (!self) return nil;
	
	NSLog(@"(Note) Initializing note with noteName=%@", _noteName);
	
	// Get the filepath to _noteName (whole note).
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:[_noteName stringByAppendingString:@"W"] ofType:@"wav"];
	
	if (soundPath) {
		// Create a sound ID at var wholeSample.
		NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
		AVAudioPlayer *tempPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
		tempPlayer.delegate = self;
		self.wholeSample = tempPlayer;
		[tempPlayer release];
	} else {
		NSLog(@"(Note) Error with soundPath");
	}
	
	[self setNoteName:_noteName];
	
	return self;
}

- (id)initWithNoteName:(NSString *)_noteName withHertz:(float)_hertz
{
	self = [super init];
	
	if(!self)
		return nil;
	
	NSLog(@"(Note) Initializing note with noteName=%@", _noteName);
	
	// Get the filepath to _noteName (whole note).
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:[_noteName stringByAppendingString:@"W"] ofType:@"wav"];
	
	if(soundPath)
	{
		// Create a sound ID at var wholeSample.
		NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
		self.wholeSample = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
		[self.wholeSample setDelegate:self];
	}
	else
	{
		NSLog(@"(Note) Error with soundPath");
	}

	[self setNoteName:_noteName];
	[self setHertz:_hertz];

	return self;
}

#pragma mark -
#pragma mark Playing Sounds

- (BOOL)playNote:(NSString *)duration
{
	NSLog(@"(Note) Play %@%@.wav", self.noteName, duration);
	
	// This function will determine and call the proper play function in future apps
	return [self playWhole];
}

- (BOOL)playNote:(NSString *)duration atTime:(NSTimeInterval)time {
	return [self.wholeSample playAtTime:time];
}

// I'll fill this function out more later.
-(void)stop
{
	[self.wholeSample stop];
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	NSNotification *note = [NSNotification notificationWithName:@"NotePlayed" object:player
													   userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotification:note];
}

- (BOOL)playWhole
{
	return [self.wholeSample play];
}

/*
- (BOOL)playHalf
{
	return [self.halfSample play];
}

- (BOOL)playQuarter
{
	return [self.quarterSample play];
}

- (BOOL)playEighth
{
	return [self.eighthSample play];
}

- (BOOL)playSixteenth
{
	return [self.sixteenthSample play];
}
 */


#pragma mark -
#pragma mark Helpers

- (void)echo {
	NSLog(@"Hello from Note with noteName=%@", noteName);
}


/*
 *	isEqual:
 *
 *	Purpose:	Overrides NSObject isEqual: to make it specific to noteName.
 *	Strategy:	[noteName isEqualToString:arg]
 *	Arguments:	(NSString *object) Comparison object.
 *	Returns:	(BOOL) YES if they're equal, otherwise NO.
 */
- (BOOL)isEqual:(NSString *)argStr {
	return [[self noteName] isEqualToString:argStr];
}

@end
