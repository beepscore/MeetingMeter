//
//  PreferenceController.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/30/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "PreferenceController.h"
NSString * const defaultBillingRateKey = @"defaultBillingRate";

@implementation PreferenceController

- (id)init {
    if (![super initWithWindowNibName:@"Preferences"])
        return nil;
    
    return self;
}

- (NSColor *)tableBgColor{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:BNRTableBgColorKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

- (BOOL)emptyDoc{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:BNREmptyDocKey];
}


- (void)windowDidLoad {
    
    [colorWell setColor:[self tableBgColor]];
    [checkbox setState:[self emptyDoc]];
}

// Ref Hillegass pg 215
- (IBAction)changeBackgroundColor:(id)sender {
    
    //    NSColor *color = [colorWell color];
    //    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:colorAsData forKey:BNRTableBgColorKey];
    //    
    //    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //    [nc postNotificationName:BNRColorChangedNotification object:self];
    
    NSColor *color = [sender color];
    NSData *colorAsData;
    colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults]
     setObject:colorAsData
     forKey:BNRTableBgColorKey];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSLog(@"Sending notification");
    NSDictionary *d = [NSDictionary dictionaryWithObject:color forKey:@"color"];
    [nc postNotificationName:BNRColorChangedNotification 
                      object:self 
                    userInfo:d];
    
}


- (IBAction)changeNewEmptyDoc:(id)sender {
    
    int state = [checkbox state];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:BNREmptyDocKey];
}

@end

