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

#pragma mark -
- (void)dealloc{
    // remove observer.  Ref Hillegass pg 209, 214
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Ref Hillegass Ch 04 pg 68
    [meeting release], meeting = nil;
    [elapsedTimeOld release], elapsedTimeOld = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Initializers
- (id)init
{
    if (self = [super init]) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
        
        NSUndoManager *anUndoManager = [self undoManager];
        // Pass MyDocument's undo manager to Meeting for Meeting to use
        meeting = [[Meeting alloc] initWithExampleValues:anUndoManager];
        elapsedTimeOld = [[NSDateComponents alloc] init];

        // Ref Hillegass pg 213
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(handleColorChange:)
                   name:BNRColorChangedNotification
                 object:nil];
        DLog(@"Registered with notification center");
    }
    return self;
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
- (void)updateHourlyRateField {
    
    [[self meeting] hourlyRate];
}

-(void)updateGUI:(NSTimer *)aTimer {
    // ref http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html#//apple_ref/doc/uid/TP40007836
    // use "components" to sample and hold current elapsedTime
    // so value won't change during calculations
    NSDateComponents *components = [meeting elapsedTime];
    NSInteger elapsedHours = [components hour];
    NSInteger elapsedMinutes = [components minute];
    // I think NSDateComponents* elapsedTime truncates seconds.
    double elapsedSeconds = [components second];   
    
    [elapsedTimeField setStringValue:[NSString stringWithFormat:@"%02ld:%02ld:%04.1f", 
                                      (long)elapsedHours, (long)elapsedMinutes, elapsedSeconds]];
    
    double incrementalTimeInHours = 
    ((elapsedHours - [elapsedTimeOld hour])
     + ((elapsedMinutes - [elapsedTimeOld minute]) / MINUTES_PER_HOUR)
     + ((elapsedSeconds - [elapsedTimeOld second]) / SECONDS_PER_HOUR));
    
    [self setElapsedTimeOld:components];  
    
    NSDecimalNumber *incrementalTimeInHoursDecimal = 
    [NSDecimalNumber decimalNumberWithDecimal:
     [[NSNumber numberWithFloat:incrementalTimeInHours] decimalValue]];
    
    NSDecimalNumber *hourlyRateDecimal = [NSDecimalNumber decimalNumberWithDecimal:
    [[[self meeting] hourlyRate] decimalValue]];
    
    NSDecimalNumber *incrementalCost = [hourlyRateDecimal
                                        decimalNumberByMultiplyingBy:incrementalTimeInHoursDecimal];
    
    [[self meeting] setAccruedCost:[[[self meeting] accruedCost] decimalNumberByAdding:incrementalCost]];
}

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData;
    colorAsData = [defaults objectForKey:BNRTableBgColorKey];
    
    [tableView setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorAsData]];
}


- (NSData *)dataOfType:(NSString *)aType
                 error:(NSError **)outError {
    // Ref Hillegass pg 162
    // End editing
    [[tableView window] endEditingFor:nil];
    
    // Create an NSData object from the participants array
    return [NSKeyedArchiver archivedDataWithRootObject:[[self meeting] participants]];
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError {
    
    NSLog(@"About to read data of type %@", typeName);
    NSMutableArray *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException * e) {
        if (outError) {
            NSDictionary *d = [NSDictionary 
                               dictionaryWithObject:@"The data is corrupted"
                               forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain
                                            code:unimpErr
                                        userInfo:d];
        }
        return NO;
    }
    [[self meeting] setParticipants:newArray];    
    return YES;
}

// Ref Hillegass pg 214
- (void)handleColorChange:(NSNotification *)note {
    DLog(@"Received notification: %@", note);
    NSColor *color = [[note userInfo] objectForKey:@"color"];
    [tableView setBackgroundColor:color];
}

@end
