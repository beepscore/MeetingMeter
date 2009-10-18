//
//  Meeting.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/10/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

#define MINUTES_PER_HOUR 60
#define SECONDS_PER_HOUR 3600

@implementation Meeting

#pragma mark -
#pragma mark Initializers
// init
- (id)init {

    [self initWithStartTime:nil
                    endTime:nil
                accruedCost:nil
                participants:nil];

    return self;
}

- (id)initWithExampleValues {
    
    Person *tempPerson1 = [[Person alloc] 
            initWithName:@"Moe"
              hourlyRate:[NSDecimalNumber decimalNumberWithString:@"8.55"]];

    Person *tempPerson2 = [[Person alloc] 
                           initWithName:@"Larry"
                           hourlyRate:[NSDecimalNumber decimalNumberWithString:@"20"]];
    
    [self initWithStartTime:nil
                    endTime:nil
                accruedCost:[NSDecimalNumber decimalNumberWithString:@"0"]
               participants:[NSMutableArray arrayWithObjects:tempPerson1, tempPerson2, nil] ];
    
    [tempPerson1 release];
    [tempPerson2 release];
    
    return self;
}

- (id)initWithStartTime:(NSDate*)aStartTime
              endTime:(NSDate*)anEndTime
          accruedCost:(NSDecimalNumber*)anAccruedCost
         participants:(NSMutableArray*)aParticipants{
    
    if (self = [super init]) {
        [self setStartTime:aStartTime];
        [self setEndTime:anEndTime];
        [self setAccruedCost:anAccruedCost];
        
        [self setParticipants:aParticipants];
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

- (NSMutableArray *)participants{
    return participants;
}

- (void)setParticipants:(NSMutableArray *)a {
    if (a == participants)
        return;
    
    // increment retain count on the object 'a' points to.  See Hillegass pg 69
    [a retain];
    [participants release];
    
    // now 'participants' points to the same object as 'a'
    participants = a;
}


- (NSDate *)startTime {
    return startTime; 
}
- (void)setStartTime:(NSDate *)aStartTime {
    if (startTime != aStartTime) {
        [startTime release];
        startTime = [aStartTime retain];
    }
}

- (NSDate *)endTime {
    return endTime; 
}

- (void)setEndTime:(NSDate *)anEndTime {
    if (endTime != anEndTime) {
        [endTime release];
        endTime = [anEndTime retain];
    }
}

- (NSDecimalNumber *)accruedCost {
    return accruedCost; 
}
- (void)setAccruedCost:(NSDecimalNumber *)anAccruedCost {
    if (accruedCost != anAccruedCost) {
        [accruedCost release];
        accruedCost = [anAccruedCost retain];
    }
}

#pragma mark -
#pragma mark Other methods

// start the meeting
- (IBAction)startMeeting {
    return;
}

- (IBAction)stopMeeting {
    return;
}

// calculate hourly rate for meeting
- (NSDecimalNumber *) hourlyRate {
    
    //NSDecimalNumber* combinedHourlyRate = [NSDecimalNumber decimalNumberWithString:@"0.0"] ;
    // ref Hillegass pg 120
    //return [participants valueForKeyPath:@"sum.hourlyRate"];
    return [NSDecimalNumber decimalNumberWithString:@"99.99"];
}

- (NSDateComponents *) elapsedTime {
    if (nil == startTime) {
        return 0;
    }
    // ref http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html#//apple_ref/doc/uid/TP40007836
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startTime
                                                  toDate:[NSDate date]
                                                 options:0];
    [gregorian autorelease];
    return components;
}

- (void)dealloc {
    
    [participants release], participants = nil;
    
    [startTime release], startTime = nil;
    [endTime release], endTime = nil;
    [accruedCost release], accruedCost = nil;
    
    [super dealloc];
}
@end
