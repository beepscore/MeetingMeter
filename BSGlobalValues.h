/*
 *  BSGlobalValues.h
 *  MeetingMeter
 *
 *  Created by Steve Baker on 10/27/09.
 *  Copyright 2009 Beepscore LLC. All rights reserved.
 *
 */

// Ref http://www.cocoadev.com/index.pl?GlobalVariablesInCocoa


#define MINUTES_PER_HOUR 60.
#define SECONDS_PER_HOUR 3600.

extern NSString * const BSPersonNameKey;
extern NSString * const BSPersonHourlyRateKey;
extern NSString * const BSMeetingHourlyRateKey;
extern NSString * const BSParticipantsKey;

// Ref Hillegass pg 202
extern NSString * const BNRTableBgColorKey;
extern NSString * const BNREmptyDocKey;
extern NSString * const BNRColorChangedNotification;

#pragma mark -
// Ref http://iphoneincubator.com/blog/debugging/the-evolution-of-a-replacement-for-nslog
// Ref in Project/Edit Project Settings/Build/GCC 4.2 Preprocessing/Preprocessor macros add DEBUG=1
//     http://iphoneincubator.com/blog/xcode/how-to-add-debug-flag-in-a-3-0-project-in-xcode
// DLog logs if DEBUG, ALog always logs
// DLog is almost a drop-in replacement for NSLog
// DLog();
// DLog(@"here");
// DLog(@"value: %d", x);
// Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@"%@", aStringVariable);
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#pragma mark -