//
//  Tuner.m
//  Interval-Training
//
//  Created by Logan Moseley on 9/29/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Tuner.h"


@implementation Tuner

@synthesize targetNote;


#pragma mark -
#pragma mark Setup

- (id)init {
	self = [super init];
	if (!self)
		return nil;
		
	return self;
}


#pragma mark -
#pragma mark Runtime

/*
 *	listenForNote:
 *
 *	Purpose:	Tuner needs to listen for the target note for some length
 *					of time, e.g. 1 second.
 *	Arguments:	(Note *_targetNote) Note we want sung. Sets to own variable
 *					for looping to listen for that note.
 *	Note:		Maybe this should go in pragma/mark/Helpers?
 */
- (PitchResult)listenForNote:(Note *)_targetNote {
	[self setTargetNote:_targetNote];
	return kSungOnPitch;
}


#pragma mark -
#pragma mark Helpers

- (void)echo {
	NSLog(@"Hello from Tuner");
}


@end
