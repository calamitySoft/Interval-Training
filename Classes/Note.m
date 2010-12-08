//
//  note.m
//  NoteToFreq
//
//  Created by Sam on 7/31/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Note.h"


@implementation Note

@synthesize hertz, noteName;

- (id)init
{
	Note *newNote = [[Note alloc] initWithNoteName:@"A4" withHertz:440];

	return newNote;
}

-(void)dealloc
{
	[noteName release];

	
	[super dealloc];
}

- (id)initWithNoteName:(NSString *)_noteName withHertz:(float)_hertz
{
	self = [super init];
	
	if(!self)
		return nil;
	
	NSLog(@"Initializing note with noteName=%@", _noteName);
	
	// Get the filepath to _noteName (whole note).
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:[_noteName stringByAppendingString:@"W"] ofType:@"aif"];
	
	if(soundPath)
	{
		// Create a sound ID at var wholeSample.
		NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
		wholeSample = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
		[wholeSample setDelegate:self];
	}
	[self setNoteName:_noteName];
	[self setHertz:_hertz];

	return self;
}

#pragma mark -
#pragma mark Playing Sounds

- (void)playNote:(NSString *)theNote
{
	NSLog(@"(Note) Play %@", theNote);
	
	// This function will determine and call the proper play function in future apps
	[self playWhole];
}

// I'll fill this function out more later.
-(void)stop
{
	[wholeSample stop];
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
	NSNotification *note = [NSNotification notificationWithName:@"NotePlayed" object:player
													   userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)playWhole
{
	[wholeSample play];
}

- (void)playHalf
{
	[halfSample play];
}

- (void)playQuarter
{
	[quarterSample play];
}

- (void)playEighth
{
	[eighthSample play];
}

- (void)playSixteenth
{
	[sixteenthSample play];
}


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
