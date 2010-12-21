//
//  dj.m
//  Interval-Training
//
//  Created by Sam on 8/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "DJ.h"
#import "Note.h"

@implementation DJ

@synthesize noteBank, viableNotes, noteStringsToPlay, noteObjectsToPlay, curNote;

#pragma mark Setup

- (id)init {
	self = [super init];
	if (!self)
		return nil;

//	[self initNoteBank];
	
	return self;
}

-(void)dealloc
{
	[noteBank release];
	[viableNotes release];
	[super dealloc];
}

- (void)initNoteBank {
	// Initialize noteBank with 1 Note (defaults to A 440)
	NSArray *noteNames = [[NSArray alloc] initWithObjects:@"C",@"C#",@"D",@"D#",@"E",
						  @"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil];
	NSArray *noteOctaves = [[NSArray alloc] initWithObjects:@"2",@"3",@"4",nil];
	NSArray *noteHertz = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:32.7],
						  [NSNumber numberWithFloat:34.65], [NSNumber numberWithFloat:36.71],
						  [NSNumber numberWithFloat:38.89], [NSNumber numberWithFloat:41.20],
						  [NSNumber numberWithFloat:43.65], [NSNumber numberWithFloat:46.25],
						  [NSNumber numberWithFloat:49.0], [NSNumber numberWithFloat:51.91],
						[NSNumber numberWithFloat:55.0], [NSNumber numberWithFloat:58.27],
						  [NSNumber numberWithFloat:61.74],nil];
	int octaveMultiplier = 1;
		// This is mutable because we want to be changing it. Previous solution was
		// NSArray alloc init'd pointer that was pointing to larger and larger arrays.
		// That may have only been part of the crashing problem, but I think this is
		// more proper anyway.
	NSMutableArray *tempNoteArray = [[NSMutableArray alloc] initWithCapacity:1];
	for(NSUInteger i = 0; i < [noteOctaves count]; i++)
	{
		NSLog(@"Outer For loop top %i", i);
		octaveMultiplier = octaveMultiplier * 2;
		for (NSUInteger k = 0; k < [noteNames count]; k++) 
		{
			NSLog(@"Inner Loop top %i", k);
			Note *tempNote = [[Note alloc] initWithNoteName:[[noteNames objectAtIndex:k] 
															 stringByAppendingString:[noteOctaves objectAtIndex:i]]
												  withHertz:[[noteHertz objectAtIndex:k] floatValue] * octaveMultiplier];
			[tempNoteArray addObject:tempNote];
		}
	}
	// Just keeping this around for reference.
	//Note *tempNoteA3 = [[Note alloc] initWithNoteName:@"A3" withHertz:220];
	[self setNoteBank:tempNoteArray];
	[tempNoteArray release];
}


#pragma mark -
#pragma mark Runtime DJ Stuff

/*
 *	playNote:
 *
 *	Purpose:	Allows the delegate to tell the DJ what note to play.
 *	Strategy:	Finds the right Note in the noteBank, tells it to play.
 *	Arguments:	(NSString *theNote) A note name, such as "F2" or "A#4".
 *	Note:		[NSArray indexOfObject:object] returns YES if the object's -isEqual:
 *					returns YES.
 *				[noteBank indexOfObject:theNote] works because the Note	class overrides
 *					-isEqual:(NSString *)argStr to test that its noteName
 *					isEqualToString argStr.
 */
//- (void)playNote:(NSString *)theNote {
//	NSLog(@"(DJ) playNote:%@", theNote);
//	
//	NSUInteger noteBankIndexForGivenNote = [noteBank indexOfObject:theNote]; // see function comment "Note"
//	Note* noteToPlay = [noteBank objectAtIndex:noteBankIndexForGivenNote];
//	[noteToPlay playNote:@"W"];
//}


/*
 *	playNoteAtIndex:
 *
 *	Purpose:	Plays from self.noteObjectsToPlay
 */
- (BOOL)playNoteAtIndex:(NSUInteger)_index {
	return [[self.noteObjectsToPlay objectAtIndex:_index] playNote:@"W"];
}


/*
 * playNotes:
 *
 * Purpose: Allows delegate to play a series of notes
 * Strategy:
 */
-(BOOL)playNotes:(NSArray *)theNotes isArpeggiated:(BOOL)isArpeggiated {
	
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
	NSMutableArray *tempNoteArray = [NSMutableArray arrayWithCapacity:[theNotes count]];
	for (NSString *noteName in theNotes) {
		Note *tempNote = [[Note	alloc] initWithNoteName:noteName];
		[tempNoteArray addObject:tempNote];
	}
	self.noteObjectsToPlay = [NSArray arrayWithArray:(NSArray*)tempNoteArray];

	
	[self setNoteStringsToPlay:theNotes];
	
	
	// Play arpeggiated
	if(isArpeggiated)
	{
		curNote = 0;
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(playNextNote:) name:@"NotePlayed" object:nil];
		return [self playNoteAtIndex:curNote];
	}
	
	// Play chorded
	else {
//		NSEnumerator *enumerator = [theNotes objectEnumerator];
//		id anObject;
//		
//		while (anObject = [enumerator nextObject]) {
//			[self playNote:anObject];
//		}
		
		NSTimeInterval shortStartDelay = 0.01;				// (seconds)
		NSTimeInterval now = [[self.noteObjectsToPlay objectAtIndex:0] wholeSample].deviceCurrentTime;
		NSTimeInterval playTime = now + shortStartDelay;
		BOOL retVal = YES;
		
		for (Note *note in self.noteObjectsToPlay) {
			BOOL ret = [note playNote:@"W" atTime:playTime];
			retVal = retVal && ret;
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


// Gets handed a base note and finds the 
- (void)setBase:(NSString *)baseNote {
	NSUInteger root = [noteBank indexOfObjectPassingTest:
			 ^(id obj, NSUInteger idx, BOOL *stop) {
				 return ([[obj noteName] isEqualToString:baseNote]);
			 }];
	// I'm putting 12 as the range for now, and we'll limit our app to an octave.
	NSRange range = NSMakeRange(root, 12);
	viableNotes = [NSIndexSet indexSetWithIndexesInRange:range];
	
}


#pragma mark -
#pragma mark Helpers

- (void)echo {
	NSLog(@"Hello from DJ");
}

@end
