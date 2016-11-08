//
//  TEWebViewController.m
//  Telescope
//
//  Created by zhangguang on 16/10/31.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEWebViewController.h"

@interface TEWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation TEWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL* url = [NSURL URLWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.linkTitle;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
