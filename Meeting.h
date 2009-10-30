//
//  Meeting.h
//  MeetingMeter
//
//  Created by Steve Baker on 10/10/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//
//  Meeting is MVC model.  Don't include outlets, use controller instead.

#import <Cocoa/Cocoa.h>
// When possible, use @class, not #import in header file.
// #import requires recompile whenever imported file changes.
#import "BSGlobalValues.h"
#import "Person.h"

@interface Meeting : NSObject {
    
    // declare instance variables
    NSDate *startTime;
    NSDate *endTime;
    NSDecimalNumber *accruedCost;    
    NSMutableArray *participants;
    NSUndoManager *meetUndoManager;
}

// declare methods
#pragma mark -
#pragma mark Initializers
// designatedInitializer
- (id)initWithStartTime:(NSDate*)aStartTime
                endTime:(NSDate*)anEndTime
            accruedCost:(NSDecimalNumber*)anAccruedCost
           participants:(NSMutableArray*)aParticipants
        meetUndoManager:(NSUndoManager*)anUndoManager;

- (id)initWithExampleValues:(NSUndoManager*)anUndoManager;

#pragma mark -
#pragma mark Accessors
- (NSMutableArray *)participants;
- (void)setParticipants:(NSMutableArray *)a;

- (NSDate *)startTime;
- (void)setStartTime:(NSDate *)aStartTime;
- (NSDate *)endTime;
- (void)setEndTime:(NSDate *)anEndTime;

- (NSDecimalNumber *)accruedCost;
- (void)setAccruedCost:(NSDecimalNumber *)anAccruedCost;

@property (readwrite, retain) NSUndoManager *meetUndoManager;

#pragma mark -
#pragma mark KVO related methods
- (void)startObservingPerson:(Person *)aPerson;
- (void)stopObservingPerson:(Person *)aPerson;
- (void)insertObject:(Person *)aPerson inParticipantsAtIndex:(int)index;
- (void)removeObjectFromParticipantsAtIndex: (int) index;
- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue;


#pragma mark -
#pragma mark Other methods
- (void)startMeeting;
- (void)stopMeeting;

// calculated from people attending meeting
- (NSDecimalNumber *)hourlyRate;

- (NSDateComponents *)elapsedTime;

    
@end
