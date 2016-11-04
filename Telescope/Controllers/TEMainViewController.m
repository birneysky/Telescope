//
//  MainViewController.m
//  Telescope
//
//  Created by zhangguang on 16/10/28.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEMainViewController.h"
#import "TEDefaultCollectionController.h"
#import "TEDefaultCollectionCell.h"
#import <MapKit/MapKit.h>

#import "TENetworkKit.h"

@interface TEMainViewController ()
@property (strong, nonatomic) IBOutlet TEDefaultCollectionController *userCollectionController;
@property (nonatomic, strong) NSArray<TELiveShowInfo*>* lives;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation TEMainViewController

- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ TEMainViewController ~ %@ ",self);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.userCollectionController registerWithNibName:@"TEDefaultCollectionCell"
                            forCellWithReuseIdentifier:@"te_default_collection_cell_id"];
    
    /*
     rtmp://203.207.99.19:1935/live/CCTV5   体育频道
     rtmp://203.207.99.19:1935/live/CCTV1
     rtmp://203.207.99.19:1935/live/CCTV2
     rtmp://203.207.99.19:1935/live/CCTV4
     rtmp://203.207.99.19:1935/live/CCTV7
     rtmp://203.207.99.19:1935/live/CCTV10
     rtmp://203.207.99.19:1935/live/CCTV12
     rtmp://live.hkstv.hk.lxdns.com/live/hks 香港卫视
     rtmp://203.207.99.19:1935/live/zgjyt  湖南卫视
     rtmp://124.128.26.173/live/jnyd_sd  济南卫视
     */
    NSArray<NSString*>* rtmps = @[@"rtmp://203.207.99.19:1935/live/zgjyt",@"rtmp://203.207.99.19:1935/live/CCTV1",@"",@"rtmp://203.207.99.19:1935/live/CCTV2",@"rtmp://203.207.99.19:1935/live/CCTV4",@"rtmp://203.207.99.19:1935/live/CCTV7",@"rtmp://203.207.99.19:1935/live/CCTV10",@"rtmp://203.207.99.19:1935/live/CCTV12",@"rtmp://203.207.99.19:1935/live/CCTV5"];
    [TENETWORKKIT fetchLiveShowListWithCompletion:^(TEResponse<NSArray<TELiveShowInfo *> *> *response) {
        NSArray<TELiveShowInfo*>* array = response.body;
        [array enumerateObjectsUsingBlock:^(TELiveShowInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.liveStreamingAddress = rtmps[idx];
        }];
        self.lives = array;
    } onError:^(NSError *error) {
        
    }];
}

#pragma mark - *** Target Action ****
- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
