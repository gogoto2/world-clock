//
//  WCCity.h
//  420-world-clock
//
//  Created by Thiago Peres on 23/02/16.
//  Copyright © 2016 peres. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import MapKit;

@class FMResultSet;

@interface WCCity : NSObject <MKAnnotation>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *countryCode;
@property (nonatomic, readonly) NSUInteger population;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKCoordinateRegion region;
@property (nonatomic, readonly) NSTimeZone *timezone;
@property (nonatomic, readonly) NSString *currentTimeString;

- (instancetype)initWithResultSet:(FMResultSet*)set;

- (NSString*)title;

@end
