//
//  PreferenceController.h
//  MeetingMeter
//
//  Created by Steve Baker on 10/30/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BSGlobalValues.h"

extern NSString * const defaultBillingRateKey;
extern NSString * const defaultBillingRateChangedNotification;


@interface PreferenceController : NSWindowController {
#pragma mark -
#pragma mark Instance variables
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton *checkbox;
    IBOutlet NSTextField *defaultBillingRateTextField;

}
#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark IBActions
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeNewEmptyDoc:(id)sender;
- (IBAction)changeDefaultBillingRate:(id)sender;

- (NSColor *)tableBgColor;
- (BOOL)emptyDoc;
//- (NSNumber *)defaultBillingRate;
- (float)defaultBillingRate;

@end
