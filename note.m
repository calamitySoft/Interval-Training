//
//  note.m
//  NoteToFreq
//
//  Created by Sam on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Note.h"


@implementation Note

@synthesize hertz, noteName;

-(id)init
{
	Note *newNote = [[Note alloc] initWithNoteName:@"A" withHertz:440];

	return newNote;
}

-(id)initWithNoteName:(NSString *)_noteName withHertz:(float)_hertz
{
	self = [super init];
	
	if(!self)
		return nil;
	
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:[_noteName stringByAppendingString:@"W"] ofType:@"wav"];
	
	if(soundPath)
	{
		NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
		
		OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &wholeSample);
		
		if(err != kAudioServicesNoError)
			NSLog(@"Could not load %@, error code: %d", soundURL, err);
	}
	
	[self setNoteName:_noteName];
	[self setHertz:_hertz];

	return self;
}

-(void) playNote:(NSString *)theNote
{
	// This function will determine and call the proper play function in future apps
	[self playWhole];
}



-(void) playWhole
{
	AudioServicesPlaySystemSound(wholeSample);
}

-(void) playHalf
{
	AudioServicesPlaySystemSound(halfSample);
}

-(void) playQuarter
{
	AudioServicesPlaySystemSound(quarterSample);
}

-(void) playEighth
{
	AudioServicesPlaySystemSound(eighthSample);
}

-(void) playSixteenth
{
	AudioServicesPlaySystemSound(sixteenthSample);
}
	
@end
