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

@interface TEMainViewController ()
@property (strong, nonatomic) IBOutlet TEDefaultCollectionController *userCollectionController;

@end

@implementation TEMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.userCollectionController registerWithNibName:@"TEDefaultCollectionCell"
                            forCellWithReuseIdentifier:@"te_default_collection_cell_id"];
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
