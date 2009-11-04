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

#pragma mark -
#pragma mark Accessors

#pragma mark -

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

- (float)defaultBillingRate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    DLog(@"in -defaultBillingRate")
//    return [defaults objectForKey:defaultBillingRateKey];
    return [defaults floatForKey:defaultBillingRateKey];

}

- (void)windowDidLoad {
    [colorWell setColor:[self tableBgColor]];
    [checkbox setState:[self emptyDoc]];
    [defaultBillingRateTextField setFloatValue:[self defaultBillingRate]];
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

// Ref Hillegass pg 215
- (IBAction)changeDefaultBillingRate:(id)sender {
    
//    NSNumber *tempBillRate = [NSNumber numberWithFloat:[defaultBillingRateTextField floatValue]];
//    
//    NSData *defaultBillingRateAsData;
//    defaultBillingRateAsData = [NSKeyedArchiver archivedDataWithRootObject:tempBillRate];
//    [[NSUserDefaults standardUserDefaults]
//     setObject:defaultBillingRateAsData
//     forKey:defaultBillingRateKey];
//    
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    DLog(@"Sending defaultBillingRate notification");
//    NSDictionary *d = [NSDictionary dictionaryWithObject:tempBillRate forKey:defaultBillingRateKey];
//    [nc postNotificationName:defaultBillingRateChangedNotification 
//                      object:self 
//                    userInfo:d];
//    NSNumber *tempBillRate = [NSNumber numberWithFloat:[defaultBillingRateTextField floatValue]];
    
    float defaultBillRateFloat = [defaultBillingRateTextField floatValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:defaultBillRateFloat forKey:defaultBillingRateKey];
}


- (IBAction)changeNewEmptyDoc:(id)sender {
    
    int state = [checkbox state];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:state forKey:BNREmptyDocKey];
}

@end

