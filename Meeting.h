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
#pragma mark -
#pragma mark Instance variables
    NSDate *startTime;
    NSDate *endTime;
    NSDecimalNumber *accruedCost;    
    NSMutableArray *participants;
    NSUndoManager *meetUndoManager;
}

#pragma mark -
#pragma mark Accessors
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, retain) NSDecimalNumber *accruedCost;
@property (nonatomic, retain) NSUndoManager *meetUndoManager;

- (NSMutableArray *)participants;
- (void)setParticipants:(NSMutableArray *)a;

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
//- (NSDecimalNumber *)hourlyRate;
- (NSNumber *)hourlyRate;
- (NSDateComponents *)elapsedTime;

@end
