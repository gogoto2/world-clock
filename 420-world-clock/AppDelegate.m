//
//  AppDelegate.m
//  420-world-clock
//
//  Created by Thiago Peres on 22/02/16.
//  Copyright © 2016 peres. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import <WhirlyGlobeMaplyComponent/WhirlyGlobeViewController.h>
#import "WCCity.h"
#import "MasterViewController.h"
@import FMDB;

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (NSUInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [calendar setTimeZone:[NSTimeZone defaultTimeZone]];
    components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    
    return components.minute;
}

//
// Returns an array of timezone names that contain cities with 100k people or more
//
- (NSArray*)availableTimezoneNames
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"geo" ofType:@"sqlite"]];
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
- (NSArray*)current420timezoneNames
{
    NSArray *names = [self availableTimezoneNames];
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

- (NSString*)randomTimezoneName
{
    NSArray *a = [self current420timezoneNames];
    
    return [a objectAtIndex:arc4random() % [a count]];
}

//
// Returns a WCCity object containing a random city that is at the given timezone.
//
- (WCCity*)cityWithTimezoneNamed:(NSString*)timezoneName
{
    NSLog(@"%@", timezoneName);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"geo" ofType:@"sqlite"]];
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers firstObject];
    splitViewController.delegate = self;
    
    MasterViewController *mvc = (MasterViewController*)[navigationController.viewControllers firstObject];
    [mvc setCity:[self cityWithTimezoneNamed:[self randomTimezoneName]]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
