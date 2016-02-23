//
//  MasterViewController.m
//  420-world-clock
//
//  Created by Thiago Peres on 22/02/16.
//  Copyright © 2016 peres. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "WCCity.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 10000000, 10000000)];
}

- (void)viewWillAppear:(BOOL)animated {
//    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSDate *object = self.objects[indexPath.row];
//        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
//        [controller setDetailItem:object];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - MapKit Delegate

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        [self.mapView setRegion:self.city.region animated:YES];
    });
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:self.city.class])
    {
        MKPinAnnotationView *ann = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"city"];
        if (ann == nil)
        {
            ann = [[MKPinAnnotationView alloc] initWithAnnotation:self.city reuseIdentifier:@"city"];
            ann.animatesDrop = YES;
            ann.canShowCallout = YES;
        }
        
        return (MKAnnotationView*)ann;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //
    // Easiest and laziest way I could find to compare two coordinates
    //
    if (MKMetersBetweenMapPoints(MKMapPointForCoordinate(mapView.region.center),
                                 MKMapPointForCoordinate(self.city.coordinate)) < 100)
    {
        [mapView addAnnotation:self.city];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views
{
    for (MKPinAnnotationView *obj in views)
    {
        if ([obj isKindOfClass:[MKPinAnnotationView class]])
        {
            [mapView selectAnnotation:obj.annotation animated:YES];
        }
    }
}

@end
