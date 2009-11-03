//
//  Meeting.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/10/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"


@implementation Meeting

#pragma mark -
#pragma mark Initializers
// init
- (id)init {

    [self initWithStartTime:nil
                    endTime:nil
                accruedCost:nil
                participants:nil
            meetUndoManager:nil ];

    return self;
}

- (id)initWithExampleValues:(NSUndoManager *)anUndoManager {
    
    Person *tempPerson1 = [[Person alloc] 
            initWithName:@"Moe"
              hourlyRate:3600.00];

    Person *tempPerson2 = [[Person alloc] 
                           initWithName:@"Larry"
                           hourlyRate:3600.00];

    Person *tempPerson3 = [[Person alloc] 
                           initWithName:@"Curly"
                           hourlyRate:36.00];
                           
    [self initWithStartTime:nil
                    endTime:nil
                accruedCost:[NSDecimalNumber zero]
               participants:[NSMutableArray arrayWithObjects:tempPerson1, tempPerson2, tempPerson3, nil]
            meetUndoManager:anUndoManager];
    
    [tempPerson1 release];
    [tempPerson2 release];
    [tempPerson3 release];
    
    return self;
}

- (id)initWithStartTime:(NSDate*)aStartTime
                endTime:(NSDate*)anEndTime
            accruedCost:(NSDecimalNumber*)anAccruedCost
           participants:(NSMutableArray*)aParticipants
        meetUndoManager:anUndoManager {
    
    if (self = [super init]) {
        [self setStartTime:aStartTime];
        [self setEndTime:anEndTime];
        [self setAccruedCost:anAccruedCost];
        
        [self setParticipants:aParticipants];
        [self setMeetUndoManager:anUndoManager];

    }
    return self;
}

#pragma mark -
#pragma mark Accessors
@synthesize meetUndoManager;

- (NSMutableArray *)participants{
    return participants;
}

- (void)setParticipants:(NSMutableArray *)a {
    if (a == participants)
        return;
    
    // increment retain count on the object 'a' points to.  See Hillegass pg 69
    [a retain];
    
    for (Person *person in [self participants]) {
        [self stopObservingPerson:person];
    }
    [participants release];
    
    // point 'participants' to the same object as 'a'
    participants = a;
    
    for (Person *person in [self participants]) {
        [self startObservingPerson:person];
    }    
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
- (void)dealloc {
    
    // remove observer.  Ref Hillegass pg 146-147, 209
    for (Person *person in [self participants]) {
        [self stopObservingPerson:person];
    }
    
    // after release, best practice is set object = nil;
    // then if someone accidentally calls it,
    // they will get nil instead of a bad reference.
    [meetUndoManager release], meetUndoManager = nil;
    [startTime release], startTime = nil;
    [endTime release], endTime = nil;
    [accruedCost release], accruedCost = nil;
    [participants release], participants = nil;    
    
    [super dealloc];
}

- (void)startMeeting {
    // [[NSDate alloc] init] and [NSDate date] both return current date and time.
    [self setStartTime:[NSDate date]];
    [self setEndTime:nil];         
    return;
}

- (void)stopMeeting {
    // [[NSDate alloc] init] and [NSDate date] both return current date and time.
    [self setEndTime:[NSDate date]];     
    return;
}

// calculate hourly rate for meeting
- (NSDecimalNumber *) hourlyRate {
    
    NSDecimalNumber *combinedHourlyRate = [NSDecimalNumber zero];
    for (Person *thisPerson in [self participants]) {
        combinedHourlyRate = [combinedHourlyRate 
                              decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:
                                                     [[NSNumber numberWithFloat:[thisPerson hourlyRate]] decimalValue]]];
    }
    DLog(@"meeting hourlyRate = %8.2@", combinedHourlyRate);
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
    descriptionString = [descriptionString stringByAppendingString:@"Participant       hourlyRate \n"];    
    
    for (Person *thisPerson in [self participants]) {
        descriptionString = [descriptionString stringByAppendingString:[thisPerson description]];    
    }
    
    NSString *meetingRateString = 
        [NSString stringWithFormat:@"  hourlyRate =    %14.2@\n", [self hourlyRate]];
    
    descriptionString = [descriptionString stringByAppendingString:meetingRateString];    
    
    return descriptionString;
}


#pragma mark -
#pragma mark KVO related methods
// This adds self (the meeting) as an observer of changes to aPerson's hourlyRate.
- (void)startObservingPerson:(Person *)aPerson {
    
    [aPerson addObserver:self
              forKeyPath:BSPersonNameKey
                 options:NSKeyValueObservingOptionOld
                 context:NULL];
    
    [aPerson addObserver:self
              forKeyPath:BSPersonHourlyRateKey
                 options:NSKeyValueObservingOptionOld
                 context:NULL];
}

- (void)stopObservingPerson:(Person *)aPerson {
    [aPerson removeObserver:self forKeyPath:BSPersonNameKey];
    [aPerson removeObserver:self forKeyPath:BSPersonHourlyRateKey];
}

// insertObject: and removeObject: add or remove a person from the participants array.
// They use KVC methods, which in turn use the Meeting -setParticipants accessor.
// Ref Hillegass pg 144, 147
- (void)insertObject:(Person *)aPerson inParticipantsAtIndex:(int)index {

    DLog(@"adding %@ to %@", aPerson, [self participants]);
    // Add the inverse of this operation to the undo stack
    [[meetUndoManager prepareWithInvocationTarget:self]
     removeObjectFromParticipantsAtIndex:index];
    if (![[self meetUndoManager] isUndoing]) {
        [[self meetUndoManager] setActionName:@"Insert Person"];
    }
    
    [self startObservingPerson:aPerson];    
    // Add the person to the array
    [[self participants] insertObject:aPerson atIndex:index];
    [self hourlyRate];
}

- (void)removeObjectFromParticipantsAtIndex:(int)index {
    
    
    Person *aPerson = [[self participants] objectAtIndex:index];
    DLog(@"removing %@ from participants", aPerson.name);
    
    // Add the inverse of this operation to the undo stack
    [[[self meetUndoManager] prepareWithInvocationTarget:self] insertObject:aPerson
                                                      inParticipantsAtIndex:index];
    if (![[self meetUndoManager] isUndoing]) {
        [[self meetUndoManager] setActionName:@"Delete Person"];
    }
    
    [self stopObservingPerson:aPerson];
    // Remove the person from the array
    [[self participants] removeObjectAtIndex:index];
    [self hourlyRate];
}

// KVO sends observeValueForKeyPath message to the meeting when an object
// the meeting is observing has changed.
// By default in KVO, changing a person’s hourlyRate does not count as a change
// to the participants array, and doesn’t trigger the participants array to send a notification.
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    
    DLog(@"%@ in observeValueForKeyPath = %@", self, keyPath);
    
    // If the meeting is being notified that a person's hourlyRate has changed,
    // the meeting will send a notification that meeting hourlyRate has changed.
    if ([keyPath isEqualToString:BSPersonHourlyRateKey]) { // the Person's hourlyRate
        [self willChangeValueForKey:BSMeetingHourlyRateKey]; // the Meeting's hourlyRate
        [self didChangeValueForKey:BSMeetingHourlyRateKey];// the Meeting's hourlyRate
    }
    
    // Undo Person Edits.  Ref Hillegass pg 148
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    
    // NSNull objects are used to represent nil in a dictionary
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }

    [[[self meetUndoManager] prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                             ofObject:object
                                                              toValue:oldValue];
    [[self meetUndoManager] setActionName:@"Edit"];
}

- (void)changeKeyPath:(NSString *)keyPath
             ofObject:(id)obj
              toValue:(id)newValue {
    // setValue:forKeyPath: will cause the key-value observing method
    // to be called, which takes care of the undo stuff
    [obj setValue:newValue forKeyPath:keyPath];
}

// Send notification when values for any person in participants changes
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)keyInQuestion {
    
    // Hal's comment - What methods impact keyInQuestion?
    
    // This states that the meeting hourlyRate is dependent on the participants array.
    // When the participants array is changed, the program will send a notification
    // that meeting hourlyRate has changed.
    // The View hourly rate text field is observing meeting hourlyRate, and is notified.
	if ([keyInQuestion isEqualToString:BSMeetingHourlyRateKey]) {
        return [NSSet setWithObjects:BSParticipantsKey, nil];  
    }
	return [super keyPathsForValuesAffectingValueForKey:keyInQuestion];      
}

@end

