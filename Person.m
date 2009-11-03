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
@synthesize defaultBillingRate;

// used Accessorizer to generate accessor method implementations
#pragma mark -
#pragma mark Initializers
// init
- (id)init {

    // Ref Hillegass pg 213
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(handleDefaultBillingRateChange:)
               name:defaultBillingRateKey
             object:nil];
    DLog(@"Registered with notification center");
    

//    float defaultHourlyRate = 3600.;
    float defaultHourlyRate = [defaultBillingRate floatValue] ;

    
    [self initWithName:@"defaultName"
            hourlyRate:defaultHourlyRate];
    return self;
}

// designated initializer
- (id)initWithName:(NSString*)aName
        hourlyRate:(float)anHourlyRate{
    
    if (self = [super init]) {
        [self setName:aName];
        [self setHourlyRate:anHourlyRate];      
    }
    return self;
}

#pragma mark -
#pragma mark Other methods

- (void)dealloc {
    [name release], name = nil;
    [defaultBillingRate release], defaultBillingRate = nil;

    [super dealloc];
}

- (NSString *)description {
    
    NSString *descriptionString = @"";

    NSString *NameString = [[NSString stringWithFormat:@"%@", [self name]]
                                      stringByPaddingToLength: 15 withString: @" " startingAtIndex:0];
    
    descriptionString = [descriptionString stringByAppendingString:NameString];    
    
    NSString *HourlyRateString = [NSString stringWithFormat:@"%10.2f \n",
                                            [self hourlyRate]];
    
    descriptionString = [descriptionString stringByAppendingString:HourlyRateString];            
    
    return descriptionString;    
}

// Ref Hillegass pg 155-156
// Use global constant to use in forKey: argument, compiler warns if misspelled
- (void)encodeWithCoder:(NSCoder *)coder {
    // Hal recommends don't access ivar directly, always use accessor
    // e.g. don't use name, use setter self.name or [self name]
    [coder encodeObject:self.name forKey:BSPersonNameKey];
    [coder encodeFloat:self.hourlyRate forKey:BSPersonHourlyRateKey];
}

- (id)initWithCoder:(NSCoder *)coder {
    // don't call superclass initwithcoder, because NSObject doesn't have one.
    // Ref Hillegass pg 156
    [super init];
    
    // Right hand side uses setter, which will retain assigned value
    self.name = [[coder decodeObjectForKey:BSPersonNameKey] retain];
    self.hourlyRate = [coder decodeFloatForKey:BSPersonHourlyRateKey];
    return self;
}

// Ref Hillegass pg 214
- (void)handleDefaultBillingRateChange:(NSNotification *)note {
    DLog(@"Received notification: %@", note);
    NSNumber *tempRate = [[note userInfo] objectForKey:defaultBillingRateKey];
    [self setDefaultBillingRate:tempRate];
}



@end
