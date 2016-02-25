//
//  WCController.m
//  420-world-clock
//
//  Created by Thiago Peres on 25/02/16.
//  Copyright © 2016 peres. All rights reserved.
//

#import "WCController.h"
#import "WCCity.h"
@import FMDB;

@implementation WCController

//- (NSUInteger)minute
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
//    components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
//    
//    return components.minute;
//}

//
// Returns an array of timezone names that contain cities with 100k people or more
//
+ (NSArray*)availableTimezoneNames
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"geo" ofType:@"sqlite"]];
    if (![db open])
    {
        return nil;
    }
    
    FMResultSet *set = [db executeQuery:@"SELECT DISTINCT timezone FROM geoname WHERE timezone IS NOT NULL AND population > 100000 ORDER BY timezone asc"];
    while ([set next])
    {
        [array addObject:[set stringForColumn:@"timezone"]];
    }
    
    return array;
}

//
// Returns an array containing strings with timezone names of timezones that are close to 4:20
// if no timezone is found, falls back to timezones where it's between 3am/pm and 3:59am/pm
//
+ (NSArray*)current420timezoneNames
{
    NSArray *names = [WCController availableTimezoneNames];
    NSMutableArray *current420 = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    //
    // Add timezones that are between 4 and 4:20 am/pm
    //
    for (NSString *name in names)
    {
        [calendar setTimeZone:[NSTimeZone timeZoneWithName:name]];
        components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
        
        if ((components.hour == 4 && components.minute <= 20) || (components.hour == 16 && components.minute <= 20))
        {
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:name]];
            [current420 addObject:name];
        }
    }
    
    //
    // If no timezones are found, fallback to the ones between 3-3:59 am/pm
    //
    if (current420.count == 0)
    {
        for (NSString *name in names)
        {
            [calendar setTimeZone:[NSTimeZone timeZoneWithName:name]];
            components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
            
            if ((components.hour == 3 && components.minute <= 59) || (components.hour == 3 && components.minute <= 59))
            {
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:name]];
                [current420 addObject:name];
            }
        }
    }
    
    NSLog(@"%@", current420);
    
    return current420;
}

+ (NSString*)randomTimezoneName
{
    NSArray *a = [self current420timezoneNames];
    
    return [a objectAtIndex:arc4random() % [a count]];
}

//
// Returns a WCCity object containing a random city that is at the given timezone.
//
+ (WCCity*)cityWithTimezoneNamed:(NSString*)timezoneName
{
    NSLog(@"%@", timezoneName);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"geo" ofType:@"sqlite"]];
    if (![db open])
    {
        return nil;
    }
    
    FMResultSet *set = [db executeQueryWithFormat:@"SELECT *, c.Country FROM geoname as g, country as c WHERE g.population > 100000 AND timezone = %@ AND g.country = c.ISO ORDER BY RANDOM() LIMIT 1", timezoneName];
    
    [set next];
    
    WCCity *city = [[WCCity alloc] initWithResultSet:set];
    
    
    
    NSLog(@"%@", city);
    return city;
}

+ (WCCity*)random420City
{
    return [WCController cityWithTimezoneNamed:[WCController randomTimezoneName]];
}

@end
