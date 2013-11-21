//
//  Person.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/10/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "Person.h"

@implementation Person

#pragma mark -
#pragma mark Accessors
@synthesize name;
@synthesize hourlyRate;
@synthesize defaultName;
@synthesize defaultBillingRate;

#pragma mark -
- (void)dealloc {
    // TODO:  removeObserver from notification center?
    name = nil;
    hourlyRate = nil;
    defaultName = nil;
    defaultBillingRate = nil;
}

#pragma mark - Initializers
// override superclass' designated initializer. Ref Hillegass pg 57
- (id)init {
    // call designated initializer
    // Ref: Hal's preferences fun example
    return [self initWithName:nil hourlyRate:nil];
}

// designated initializer
- (id)initWithName:(NSString *)aName
        hourlyRate:(NSNumber *)anHourlyRate {

    // call super's designated initializer
    self = [super init];
    if (self) {

        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(handleDefaultNameChange:)
                   name:defaultNameKey
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(handleDefaultBillingRateChange:)
                   name:defaultBillingRateKey
                 object:nil];
        
        DLog(@"Registered with notification center");
        
        if (!aName) {
            [self setName:
             [[NSUserDefaults standardUserDefaults] valueForKey:defaultNameKey]];
        } else {
            [self setName:aName];
        }
        
        if (!anHourlyRate) {
            [self setHourlyRate:
             [[NSUserDefaults standardUserDefaults] valueForKey:defaultBillingRateKey]];
        } else {
            [self setHourlyRate:anHourlyRate];
        }
        
    }
    return self;
}

#pragma mark -
#pragma mark Other methods
- (NSString *)description {

    NSString *descriptionString = @"";

    NSString *NameString = [[NSString stringWithFormat:@"%@",
			     [self name]] stringByPaddingToLength:15
			    withString:@" "
			    startingAtIndex:0];

    descriptionString = [descriptionString stringByAppendingString:NameString];
    NSString *HourlyRateString = [NSString stringWithFormat:@"%10.2f \n",
				  [[self hourlyRate] floatValue]];

    descriptionString = [descriptionString stringByAppendingString:HourlyRateString];

    return descriptionString;
}

// Ref Hillegass pg 155-156
// Use global constant to use in forKey: argument, compiler warns if misspelled
- (void)encodeWithCoder:(NSCoder *)coder {
    // Hal recommends don't access ivar directly, always use accessor
    // e.g. don't use name, use setter self.name or [self name]
    [coder encodeObject:self.name forKey:BSPersonNameKey];
    [coder encodeObject:self.hourlyRate forKey:BSPersonHourlyRateKey];
}

- (id)initWithCoder:(NSCoder *)coder {
    // don't call superclass initwithcoder, because NSObject doesn't have one.
    // Ref Hillegass pg 156
    self = [super init];

    // Right hand side uses setter, which will retain assigned value
    self.name = [coder decodeObjectForKey:BSPersonNameKey];
    self.hourlyRate = [coder decodeObjectForKey:BSPersonHourlyRateKey];
    return self;
}

// Ref Hillegass pg 214
- (void)handleDefaultNameChange:(NSNotification *)note {
    DLog(@"Received default name change notification: %@", note);
    [self setDefaultName:[[note userInfo] objectForKey:defaultNameKey]];
}

// Ref Hillegass pg 214
- (void)handleDefaultBillingRateChange:(NSNotification *)note {
    DLog(@"Received default billing rate change notification: %@", note);
    //[self setHourlyRate:[[note userInfo] objectForKey:defaultBillingRateKey]];
    [self setDefaultBillingRate:[[note userInfo] objectForKey:defaultBillingRateKey]];
}

@end
