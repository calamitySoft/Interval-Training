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
	NSArray *noteStringsToPlay;	// If a series of notes to be played is entered, this is set to it
									// NSArray of NSStrings to play
	NSArray *noteObjectsToPlay;		// NSArray of Note objects to play
	NSUInteger curNote;				// Keeps track of where in the notesToPlay array we are
	NSIndexSet *viableNotes;	
}

@property (nonatomic, retain) NSArray *noteBank;
@property (nonatomic, retain) NSIndexSet *viableNotes;
@property (nonatomic, retain) NSArray *noteStringsToPlay;
@property (nonatomic, retain) NSArray *noteObjectsToPlay;
@property (nonatomic) NSUInteger curNote;

- (id)init;
- (void)initNoteBank;	// Initializes all notes and places them in the noteBank
//- (void)playNote:(NSString *)theNote; // Conducts linear search for the note
- (BOOL)playNoteAtIndex:(NSUInteger)_index;		// plays from self.noteObjectsToPlay
- (BOOL)playNotes:(NSArray *)theNotes isArpeggiated:(BOOL)isArpeggiated; // Plays a series of notes by setting up a notification center
- (void)playNextNote:(NSNotification *)note;
- (void)stop;	// Stops playing notes in sequence
- (void)setBase:(NSString *)baseNote; // Sets a note to the base

- (void)echo; // Used to test if I exist.

@end
