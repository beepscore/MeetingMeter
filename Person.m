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

@end
