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
		OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &wholeSample);
		
		if(err != kAudioServicesNoError)
			NSLog(@"Could not load %@, error code: %d", soundURL, err);
	}
	
	[self setNoteName:_noteName];
	[self setHertz:_hertz];

	return self;
}

#pragma mark -
#pragma mark Playing Sounds

- (void)playNote:(NSString *)theNote
{
	// This function will determine and call the proper play function in future apps
	[self playWhole];
	}

void completionCallback (SystemSoundID  mySSID, void* myself) {
	AudioServicesRemoveSystemSoundCompletion (mySSID);
	NSNotification *note = [NSNotification notificationWithName:@"NotePlayed" object:myself
													   userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotification:note];
}

- (void)playWhole
{
	AudioServicesAddSystemSoundCompletion (wholeSample,NULL,NULL,
										   completionCallback,
										   (void*) self);
	AudioServicesPlaySystemSound(wholeSample);
}

- (void)playHalf
{
	AudioServicesPlaySystemSound(halfSample);
}

- (void)playQuarter
{
	AudioServicesPlaySystemSound(quarterSample);
}

- (void)playEighth
{
	AudioServicesPlaySystemSound(eighthSample);
}

- (void)playSixteenth
{
	AudioServicesPlaySystemSound(sixteenthSample);
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
