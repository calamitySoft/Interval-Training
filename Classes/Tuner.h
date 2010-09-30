//
//  Tuner.h
//  Interval-Training
//
//  Created by Logan Moseley on 9/29/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"


typedef enum {	// This enum belongs somewhere more visible. Callers of -listenForNote: will need it.
	kPitchRecordingError = -1,
	kSungOnPitch = 1,
	kSungFlat,
	kSungSharp
} PitchResult;



@interface Tuner : NSObject {
	Note *targetNote;	// the note DJ (via AppDelegate) says to listen for
}

@property (nonatomic, retain) Note *targetNote;

- (PitchResult)listenForNote:(Note *)_targetNote;

- (void)echo; // Used to test if I exist.

@end
