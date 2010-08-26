//
//  dj.h
//  Interval-Training
//
//  Created by Sam on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "note.h"

@interface dj : NSObject {

	NSArray *noteBank;
	NSIndexSet *viableNotes;
	NSUInteger base;
	
}

-(id) init;

-(void)playNote:(NSString *)theNote; // conducts linear search for the note

-(void) setBase:(NSString *)baseNote; // Sets a note to the base


@end
