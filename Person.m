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
@synthesize hourlyRateTwo;


#pragma mark -
#pragma mark Initializers
// use Accessorizer to generate accessor method implementations

// init
- (id)init {

//  NSDecimalNumber *minimumHourlyWage =
//      [NSDecimalNumber decimalNumberWithString:@"8.55"];

    NSDecimalNumber *defaultHourlyRate =
    [NSDecimalNumber decimalNumberWithString:@"3600"];
    
    [self initWithName:@"defaultName"
            hourlyRate:defaultHourlyRate
         hourlyRateTwo: 3600.00];
    return self;
}

- (id)initWithName:(NSString*)aName
        hourlyRate:(NSDecimalNumber*)anHourlyRate
     hourlyRateTwo:(float)anHourlyRateTwo{
    
    if (![super init])
        return nil;
    [self setName:aName];
    [self setHourlyRate:anHourlyRate];
    [self setHourlyRateTwo:anHourlyRateTwo];
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
    return [NSString stringWithFormat:@"name = %@, rate = %@ rate2 = %f",
            [self name], [self hourlyRate], [self hourlyRateTwo]];    
}

@end
