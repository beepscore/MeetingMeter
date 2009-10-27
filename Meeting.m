//
//  Meeting.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/10/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

#define MINUTES_PER_HOUR 60.
#define SECONDS_PER_HOUR 3600.

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
              hourlyRate:[NSDecimalNumber decimalNumberWithString:@"3600.00"]];

    Person *tempPerson2 = [[Person alloc] 
                           initWithName:@"Larry"
                           hourlyRate:[NSDecimalNumber decimalNumberWithString:@"3600"]];

    Person *tempPerson3 = [[Person alloc] 
                           initWithName:@"Curly"
                           hourlyRate:[NSDecimalNumber decimalNumberWithString:@"36"]];
    
    [self initWithStartTime:nil
                    endTime:nil
                accruedCost:[NSDecimalNumber zero]
               participants:[NSMutableArray arrayWithObjects:tempPerson1, tempPerson2, tempPerson3, nil] ];
    
    [tempPerson1 release];
    [tempPerson2 release];
    [tempPerson3 release];
    
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
    
    for (Person *person in [self participants]) {
        [self stopObservingPerson:person];
    }
    
    // point 'participants' to the same object as 'a'
    participants = a;
    
    for (Person *person in [self participants]) {
        [self startObservingPerson:person];
    }    
    
//        [self willChangeValueForKey:@"hourlyRate"];
//        [self hourlyRate];
//        [self didChangeValueForKey:@"hourlyRate"];
    
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

// TODO: meeting hourlyRate method doesn't get called when manually editing a person's rate in GUI
// calculate hourly rate for meeting
- (NSDecimalNumber *) hourlyRate {
    
    NSDecimalNumber *combinedHourlyRate = [NSDecimalNumber zero];
    NSEnumerator *enumerator = [[self participants] objectEnumerator];
    
    for (Person *thisPerson in enumerator) {
        combinedHourlyRate = [combinedHourlyRate decimalNumberByAdding:[thisPerson hourlyRate]];
    }
    NSLog(@"meeting hourlyRate = %@", combinedHourlyRate);
    return combinedHourlyRate;
}

// I think elapsedTime truncates seconds at components:fromDate:toDate:options: method
- (NSDateComponents *)elapsedTime {
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

- (NSString*)description {
    
    NSString *descriptionString = @"\n";
    descriptionString = [descriptionString stringByAppendingString:@"Participant, hourlyRate \n"];    
    
    NSEnumerator *enumerator = [[self participants] objectEnumerator];
    
    for (Person *thisPerson in enumerator) {
        NSString *thisPersonNameString = [[NSString stringWithFormat:@"%@", [thisPerson name]]
                                          stringByPaddingToLength: 15 withString: @" " startingAtIndex:0];
        
        descriptionString = [descriptionString stringByAppendingString:thisPersonNameString];    
        
        NSString *thisPersonHourlyRateString = [NSString stringWithFormat:@"%20@ \n",
                                                [thisPerson hourlyRate]];
        
        descriptionString = [descriptionString stringByAppendingString:thisPersonHourlyRateString];            
    }
    
    NSString *meetingRateString = 
    [NSString stringWithFormat:@"  hourlyRate = %@\n", [self hourlyRate]];
    
    descriptionString = [descriptionString stringByAppendingString:meetingRateString];    
    
    return descriptionString;
}


- (void)dealloc {
    
    [participants release], participants = nil;    
    [startTime release], startTime = nil;
    [endTime release], endTime = nil;
    [accruedCost release], accruedCost = nil;
    
    [super dealloc];
}

// ====================================================

#pragma mark -
#pragma mark KVO related methods
- (void)startObservingPerson:(Person *)aPerson {
    
    [aPerson addObserver:self
              forKeyPath:@"name"
                 options:NSKeyValueObservingOptionOld
                 context:NULL];
    
    [aPerson addObserver:self
              forKeyPath:@"hourlyRate"
                 options:NSKeyValueObservingOptionOld
                 context:NULL];
}

- (void)stopObservingPerson:(Person *)aPerson {
    
    [aPerson removeObserver:self forKeyPath:@"name"];
    [aPerson removeObserver:self forKeyPath:@"hourlyRate"];
}

// Ref Hillegass pg 144, 147
- (void)insertObject:(Person *)aPerson inParticipantsAtIndex:(int)index {
    [self startObservingPerson:aPerson];    
    [[self participants] insertObject:aPerson atIndex:index];
}

- (void)removeObjectFromParticipantsAtIndex:(int)index {
    Person *aPerson = [[self participants] objectAtIndex:index];
    [self stopObservingPerson:aPerson];
    [[self participants] removeObjectAtIndex:index];
}

// observeValueForKeyPath called whenever a person is edited,
// not when added or deleted.  Ref Hillegass pg 148
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
        
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    
    // NSNull objects are used to represent nil in a dictionary
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    NSLog(@"in observeValueForKeyPath = %@, oldValue = %@", keyPath, oldValue);
     
    // TODO:  call update hourly rate here?????
    //[self hourlyRate];

    
//    [[meetUndoManager prepareWithInvocationTarget:self] changeKeyPath:keyPath
//                                                             ofObject:object
//                                                              toValue:oldValue];
//    [meetUndoManager setActionName:@"Edit"];
}


- (void)changeKeyPath:(NSString *)keyPath
             ofObject:(id)obj
              toValue:(id)newValue {
    // setValue:forKeyPath: will cause the key-value observing method
    // to be called, which takes care of the undo stuff
    [obj setValue:newValue forKeyPath:keyPath];
}

// TODO:  Send notification when values for any person in participants changes
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    
	if ([key isEqualToString:@"hourlyRate"]) {
        
        return [NSSet setWithObjects:nil];        
        
    }
	return [super keyPathsForValuesAffectingValueForKey:key];      
}


@end

