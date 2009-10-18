//
//  MyDocument.h
//  MeetingMeter
//
//  Created by Steve Baker on 10/16/09.
//  Copyright 2009 Beepscore LLC. All rights reserved. 
//
//  UW CP-120 Certificate in iPhone and Cocoa Development
//  Q1 Intro to Programming in Objective-C and the Cocoa Framework.
//  Homework assignment 3 due 21 Oct 09.
//  The app adjusts rate as people enter and leave meeting.
//  Cost appears accurate within approximately 0.25%.
//  TODO:  Check small potential errors due to rounding and time differences.

#import <Cocoa/Cocoa.h>
// When possible, use @class, not #import in header file.
// #import requires recompile whenever imported file changes.
@class Meeting;

@interface MyDocument : NSDocument
{
    Meeting *meeting;
    
    NSTimer *timer;
    NSDate *previousDate;
    
    IBOutlet NSButton *beginMeetingButton;
    IBOutlet NSButton *endMeetingButton;
    IBOutlet NSTextField *hourlyRateField;

    IBOutlet NSTextField *startTimeField;
    IBOutlet NSTextField *endTimeField;
    IBOutlet NSTextField *elapsedTimeField;
    IBOutlet NSTextField *accruedCostField;    
}

#pragma mark -
#pragma mark Accessors
@property (retain, nonatomic) Meeting *meeting;

- (NSDate *)previousDate;
- (void)setPreviousDate:(NSDate *)aPreviousDate;

#pragma mark -
#pragma mark IBActions
- (IBAction)beginMeeting:(id)sender;
- (IBAction)endMeeting:(id)sender;
- (IBAction)debugDump:(id)sender;

#pragma mark -
#pragma mark Other methods
- (void)stopGo;
- (void)updateGUI:(NSTimer *)aTimer;
- (void)updateHourlyRateField;

@end
