//
//  note.h
//  NoteToFreq
//
//  Created by Sam on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Note : NSObject {
	
	float hertz;
	NSString *noteName;
	SystemSoundID wholeSample;
	SystemSoundID halfSample;
	SystemSoundID quarterSample;
	SystemSoundID eighthSample;
	SystemSoundID sixteenthSample;
}

@property (nonatomic) float hertz;
@property (nonatomic, copy) NSString *noteName;

-(id)initWithNoteName:(NSString *)_noteName withHertz:(float)_hertz;
-(void) playNote:(NSString *)theNote;

-(void) playWhole;
-(void) playHalf;
-(void) playQuarter;
-(void) playEighth;
-(void) playSixteenth;

@end
