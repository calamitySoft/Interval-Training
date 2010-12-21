//
//  DJ.m
//  OTG-Intervals
//
//  Created by Sam on 8/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "DJ.h"
#import "Note.h"
#import "LoadFromFile.h"

@implementation DJ

@synthesize noteNames, viableNotes, noteStringsToPlay, noteObjectsToPlay, curNote;

#pragma mark Setup

- (id)init {
	self = [super init];
	if (!self)
		return nil;

	
	
	return self;
}

-(void)dealloc {
	[viableNotes release];
	[noteStringsToPlay release];
	[noteObjectsToPlay release];
	[super dealloc];
}



#pragma mark -
#pragma mark Runtime DJ Stuff


/*
 *	playNote:
 *
 *	Purpose:	Allows the DJ to be told what note to play.
 *	Strategy:	Finds the right Note in the noteBank, tells it to play.
 *	Arguments:	(NSString*) _note	A note name, such as "F2" or "A#4".
 *				(NSNumber*) _note	A note index, such a 24 (C4).
 *	Note:		if _note is a string:	init a Note with that name
 *				if _note is a number:	found out which name it corresponds to,
 *										init a Note with that name
 */
- (void)playNote:(NSObject*)_note {
	
	// If arg _note is an NSString
	if ([_note isKindOfClass:[NSString class]]) {
		NSLog(@"(DJ) playNote:%@", _note);
		Note *noteToPlay = [[Note alloc] initWithNoteName:(NSString*)_note];
		[noteToPlay playNote:@"W"];
		[noteToPlay release];
	}
	
	// If arg _note is an NSNumber
	else if ([_note isKindOfClass:[NSNumber class]]) {
		NSString *noteName = [self.noteNames objectAtIndex:[(NSNumber*)_note unsignedIntegerValue]];
		Note *noteToPlay = [[Note alloc] initWithNoteName:noteName];
		[noteToPlay playNote:@"W"];
		[noteToPlay release];
	}
	
	// If neither NSString or NSNumber
	else {
		NSLog(@"(DJ) playNote: arg not recognized as NSString or NSNumber");
		return;
	}
}



/*
 *	playNoteAtIndex:
 *
 *	Purpose:	Plays from self.noteObjectsToPlay
 */
- (BOOL)playNoteAtIndex:(NSUInteger)_index {
	if (self.noteObjectsToPlay == nil || [self.noteObjectsToPlay count] == 0) {
		return NO;
	}
	
	Note *noteToPlay = [self.noteObjectsToPlay objectAtIndex:_index];
	return [noteToPlay playNote:@"W"];
}



/*
 *	playNotes:
 *
 *	Purpose:	Allows the DJ to be told what notes to play.
 *	Strategy:	Finds the right Note in the noteBank, tells it to play.
 *	Arguments:	(NSString*) _note	A note name, such as "F2" or "A#4".
 *				(NSNumber*) _note	A note index, such a 24 (C4).
 *	Returns:	(BOOL)	were the notes successfully played?
 *	Note:		if _note is a string:	init a Note with that name
 *				if _note is a number:	found out which name it corresponds to,
 *										init a Note with that name
 */
-(BOOL)playNotes:(NSArray*)_notes isArpeggiated:(BOOL)isArpeggiated {
	
	if (_notes == nil) {
		return NO;
	}
	
	// If arg theNotes contains NSNumbers (not NSStrings)
	// convert them to NSStrings
	NSMutableArray *theNotes = [NSMutableArray arrayWithArray:_notes];
	NSObject *note;
	for (NSUInteger i = 0; i < [theNotes count]; i++) {
		note = [theNotes objectAtIndex:i];

		if ([note isKindOfClass:[NSNumber class]]) {
			NSString *noteName = [self.noteNames objectAtIndex:[(NSNumber*)note unsignedIntegerValue]];
			[theNotes replaceObjectAtIndex:i withObject:noteName];
		}
		
		else if (![note isKindOfClass:[NSString class]]) {
			NSLog(@"(DJ) arg class not recognized: %@", [note class]);
			return NO;
		}
	}
		
	
	//
	// Always make a new array.
	// This will restart the notes from the beginning.
	//
	if (self.noteObjectsToPlay) {
		for (Note *note in self.noteObjectsToPlay) {
			[note release];
		}
		self.noteObjectsToPlay = nil;
	}
	// Init the notes that will be played
	NSMutableArray *tempNoteArray = [[NSMutableArray alloc] initWithCapacity:[theNotes count]];
	for (NSString *noteName in theNotes) {
		Note *tempNote = [[Note	alloc] initWithNoteName:noteName];
		[tempNoteArray addObject:tempNote];
		[tempNote release];
	}
	self.noteObjectsToPlay = [[NSArray alloc] initWithArray:tempNoteArray];
	[tempNoteArray release];
	
	
	[self setNoteStringsToPlay:theNotes];
	
	
	// Play arpeggiated
	if(isArpeggiated)
	{
		self.curNote = 0;
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(playNextNote:) name:@"NotePlayed" object:nil];
		return [self playNoteAtIndex:curNote];
	}
	
	// Play chorded
	else {
		AVAudioPlayer *sampleToPlay = [[self.noteObjectsToPlay objectAtIndex:0] wholeSample];
		BOOL retVal = YES;

		
		// AVAudioPlayer.deviceCurrentTime is only available on iOS 4.0 or later.
		// If we're able to use it, we can get better chord playing.
		if ([sampleToPlay respondsToSelector:@selector(deviceCurrentTime)]) {
			NSTimeInterval shortStartDelay = 0.1;				// (seconds)
			NSTimeInterval now = sampleToPlay.deviceCurrentTime;
			NSTimeInterval playTime = now + shortStartDelay;
			
			// prepare to play
			Note *note;
			for (note in self.noteObjectsToPlay) {
				[[note wholeSample] prepareToPlay];
			}
			// play
			for (note in self.noteObjectsToPlay) {
				BOOL ret = [note playNote:@"W" atTime:playTime];
				retVal = retVal && ret;								// if any of the notes don't play, return NO
			}
		}

		
		// If we can't use deviceCurrentTime (iOS <4.0)
		// just play it straight
		else {
			// prepare to play
			Note *note;
			for (note in self.noteObjectsToPlay) {
				[[note wholeSample] prepareToPlay];
			}
			// play
			for (note in self.noteObjectsToPlay) {
				BOOL ret = [note playNote:@"W"];
				retVal = retVal && ret;								// if any of the notes don't play, return NO
			}
		}
		
		
		return retVal;
	}
}

-(void)stop
{
	if (self.noteObjectsToPlay) {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
//		NSUInteger noteBankIndexForGivenNote = [noteBank indexOfObject:[self.noteStringsToPlay objectAtIndex:curNote]]; // see function comment "Note"
//		[[noteBank objectAtIndex:noteBankIndexForGivenNote] stop];
		for (Note *note in self.noteObjectsToPlay) {
			[note stop];
		}
		self.curNote = 0;
	}
}

-(void)playNextNote:(NSNotification *)note
{
	self.curNote++;
	if (self.curNote < [self.noteObjectsToPlay count]) {
//		[self playNote:[self.noteObjectsToPlay objectAtIndex:curNote]];
		[self playNoteAtIndex:self.curNote];
	}
	else {
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		self.noteStringsToPlay = nil;
	}
}



#pragma mark -
#pragma mark Helpers

- (void)echo {
	NSLog(@"Hello from DJ");
}



#pragma mark -
#pragma mark Accessor Methods


- (NSArray*)noteNames {
	if (noteNames == nil) {
		
		NSError *loadError;
		NSDictionary *noteNameDict = (NSDictionary*) [LoadFromFile newObjectForKey:@"NoteNames" error:&loadError];
		if (!noteNameDict) {
			NSLog(@"(DJ) Error in loading note names: %@", [loadError domain]);
			return noteNames;
		}
		
		
		NSArray *notes = [[NSArray alloc] initWithArray:[noteNameDict objectForKey:@"Notes"]];
		NSArray *octaves = [[NSArray alloc] initWithArray:[noteNameDict objectForKey:@"Octaves"]];
		[noteNameDict release];
		NSMutableArray *tempNoteStrings = [[NSMutableArray alloc] initWithCapacity:1];
		for (NSUInteger i = 0; i < [octaves count]; i++) {
			for (NSUInteger k = 0; k < [notes count]; k++) {
				NSString *tempStr = [[NSString alloc] initWithString:[[notes objectAtIndex:k] 
																	  stringByAppendingString:[octaves objectAtIndex:i]]];
				[tempNoteStrings addObject:tempStr];
				[tempStr release];
			}
		}
		[notes release];
		[octaves release];
		
		/**** VERY IMPORTANT ****/
		/*	In an accesssor method like this, it MUST be init like this.
		 *	Do NOT use an autorelease method, i.e. [NSArray arrayWithArray:]
		 *
		 *	[self.noteNames objectAtIndex:[(NSNumber*)note unsignedIntegerValue]]
		 *	in    -playNotes:_notes isArpeggiated:isArpeggiated    was crashing
		 *	the app on play #2 :: the second time self.noteNames was accessed.
		 *
		 *	I thought for sure the if(noteNames==nil) would take care of
		 *	problems like this, but it did not.
		 */
		noteNames = [[NSArray alloc] initWithArray:tempNoteStrings];
		[tempNoteStrings release];
	}
	return noteNames;
}



@end
