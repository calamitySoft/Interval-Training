//
//  LoadFromFile.m
//  OTG-Intervals
//
//  Created by Logan Moseley on 12/9/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "LoadFromFile.h"
#import "SynthesizeSingleton.h"

@implementation LoadFromFile

/*
- (id)init {
	return self;
}

- (void)dealloc {
	[super dealloc];
}
 */

+ (NSObject*)newObjectForKey:(NSString*)key error:(NSError**)outError {

	if (key==nil) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:@"key==nil"
											code:-1
										userInfo:nil];
		}
		return nil;
	}
	
	NSString *thePath = [[NSBundle mainBundle]  pathForResource:@"Config" ofType:@"plist"];
	NSDictionary *rawConfigDict = [[NSDictionary alloc] initWithContentsOfFile:thePath];
	NSObject *object = [rawConfigDict objectForKey:key];
	[object retain];
	[rawConfigDict release];
	
	// if the key Does Not Exist in rawConfigDict, object will be nil
	if (object==nil) {
		if (outError != NULL) {
			NSString *error = [NSString stringWithFormat:@"key \"%@\" DNE in Config.plist", key];
			*outError = [NSError errorWithDomain:error
											code:-2
										userInfo:nil];
		}
		return nil;
	}
	
	// if no errors
	return object;
}


@end






