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
#import "Person.h"

@interface Meeting : NSObject {
    // declare instance variables
    // TODO: replace separate person instances from homework 2 with an array
    Person *person1;
    Person *person2;
    Person *person3;
    Person *person4;

    // BOOL NO=0 YES=1
    BOOL person1Present;
    BOOL person2Present;
    BOOL person3Present;
    BOOL person4Present;
        
    NSDate *startTime;
    NSDate *endTime;
    NSDecimalNumber *accruedCost;
}

// declare methods

#pragma mark -
#pragma mark Initializers
// designatedInitializer
- (id)initWithPerson1:(Person*)aPerson1
              person2:(Person*)aPerson2
              person3:(Person*)aPerson3
              person4:(Person*)aPerson4
       person1Present:(BOOL)flag1
       person2Present:(BOOL)flag2
       person3Present:(BOOL)flag3
       person4Present:(BOOL)flag4
            startTime:(NSDate*)aStartTime
              endTime:(NSDate*)anEndTime
          accruedCost:(NSDecimalNumber*)anAccruedCost;

- (id)initWithExampleValues;

#pragma mark -
#pragma mark Accessors
- (Person *)person1;
- (void)setPerson1:(Person *)aPerson1;
- (Person *)person2;
- (void)setPerson2:(Person *)aPerson2;
- (Person *)person3;
- (void)setPerson3:(Person *)aPerson3;
- (Person *)person4;
- (void)setPerson4:(Person *)aPerson4;

- (BOOL)person1Present;
- (void)setPerson1Present:(BOOL)flag;
- (BOOL)person2Present;
- (void)setPerson2Present:(BOOL)flag;
- (BOOL)person3Present;
- (void)setPerson3Present:(BOOL)flag;
- (BOOL)person4Present;
- (void)setPerson4Present:(BOOL)flag;


- (NSDate *)startTime;
- (void)setStartTime:(NSDate *)aStartTime;
- (NSDate *)endTime;
- (void)setEndTime:(NSDate *)anEndTime;

- (NSDecimalNumber *)accruedCost;
- (void)setAccruedCost:(NSDecimalNumber *)anAccruedCost;

#pragma mark -
#pragma mark Other methods
- (void)startMeeting;
- (void)stopMeeting;

// calculated from people attending meeting
- (NSDecimalNumber *)hourlyRate;

- (NSDateComponents *)elapsedTime;

@end
