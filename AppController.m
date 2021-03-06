//
//  AppController.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/30/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

// Ref Hillegass pg 203
+ (void)initialize {
    
    // Create a dictionary
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

    // Archive the color object
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:
                           [NSColor yellowColor]];
    
    // Put defaults in the dictionary
    // TODO:  Investigate difference between shared user defaults and standard user defaults
    [defaultValues setValue:@"Anonymous Participant" forKey:defaultNameKey];    
    [defaultValues setValue:[NSNumber numberWithFloat:36.00] forKey:defaultBillingRateKey];
    
    [defaultValues setObject:colorAsData forKey:BNRTableBgColorKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES] 
                      forKey:BNREmptyDocKey];
    
    // Register the dictionary of standard user defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    DLog(@"registered defaults: %@", defaultValues);

    // shared user defaults
  	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultValues];
    
}

- (id)init {
    return [super initWithWindowNibName:@"About"];
}

- (void)windowDidLoad {
    DLog(@"About.nib file is loaded");
}


- (IBAction)showPreferencePanel:(id)sender {
    
    // Is preferenceController nil?
    if (!preferenceController) {
        preferenceController = [[PreferenceController alloc] init];
    }
    DLog(@"showing %@", preferenceController);
    [preferenceController showWindow:self];
}


- (IBAction)showAboutPanel:(id)sender {
    
    // Is aboutPanel nil?
    if (!window) {
        
        // load aboutPanel from nib?
        DLog(@"aboutPanel window = nil");
    }
    
    //DLog(@"showing %@", aboutPanel);
    DLog(@"showing %@", self);
    [self showWindow:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    DLog(@"applicationShouldOpenUntitledFile:");
    return [[NSUserDefaults standardUserDefaults] boolForKey:BNREmptyDocKey];
}

@end
