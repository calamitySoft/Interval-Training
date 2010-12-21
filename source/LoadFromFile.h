//
//  LoadFromFile.h
//  OTG-Chords
//
//  Created by Logan Moseley on 12/9/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

//
//	Usage:
//	NSObject *obj = [LoadFromFile objectForKey:@"ChordNames" error:outError];
//
//	error	-2	object for that key does not exist
//			-1	key == nil
//


#import <Foundation/Foundation.h>


@interface LoadFromFile : NSObject {	
}


+ (NSObject*)newObjectForKey:(NSString*)key error:(NSError**)outError;

@end
