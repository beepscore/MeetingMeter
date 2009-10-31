//
//  PreferenceController.h
//  MeetingMeter
//
//  Created by Steve Baker on 10/30/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BSGlobalValues.h"

@interface PreferenceController : NSWindowController {
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSButton *checkbox;
}
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeNewEmptyDoc:(id)sender;

- (NSColor *)tableBgColor;
- (BOOL)emptyDoc;

@end
