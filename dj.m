//
//  dj.m
//  Interval-Training
//
//  Created by Sam on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DJ.h"
#import "Note.h"

@implementation DJ


- (id)init
{
	self = [super init];
	if (!self)
		return nil;
	
	Note *tempNote = [[Note alloc] init];
	[noteBank arrayByAddingObject:tempNote];
	
	return self;
}

- (void)playNote:(NSString *)theNote
{
	NSLog(@"Hello from DJ");
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

@end
