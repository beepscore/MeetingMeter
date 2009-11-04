//
//  PreferenceController.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/30/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "PreferenceController.h"
NSString * const defaultNameKey = @"defaultName";
NSString * const defaultNameChangedNotification = @"defaultNameChanged";
NSString * const defaultBillingRateKey = @"defaultBillingRate";
NSString * const defaultBillingRateChangedNotification = @"defaultBillingRateChanged";

@implementation PreferenceController

#pragma mark -
#pragma mark Accessors

#pragma mark -

- (id)init {
    if (![super initWithWindowNibName:@"Preferences"])
        return nil;
    
    return self;
}

- (NSString *)defaultName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DLog(@"in -defaultName")
    return [defaults valueForKey:defaultNameKey];
}

- (NSNumber *)defaultBillingRate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DLog(@"in -defaultBillingRate")
    return [defaults objectForKey:defaultBillingRateKey];
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
    // TODO: check this
    [defaultNameTextField setValue:[self defaultName]];
    
    [defaultBillingRateTextField setFloatValue:[[self defaultBillingRate] floatValue]];
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
    DLog(@"Sending color notification");
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

