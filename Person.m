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

// used Accessorizer to generate accessor method implementations
#pragma mark -
#pragma mark Initializers
// init
- (id)init {

    float defaultHourlyRate = 3600.;
    
    [self initWithName:@"defaultName"
            hourlyRate:defaultHourlyRate];
    return self;
}

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
    [super dealloc];
}

- (NSString *)description {
    
    NSString *descriptionString = @"";

    NSString *NameString = [[NSString stringWithFormat:@"%@", [self name]]
                                      stringByPaddingToLength: 15 withString: @" " startingAtIndex:0];
    
    descriptionString = [descriptionString stringByAppendingString:NameString];    
    
    NSString *HourlyRateString = [NSString stringWithFormat:@"%20f \n",
                                            [self hourlyRate]];
    
    descriptionString = [descriptionString stringByAppendingString:HourlyRateString];            
    
    return descriptionString;    
}

// Ref Hillegass pg 155-156
// Use global constant to use in forKey: argument, compiler warns if misspelled
- (void)encodeWithCoder:(NSCoder *)coder {
    // Hal recommends don't access ivar directly, always use accessor
    // e.g. don't use name, use setter self.name or [self name]
    [coder encodeObject:self.name forKey:BSNameKey];
    [coder encodeFloat:self.hourlyRate forKey:BSHourlyRateKey];
}

- (id)initWithCoder:(NSCoder *)coder {
    // don't call superclass initwithcoder, because NSObject doesn't have one.
    // Ref Hillegass pg 156
    [super init];
    
    // Right hand side uses setter, which will retain assigned value
    self.name = [[coder decodeObjectForKey:BSNameKey] retain];
    self.hourlyRate = [coder decodeFloatForKey:BSHourlyRateKey];
    return self;
}


@end
