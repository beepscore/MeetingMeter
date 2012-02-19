//
//  PreferenceController.h
//  MeetingMeter
//
//  Created by Steve Baker on 10/30/09.
//  Copyright 2009 Beepscore LLC. All rights reserved. 
//

#import <Cocoa/Cocoa.h>
#import "BSGlobalValues.h"

extern NSString * const defaultNameKey;
extern NSString * const defaultNameChangedNotification;
extern NSString * const defaultBillingRateKey;
extern NSString * const defaultBillingRateChangedNotification;


@interface PreferenceController : NSWindowController {
#pragma mark -
#pragma mark Instance variables
    IBOutlet NSTextField *defaultNameTextField;
    IBOutlet NSTextField *defaultBillingRateTextField;
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton *checkbox;
}
#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark IBActions
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeNewEmptyDoc:(id)sender;

- (NSString *)defaultName;
- (NSNumber *)defaultBillingRate;
- (NSColor *)tableBgColor;
- (BOOL)emptyDoc;

@end
