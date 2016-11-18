//
//  TEMapViewController.m
//  Telescope
//
//  Created by zhangguang on 16/11/18.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TEMapViewController () <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager* locationManager;

@property (nonatomic,readonly) MKMapView* mapView;

@end

@implementation TEMapViewController

#pragma mark - *** Init ***
- (instancetype)init{
    if (self = [super init]) {
          [self.locationManager requestWhenInUseAuthorization];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
      
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Do any additional setup after loading the view.
}

#pragma mark - *** Properties ****
- (CLLocationManager*) locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}


- (MKMapView*)mapView{
    return (MKMapView*)self.view;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - *** Api ***
- (void)showUserLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"👽👽👽👽👽👽 Location Authorization Status kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"👽👽👽👽👽👽 Location Authorization Status kCLAuthorizationStatusRestricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"👽👽👽👽👽👽 Location Authorization Status kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"👽👽👽👽👽👽 Location Authorization Status kCLAuthorizationStatusAuthorizedAlways");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"👽👽👽👽👽👽 Location Authorization Status kCLAuthorizationStatusAuthorizedWhenInUse");
            break;
        default:
            break;
    }
    
    if (kCLAuthorizationStatusDenied == status) {
        
    }
    if ([CLLocationManager locationServicesEnabled] ) {
        self.mapView.showsUserLocation = YES;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager startUpdatingLocation];
        
    }
    else{
        [self.locationManager requestAlwaysAuthorization];
    }
}


#pragma mark  *** CLLocationManagerDelegate ***

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations.count > 0) {
        CLLocation* location = locations.firstObject;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 9500, 9500);
        [self.mapView setRegion:region animated:YES];
    }
}
@end
