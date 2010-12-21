//
//  Note.h
//  OTG-Intervals
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
	
	/*
	// The rest of these we probably won't use for this app
	AVAudioPlayer *halfSample;
	AVAudioPlayer *quarterSample;
	AVAudioPlayer *eighthSample;
	AVAudioPlayer *sixteenthSample;
	 */
}

@property (nonatomic) float hertz;
@property (nonatomic, copy) NSString *noteName;
@property (nonatomic, retain) AVAudioPlayer *wholeSample;

- (id)initWithNoteName:(NSString *)_noteName;		// for when we don't care about hertz, like all of OTG Chords
- (id)initWithNoteName:(NSString *)_noteName withHertz:(float)_hertz;

- (BOOL)playNote:(NSString *)duration; // does a switch to pick the right note playback
- (BOOL)playNote:(NSString *)duration atTime:(NSTimeInterval)time;	// wraps AVAudioPlayer's playAtTime: for synchronous playback
- (void)stop;	// stops the playing note
// Functions to play the samples
- (BOOL)playWhole;
/*
- (BOOL)playHalf;
- (BOOL)playQuarter;
- (BOOL)playEighth;
- (BOOL)playSixteenth;
 */

- (void)echo; // Used to test if I exist.

@end
