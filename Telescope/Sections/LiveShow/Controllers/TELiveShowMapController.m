//
//  TELiveShowMapController.m
//  Telescope
//
//  Created by zhangguang on 17/1/11.
//  Copyright © 2017年 com.v2tech.Telescope. All rights reserved.
//

#import "TELiveShowMapController.h"
#import <MapKit/MapKit.h>
#import "TENetworkKit.h"
#import "TEAnnotation.h"
#import "TEVideoPlayerViewController.h"

@interface TELiveShowMapController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSArray<TELiveShowInfo*>* lives;
@end

@implementation TELiveShowMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray<NSString*>* rtmps = @[@"rtmp://live.hkstv.hk.lxdns.com/live/hks",@"rtmp://203.207.99.19:1935/live/zgjyt",@"rtmp://203.207.99.19:1935/live/CCTV1",@"rtmp://203.207.99.19:1935/live/CCTV2",@"rtmp://203.207.99.19:1935/live/CCTV4",@"rtmp://203.207.99.19:1935/live/CCTV10",@"rtmp://203.207.99.19:1935/live/CCTV12",@"rtmp://203.207.99.19:1935/live/CCTV5"];
    
    [TENETWORKKIT fetchLiveShowListWithCompletion:^(TEResponse<NSArray<TELiveShowInfo *> *> *response) {
        NSArray<TELiveShowInfo*>* array = response.body;
        [array enumerateObjectsUsingBlock:^(TELiveShowInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.liveStreamingAddress = rtmps[arc4random() % 7];
        }];
        self.lives = array;
        
        __weak TELiveShowMapController*  weakSelf = self;
        NSMutableArray* annotations = [[NSMutableArray alloc] initWithCapacity:30];
        [self.lives enumerateObjectsUsingBlock:^(TELiveShowInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TEAnnotation* annotation = [[TEAnnotation alloc] initWithCoordinate:obj.coordinate];
            annotation.title = @"Hello World";
            annotation.subtitle = @"Hello iOS";
            annotation.url = obj.liveStreamingAddress;
            //[weakSelf.mapView addAnnotation:annotation];
            [annotations addObject:annotation];
        }];
        
        [self.mapView addAnnotations:[annotations copy]];
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - *** MKMapViewDelegate ***

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PinAnnotation"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PinAnnotation"];
    }
    
    pinView.animatesDrop = YES;
    
    return pinView;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    TEAnnotation* annotation = (TEAnnotation*)view.annotation;
    [self performSegueWithIdentifier:@"te_push_video_player" sender:annotation];
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    NSLog(@"latitude = %lf, longitude = %lf",coordinate.latitude,coordinate.longitude);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"te_push_video_player"]) {
        TEVideoPlayerViewController* pvc = segue.destinationViewController;
        pvc.url = ((TEAnnotation*)sender).url;
    }
}


@end
