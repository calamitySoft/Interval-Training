//
//  dj.m
//  Interval-Training
//
//  Created by Sam on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "dj.h"


@implementation dj


-(id) init
{
	return self;
}

-(void) playNote:(NSString *)theNote
{
	
}

// Gets handed a base note and finds the 
-(void) setBase:(NSString *)baseNote
{
	base = [noteBank indexOfObjectPassingTest:
			 ^(id obj, NSUInteger idx, BOOL *stop) {
				 return ([[obj noteName] isEqualToString:baseNote]);
			 }];
	
}
@end
