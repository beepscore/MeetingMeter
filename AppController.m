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
+ (void)initialize {
    // Create a dictionary
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    // Archive the color object
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:
                           [NSColor yellowColor]];
    
    // Put defaults in the dictionary
    [defaultValues setObject:colorAsData forKey:BNRTableBgColorKey];
    [defaultValues setObject:[NSNumber numberWithBool:YES] 
                      forKey:BNREmptyDocKey];
    
    // Register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    DLog(@"registered defaults: %@", defaultValues);
}

- (id)init {
    if (![super initWithWindowNibName:@"About"])
        return nil;
    
    return self;
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
