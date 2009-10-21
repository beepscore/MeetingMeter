//
//  Person.m
//  MeetingMeter
//
//  Created by Steve Baker on 10/10/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize name;
@synthesize hourlyRate;

#pragma mark -
#pragma mark Initializers
// used Accessorizer to generate accessor method implementations

// init
- (id)init {

    NSDecimalNumber *defaultHourlyRate =
     [NSDecimalNumber decimalNumberWithString:@"3600"];
    
    [self initWithName:@"defaultName"
            hourlyRate:defaultHourlyRate];
    return self;
}

- (id)initWithName:(NSString*)aName
        hourlyRate:(NSDecimalNumber*)anHourlyRate{
    
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
    [hourlyRate release], hourlyRate = nil;
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name = %@, rate = %@",
            [self name], [self hourlyRate]];    
}

@end
