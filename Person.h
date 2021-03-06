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
#import "PreferenceController.h"

@interface Person : NSObject <NSCoding> {
    // declare instance variables
    NSString *name;
    NSNumber *hourlyRate;
    NSString *defaultName;
    NSNumber *defaultBillingRate;
}

#pragma mark - Accessors
@property (readwrite, copy) NSString *name;
@property (nonatomic, copy) NSString *defaultName;
@property (nonatomic, strong) NSNumber *defaultBillingRate;

// TODO:  Previously Person hourlyRate was NSDecimal *
// This displayed correctly in MyDocument's view array controller.
// When a person's rate was edited, the view appeared correct, and the rate value *appeared* correct.
// However the array controller changed the hourlyRate's type to NSCFNumber?
// This caused the Meeting -hourlyRate calculation to return garbage.
// I tried converting type in the getter, but it conflicted with the declared type.
// So declare hourlyRate as NSNumber *.
// Possibly revisit this some day.
@property (readwrite, strong) NSNumber *hourlyRate;

#pragma mark -
#pragma mark Initializers
// designated initializer
- (id)initWithName:(NSString*)aName
        hourlyRate:(NSNumber *)anHourlyRate;

- (void)handleDefaultNameChange:(NSNotification *)note;
- (void)handleDefaultBillingRateChange:(NSNotification *)note;

@end
