//
//  Scorekeeper.m
//  Interval-Training
//
//  Created by Sam on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Scorekeeper.h"


@implementation Scorekeeper

@synthesize iNumAttempts, iNumSuccesses;

-(void) initScore
{
	NSLog(@"Hello from Scorekeeper!");
	iNumAttempts = [[NSNumber alloc] init];
	iNumSuccesses = [[NSNumber alloc] init];
	
	[self reset];
	
	NSLog(@"iNumAttempts is set to %d and iNumSuccesses is set to %d", [iNumAttempts intValue], [iNumSuccesses intValue]);
}
	
-(void) success
{
	iNumAttempts = [NSNumber numberWithInt:[iNumAttempts intValue] + 1];
	iNumSuccesses = [NSNumber numberWithInt:[iNumSuccesses intValue] + 1];
}

-(void) failure
{
	iNumAttempts = [NSNumber numberWithInt:[iNumAttempts intValue] + 1];
}

-(void) reset
{
	iNumAttempts = [NSNumber numberWithInt:0];
	iNumSuccesses = [NSNumber numberWithInt:0];
}

-(NSString *) percentage
{
	NSNumber* temp = [NSNumber numberWithFloat:[iNumSuccesses floatValue] / [iNumAttempts floatValue]];
	NSString* thePercentage = [NSString stringWithString:[temp stringValue]];
	return thePercentage;
}
	
@end
