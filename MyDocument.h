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
#import "Meeting.h"

@interface MyDocument : NSDocument
{
    Meeting *myMeeting;
}

@property (retain, nonatomic) Meeting *myMeeting;

- (IBAction)debugDump:(id)sender;

@end
