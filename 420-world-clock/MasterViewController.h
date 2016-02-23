//
//  MasterViewController.h
//  420-world-clock
//
//  Created by Thiago Peres on 22/02/16.
//  Copyright © 2016 peres. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WhirlyGlobeMaplyComponent/WhirlyGlobeViewController.h>
@import MapKit;
@class WCCity;

@class DetailViewController;

@interface MasterViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, strong) WCCity *city;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

