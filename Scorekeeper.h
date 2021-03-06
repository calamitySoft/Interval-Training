//
//  Scorekeeper.h
//  Interval-Training
//
//  Created by Sam on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Scorekeeper : NSObject {
	NSNumber *iNumAttempts;
	NSNumber *iNumSuccesses;

}

@property(nonatomic,retain) NSNumber *iNumAttempts;
@property(nonatomic,retain) NSNumber *iNumSuccesses;

-(void) initScore;
-(void) success;	// Increments successes and attempts
-(void) failure;	// Increments only Attempts
-(void) reset;		// Set attempts and successes to 0;
-(NSString*) percentage; // Returns a string with the percent success rate

@end
