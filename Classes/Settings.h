//
//  Settings.h
//  Interval-Training
//
//  Created by Logan Moseley on 11/24/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject {
	NSArray		*noteNames;
	
	NSArray		*easyDifficulty;
	NSArray		*mediumDifficulty;
	NSArray		*hardDifficulty;
	NSArray		*customDifficulty;
	char		currentDifficulty;
}

@property (nonatomic, retain, readonly) NSArray *noteNames;

@property (nonatomic, retain, readonly) NSArray *easyDifficulty;
@property (nonatomic, retain, readonly) NSArray *mediumDifficulty;
@property (nonatomic, retain, readonly) NSArray *hardDifficulty;
@property (nonatomic, retain) NSArray *customDifficulty;
@property char currentDifficulty;

+ (Settings *)sharedSettings;	// necessary for singelton-ness. DO NOT REMOVE.

@end
