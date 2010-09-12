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

- (id)init
{
	self = [super init];
	if (!self)
		return nil;
	
	// Initialize noteBank with 1 Note (defaults to A 440)
	Note *tempNote = [[Note alloc] init];
	NSArray *tempNoteArray = [[NSArray alloc] initWithObjects:tempNote, nil];
	[self setNoteBank:tempNoteArray];
	[tempNote release];
	[tempNoteArray release];
	
	return self;
}

- (void)playNote:(NSString *)theNote
{
//	[[noteBank objectAtIndex:0] echo];
	Note* noteToPlay = [noteBank objectAtIndex:0];
	[noteToPlay playNote:@"W"];
}

// Gets handed a base note and finds the 
- (void)setBase:(NSString *)baseNote
{
	NSUInteger root = [noteBank indexOfObjectPassingTest:
			 ^(id obj, NSUInteger idx, BOOL *stop) {
				 return ([[obj noteName] isEqualToString:baseNote]);
			 }];
	// I'm putting 12 as the range for now, and we'll limit our app to an octave.
	NSRange range = NSMakeRange(root, 12);
	viableNotes = [NSIndexSet indexSetWithIndexesInRange:range];
	
}

- (void)echo {
	NSLog(@"Hello from DJ");
}

@end
