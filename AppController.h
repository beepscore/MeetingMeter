//
//  AppController.h
//  MeetingMeter
//
//  Created by Steve Baker on 10/30/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BSGlobalValues.h"
@class PreferenceController;

@interface AppController : NSWindowController {
    
    PreferenceController *preferenceController;
    IBOutlet NSPanel *window;
}

- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)showAboutPanel:(id)sender;
@end
