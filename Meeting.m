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

    [self initWithPerson1:[[Person alloc] init]
                        person2:[[Person alloc] init]
                        person3:[[Person alloc] init]
                        person4:[[Person alloc] init]
                 person1Present:NO
                 person2Present:NO
                 person3Present:NO
                 person4Present:NO
                      startTime:nil
                        endTime:nil
                    accruedCost:nil];
    return self;
}

- (id)initWithExampleValues {
    
    [self initWithPerson1:[[Person alloc] 
                           initWithName:@"Moe"
                           hourlyRate:[NSDecimalNumber decimalNumberWithString:@"8.55"]]
                  person2:[[Person alloc] 
                           initWithName:@"Larry"
                           hourlyRate:[NSDecimalNumber decimalNumberWithString:@"120.00"]]
                  person3:[[Person alloc] 
                           initWithName:@"Curly"
                           hourlyRate:[NSDecimalNumber decimalNumberWithString:@"3600.00"]]
                  person4:[[Person alloc] 
                           initWithName:@"Shemp"
                           hourlyRate:[NSDecimalNumber decimalNumberWithString:@"36000"]]
     
           person1Present:NO
           person2Present:NO
           person3Present:NO
           person4Present:NO
                startTime:nil
                  endTime:nil
              accruedCost:[NSDecimalNumber decimalNumberWithString:@"0"]];
    return self;
}

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
          accruedCost:(NSDecimalNumber*)anAccruedCost {
    
    if (self = [super init]) {
        [self setPerson1:aPerson1];
        [self setPerson2:aPerson2];
        [self setPerson3:aPerson3];
        [self setPerson4:aPerson4];        
        [self setPerson1Present:flag1];
        [self setPerson2Present:flag2];
        [self setPerson3Present:flag3];
        [self setPerson4Present:flag4];
        [self setStartTime:aStartTime];
        [self setEndTime:anEndTime];
        [self setAccruedCost:anAccruedCost];
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

- (Person *)person1 {
    return person1; 
}
- (void)setPerson1:(Person *)aPerson1 {
    if (person1 != aPerson1) {
        [person1 release];
        person1 = [aPerson1 retain];
    }
}

- (Person *)person2 {
    return person2; 
}
- (void)setPerson2:(Person *)aPerson2 {
    if (person2 != aPerson2) {
        [person2 release];
        person2 = [aPerson2 retain];
    }
}

- (Person *)person3 {
    return person3; 
}
- (void)setPerson3:(Person *)aPerson3 {
    if (person3 != aPerson3) {
        [person3 release];
        person3 = [aPerson3 retain];
    }
}

- (Person *)person4 {
    return person4; 
}
- (void)setPerson4:(Person *)aPerson4 {
    if (person4 != aPerson4) {
        [person4 release];
        person4 = [aPerson4 retain];
    }
}

- (BOOL)person1Present {
    return person1Present; 
}
- (void)setPerson1Present:(BOOL)flag {
    person1Present = flag;
}

- (BOOL)person2Present {
    return person2Present;
}
- (void)setPerson2Present:(BOOL)flag {
    person2Present = flag;
}

- (BOOL)person3Present {
    return person3Present;
}
- (void)setPerson3Present:(BOOL)flag {
    person3Present = flag;
}

- (BOOL)person4Present {
    return person4Present;
}
- (void)setPerson4Present:(BOOL)flag {
    person4Present = flag;
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
    
    NSDecimalNumber* combinedHourlyRate = [NSDecimalNumber decimalNumberWithString:@"0.0"] ;
    
    if (person1Present) 
        combinedHourlyRate = [combinedHourlyRate decimalNumberByAdding:[person1 hourlyRate]];
    if (person2Present) 
        combinedHourlyRate = [combinedHourlyRate decimalNumberByAdding:[person2 hourlyRate]];
    if (person3Present) 
        combinedHourlyRate = [combinedHourlyRate decimalNumberByAdding:[person3 hourlyRate]];
    if (person4Present) 
        combinedHourlyRate = [combinedHourlyRate decimalNumberByAdding:[person4 hourlyRate]];
    return combinedHourlyRate;
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
    [person1 release], person1 = nil;
    [person2 release], person2 = nil;
    [person3 release], person3 = nil;
    [person4 release], person4 = nil;
    
    [startTime release], startTime = nil;
    [endTime release], endTime = nil;
    [accruedCost release], accruedCost = nil;
    
    [super dealloc];
}
@end
