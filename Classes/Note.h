//
//  note.h
//  NoteToFreq
//
//  Created by Sam on 7/31/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Note : NSObject {
	
	float hertz;
	NSString *noteName;
	
	// The actual samples
	SystemSoundID wholeSample;
	// The rest of these we probably won't use for this app
	SystemSoundID halfSample;
	SystemSoundID quarterSample;
	SystemSoundID eighthSample;
	SystemSoundID sixteenthSample;
}

@property (nonatomic) float hertz;
@property (nonatomic, copy) NSString *noteName;

- (id)initWithNoteName:(NSString *)_noteName withHertz:(float)_hertz;

- (void)playNote:(NSString *)theNote; // does a switch to pick the right note playback

// Functions to play the samples
- (void)playWhole;
- (void)playHalf;
- (void)playQuarter;
- (void)playEighth;
- (void)playSixteenth;

- (void)echo; // Used to test if I exist.

@end
