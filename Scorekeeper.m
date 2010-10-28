//
//  Scorekeeper.m
//  Interval-Training
//
//  Created by Sam on 10/20/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "Scorekeeper.h"


@implementation Scorekeeper

@synthesize iNumAttempts, iNumSuccesses;

-(id) initScore
{
	self = [super init];
	if (!self)
		return nil;
	
	NSLog(@"Hello from Scorekeeper!");
	iNumAttempts = [NSNumber numberWithInt:1];
	iNumSuccesses = [NSNumber numberWithInt:1];
	
	[self reset];

	NSLog(@"(Scorekeeper) iNumAttempts is set to %d and iNumSuccesses is set to %d", [iNumAttempts intValue], [iNumSuccesses intValue]);

	return self;	
}
	
-(void) success
{
	iNumAttempts = [NSNumber numberWithInt:[iNumAttempts intValue] + 1];
	iNumSuccesses = [NSNumber numberWithInt:[iNumSuccesses intValue] + 1];
	NSLog(@"\nsuccess\t\t%i %i", [iNumAttempts intValue], [iNumSuccesses intValue]);
}

-(void) failure
{
	iNumAttempts = [NSNumber numberWithInt:[iNumAttempts intValue] + 1];
	NSLog(@"\nsuccess\t\t%i %i", [iNumAttempts intValue], [iNumSuccesses intValue]);
}

-(void) reset
{
	iNumAttempts = [NSNumber numberWithInt:0];
	iNumSuccesses = [NSNumber numberWithInt:0];
}

-(NSString *) percentage
{
	NSNumber* temp = [NSNumber numberWithFloat:([iNumSuccesses floatValue] / [iNumAttempts floatValue])];
	
	NSString *thePercentage;	// don't alloc init here, [NSString stringWithX:] does all that.
	if ([temp floatValue]>0)	// if temp is a valid percentage.  i.e. if iNumAttempts>0
		thePercentage = [NSString stringWithFormat:@"%@%%",[temp stringValue]];
	else
		thePercentage = [NSString stringWithString:@"0%"];

	return thePercentage;
}

-(void)dealloc
{
	[iNumAttempts release];
	[iNumSuccesses release];
	[super dealloc];
}

@end
