//
//  WCCity.m
//  420-world-clock
//
//  Created by Thiago Peres on 23/02/16.
//  Copyright © 2016 peres. All rights reserved.
//

#import "WCCity.h"

@import FMDB;

@implementation WCCity

- (instancetype)initWithResultSet:(FMResultSet*)set
{
    self = [super init];
    if (self)
    {
        _name = [set stringForColumn:@"asciiname"];
        _countryCode = [set stringForColumn:@"Country"];
        _population = [set intForColumnIndex:14];
        _coordinate = CLLocationCoordinate2DMake([set doubleForColumn:@"latitude"], [set doubleForColumn:@"longitude"]);
        _timezone = [NSTimeZone timeZoneWithName:[set stringForColumn:@"timezone"]];
    }
    
    return self;
}

- (NSString*)currentTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:self.timezone];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@, %@ - %lu - (%f,%f)",  self.name, self.countryCode, (unsigned long)self.population, self.coordinate.latitude, self.coordinate.longitude];
}

- (NSString*)title
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:self.timezone];
    
    return [NSString stringWithFormat:@"%@ in %@, %@", [self currentTimeString], self.name, self.countryCode];
}

- (NSString*)subtitle
{
    return [NSString stringWithFormat:@"Population: %lu", (unsigned long)self.population];
}

- (MKCoordinateRegion)region
{
    return MKCoordinateRegionMakeWithDistance(self.coordinate, 10000, 10000);
}

@end
