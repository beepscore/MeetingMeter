//
//  MyDocument.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/16/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "MyDocument.h"
#import "Meeting.h"

#define SECONDS_PER_HOUR 3600.
#define MINUTES_PER_HOUR 60.


@implementation MyDocument

#pragma mark -
#pragma mark Accessors
@synthesize meeting;
@synthesize elapsedTimeOld;

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        
        meeting = [[Meeting alloc] initWithExampleValues];
        elapsedTimeOld = [[NSDateComponents alloc] init];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    [self updateHourlyRateField];
    
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}



- (void)updateHourlyRateField {
    // TODO:  Update hourly rate field by observing when participants change
    // register as observer.  Ref Hillegass pg 146
    //    [[meeting participants] addObserver:self
    //                             forKeyPath:@"meeting.participants"
    //                                options:NSKeyValueObservingOptionOld
    //                                context:NULL ];
    
    [meeting hourlyRate];
}

// TODO:  Update hourly rate field by observing when participants change
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context {
//    // update hourlyRateField
//    if (object == [meeting participants]) {
//        [self updateHourlyRateField];
//    }
//}


#pragma mark -
#pragma mark IBActions

- (IBAction)beginMeeting:(id)sender{
    // disable beginMeeting, enable endMeeting buttons
    [beginMeetingButton setEnabled:NO];
    [endMeetingButton setEnabled:YES];

    // TODO:  may be able to eliminate this after implementing observing changes
    [self updateHourlyRateField];
    
    // [[NSDate alloc] init] and [NSDate date] both return current date and time.
    [meeting setStartTime:[NSDate date]];
    
    // Use IB formatter to display NSDate object in the text field
    [startTimeField setObjectValue:[meeting startTime]];
    [meeting setEndTime:nil];     
    [endTimeField setStringValue:@"meeting still going..."]; 
    
    [self stopGo];
}

- (IBAction)endMeeting:(id)sender{
    // disable endMeeting, enable beginMeeting buttons
    [endMeetingButton setEnabled:NO];
    [beginMeetingButton setEnabled:YES];
    // [[NSDate alloc] init] and [NSDate date] both return current date and time.
    [meeting setEndTime:[NSDate date]];     
    [endTimeField setObjectValue:[meeting endTime]];
    
    [self stopGo];
}

- (IBAction)debugDump:(id)sender {
    NSLog(@"%@", [meeting description]);
    NSLog(@"\n\n");
}

#pragma mark -
#pragma mark Other methods

// Timer method.  ref Hillegass pg 315
- (void)stopGo {
    
    if (nil == timer) {
        NSLog(@"Starting");
        // Create a timer
        timer = [[NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateGUI:)
                                                userInfo:nil
                                                 repeats:YES] retain];
        
        [self setElapsedTimeOld:[meeting elapsedTime]];
        [meeting setAccruedCost:[NSDecimalNumber zero]];
        
    } else {
        NSLog(@"Stopping");
        
        // Invalidate and release the timer
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

-(void)updateGUI:(NSTimer *)aTimer {
    // ref http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html#//apple_ref/doc/uid/TP40007836
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    // use "components" to sample and hold current elapsedTime
    // so value won't change during calculations
    NSDateComponents *components = [meeting elapsedTime];
    NSInteger elapsedHours = [components hour];
    NSInteger elapsedMinutes = [components minute];
    // I think NSDateComponents* elapsedTime truncates seconds.
    double elapsedSeconds = [components second];   
    
    [elapsedTimeField setStringValue:[NSString stringWithFormat:@"%02d:%02d:%04.1f", 
                                      elapsedHours, elapsedMinutes, elapsedSeconds]];

    double incrementalTimeInHours = 
       ((elapsedHours - [elapsedTimeOld hour])
        + ((elapsedMinutes - [elapsedTimeOld minute]) / MINUTES_PER_HOUR)
        + ((elapsedSeconds - [elapsedTimeOld second]) / SECONDS_PER_HOUR));

    [self setElapsedTimeOld:components];  

    NSDecimalNumber *incrementalTimeInHoursDecimal = 
    [NSDecimalNumber decimalNumberWithDecimal:
     [[NSNumber numberWithFloat:incrementalTimeInHours] decimalValue]];
    
    NSDecimalNumber *incrementalCost = 
    [[meeting hourlyRate] decimalNumberByMultiplyingBy:incrementalTimeInHoursDecimal];
    
    [meeting setAccruedCost:[[meeting accruedCost] decimalNumberByAdding:incrementalCost]];
    
    [accruedCostField setObjectValue:[meeting accruedCost]];
    
    [gregorian release];
}


- (void)dealloc{
    
    // TODO:  Update hourly rate field by observing when participants change
    // remove observer.  Ref Hillegass pg 146-147
//    [[meeting participants] removeObserver:self forKeyPath:@"meeting.participants"];

    // Ref Hillegass Ch 04 pg 68
    [meeting release]; meeting = nil;
    [elapsedTimeOld release], elapsedTimeOld = nil;
        
    [super dealloc];
}

#pragma mark -
#pragma mark KVO related methods

// Ref Hillegass pg 144, 147
- (void)insertObject:(Person *)aPerson inParticipantsAtIndex:(int)index {
    
    [[[self meeting] participants] insertObject:aPerson atIndex:index];
    [self startObservingPerson:aPerson];
}

- (void)removeObjectFromParticipantsAtIndex: (int) index {
    Person *aPerson = [[[Person alloc] init] autorelease];
    [self stopObservingPerson:aPerson];
    [[[self meeting] participants] removeObjectAtIndex:index];
}

- (void)startObservingPerson:(Person *)aPerson {
    
    [aPerson addObserver:self
              forKeyPath:@"hourlyRate"
                 options:NSKeyValueObservingOptionOld
                 context:NULL];
}

- (void)stopObservingPerson:(Person *)aPerson {
    
    [aPerson removeObserver:self forKeyPath:@"hourlyRate"];
}


@end
