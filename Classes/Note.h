//
//  note.h
//  NoteToFreq
//
//  Created by Sam on 7/31/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Note : NSObject <AVAudioPlayerDelegate>{
	
	float hertz;
	NSString *noteName;
	
	// The actual samples
	AVAudioPlayer *wholeSample;
	
	// The rest of these we probably won't use for this app
	AVAudioPlayer *halfSample;
	AVAudioPlayer *quarterSample;
	AVAudioPlayer *eighthSample;
	AVAudioPlayer *sixteenthSample;
}

@property (nonatomic) float hertz;
@property (nonatomic, copy) NSString *noteName;


- (id)initWithNoteName:(NSString *)_noteName withHertz:(float)_hertz;

- (void)playNote:(NSString *)theNote; // does a switch to pick the right note playback
- (void)stop;	// stops the playing note
// Functions to play the samples
- (void)playWhole;
- (void)playHalf;
- (void)playQuarter;
- (void)playEighth;
- (void)playSixteenth;

- (void)echo; // Used to test if I exist.

@end
