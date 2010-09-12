//
//  dj.h
//  Interval-Training
//
//  Created by Sam on 8/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface DJ : NSObject {

	NSArray *noteBank;
	NSIndexSet *viableNotes;	
}

@property (nonatomic, retain) NSArray *noteBank;
@property (nonatomic, retain) NSIndexSet *viableNotes;

- (id)init;
- (void)playNote:(NSString *)theNote; // Conducts linear search for the note
- (void)setBase:(NSString *)baseNote; // Sets a note to the base

- (void)echo; // Used to test if I exist.

@end
