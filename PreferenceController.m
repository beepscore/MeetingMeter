//
//  PreferenceController.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/30/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "PreferenceController.h"
NSString * const defaultBillingRateKey = @"defaultBillingRate";
NSString * const defaultBillingRateChangedNotification = @"defaultBillingRateChanged";

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

- (NSNumber *)defaultBillingRate{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:defaultBillingRateKey];
}


- (void)windowDidLoad {
    
    [colorWell setColor:[self tableBgColor]];
    [checkbox setState:[self emptyDoc]];
}

// Ref Hillegass pg 215
- (IBAction)changeBackgroundColor:(id)sender {
    
    NSColor *color = [sender color];
    NSData *colorAsData;
    colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults]
     setObject:colorAsData
     forKey:BNRTableBgColorKey];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSLog(@"Sending color notification");
    NSDictionary *d = [NSDictionary dictionaryWithObject:color forKey:@"color"];
    [nc postNotificationName:BNRColorChangedNotification 
                      object:self 
                    userInfo:d];
}

// Ref Hillegass pg 215
- (IBAction)changeDefaultBillingRate:(id)sender {
    
    // TODO: Check the value of defaultBillingRate here
    NSNumber *defaultBillingRate = [defaultBillingRateTextField objectValue];
    NSData *defaultBillingRateAsData;
    defaultBillingRateAsData = [NSKeyedArchiver archivedDataWithRootObject:defaultBillingRate];
    [[NSUserDefaults standardUserDefaults]
     setObject:defaultBillingRateAsData
     forKey:defaultBillingRateKey];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSLog(@"Sending defaultBillingRate notification");
    NSDictionary *d = [NSDictionary dictionaryWithObject:defaultBillingRate forKey:defaultBillingRateKey];
    [nc postNotificationName:defaultBillingRateChangedNotification 
                      object:self 
                    userInfo:d];
}



- (IBAction)changeNewEmptyDoc:(id)sender {
    
    int state = [checkbox state];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:BNREmptyDocKey];
}

@end

