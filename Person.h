//
//  Person.h
//  MeetingMeter
//
//  Created by Steve Baker on 10/10/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//
//  This class is a MVC model. It won't have outlets directly to view .xib file.
//  Use MVC controller such as MeetingMeterAppDelegate to update view.

#import <Foundation/Foundation.h>
#import "BSGlobalValues.h"

@interface Person : NSObject {
    // declare instance variables
    NSString *name;
    NSDecimalNumber *hourlyRate;
}

@property (readwrite, copy) NSString *name;
@property (retain, nonatomic) NSDecimalNumber *hourlyRate;

#pragma mark -
#pragma mark Initializers
// designated initializer
- (id)initWithName:(NSString*)aName
        hourlyRate:(NSDecimalNumber*)anHourlyRate;

@end
