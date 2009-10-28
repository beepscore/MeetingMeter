//
//  MyDocument.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/16/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "MyDocument.h"
#import "Meeting.h"

@implementation MyDocument

#pragma mark -
#pragma mark Accessors
@synthesize meeting;
@synthesize elapsedTimeOld;

- (id)init
{
    if (self = [super init]) {
    
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
    
    // TODO: need this??
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

    [[self meeting] hourlyRate];
}


#pragma mark -
#pragma mark IBActions

- (IBAction)beginMeeting:(id)sender{
    // disable beginMeeting, enable endMeeting buttons
    [beginMeetingButton setEnabled:NO];
    [endMeetingButton setEnabled:YES];
    [[self meeting] startMeeting];
    
    [self stopGo];
}

- (IBAction)endMeeting:(id)sender{
    // disable endMeeting, enable beginMeeting buttons
    [endMeetingButton setEnabled:NO];
    [beginMeetingButton setEnabled:YES];

    [[self meeting] stopMeeting];
    [self stopGo];
}

- (IBAction)debugDump:(id)sender {
    DLog(@"%@", [[self meeting] description]);
    DLog(@"\n\n");
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
        
        [self setElapsedTimeOld:[[self meeting] elapsedTime]];
        [[self meeting] setAccruedCost:[NSDecimalNumber zero]];
        
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
    [[[self meeting] hourlyRate] decimalNumberByMultiplyingBy:incrementalTimeInHoursDecimal];
    
    [[self meeting] setAccruedCost:[[[self meeting] accruedCost] decimalNumberByAdding:incrementalCost]];
        
    [gregorian release];
}


- (void)dealloc{
    
    // remove observer.  Ref Hillegass pg 146-147
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Ref Hillegass Ch 04 pg 68
    [meeting release]; meeting = nil;
    [elapsedTimeOld release], elapsedTimeOld = nil;
        
    [super dealloc];
}

@end
