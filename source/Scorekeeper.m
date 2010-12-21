//
//  Scorekeeper.m
//  OTG-Intervals
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
	self.iNumAttempts = [NSNumber numberWithInt:1];
	self.iNumSuccesses = [NSNumber numberWithInt:1];
	
	[self reset];

	NSLog(@"(Scorekeeper) iNumAttempts is set to %d and iNumSuccesses is set to %d", [self.iNumAttempts intValue], [self.iNumSuccesses intValue]);

	return self;	
}
	
-(void) success
{
	self.iNumAttempts = [NSNumber numberWithInt:[self.iNumAttempts intValue] + 1];
	self.iNumSuccesses = [NSNumber numberWithInt:[self.iNumSuccesses intValue] + 1];
}

-(void) failure
{
	self.iNumAttempts = [NSNumber numberWithInt:[self.iNumAttempts intValue] + 1];
}

-(void) reset
{
	self.iNumAttempts = [NSNumber numberWithInt:0];
	self.iNumSuccesses = [NSNumber numberWithInt:0];
}

-(NSString *) percentage
{
	NSNumber* temp = [NSNumber numberWithFloat:([self.iNumSuccesses floatValue] / [self.iNumAttempts floatValue] * 100)];
	
	NSString *thePercentage;	// don't alloc init here, [NSString stringWithX:] does all that.
	if ([temp floatValue]>=5.0)	// if temp is a valid percentage.  i.e. if iNumAttempts>0
		thePercentage = [NSString stringWithFormat:@"%.f%%",[temp floatValue]];
	else if ([temp floatValue]>0.0)
		thePercentage = [NSString stringWithFormat:@"%.1f%%", [temp floatValue]];
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
