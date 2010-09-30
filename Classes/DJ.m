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

@synthesize noteBank, viableNotes;

#pragma mark -
#pragma mark Setup

- (id)init {
	self = [super init];
	if (!self)
		return nil;

	[self initNoteBank];
	
	return self;
}

- (void)initNoteBank {
	// Initialize noteBank with 1 Note (defaults to A 440)
	Note *tempNoteA3 = [[Note alloc] initWithNoteName:@"A3" withHertz:220];
	Note *tempNoteA4 = [[Note alloc] initWithNoteName:@"A4" withHertz:440];
	NSArray *tempNoteArray = [[NSArray alloc] initWithObjects:tempNoteA4, nil];
	NSArray *tempNoteArray2 = [[NSArray alloc] initWithObjects:tempNoteA3, tempNoteA4, nil];
	[self setNoteBank:tempNoteArray2];
	[tempNoteA4 release];
	[tempNoteA3 release];
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
- (void)playNote:(NSString *)theNote {
	NSLog(@"(DJ) playNote:%@", theNote);
	
	NSUInteger noteBankIndexForGivenNote = [noteBank indexOfObject:theNote]; // see function comment "Note"
	Note* noteToPlay = [noteBank objectAtIndex:noteBankIndexForGivenNote];
	[noteToPlay playNote:@"W"];
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
