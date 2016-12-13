//
//  ChatExtraPanel.m
//  WeChat
//
//  Created by zhangguang on 16/3/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TEChatMorePanel.h"

@interface TEChatMorePanel () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UIPageControl* pageControl;

@end

@implementation TEChatMorePanel
 
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TERGB(246, 246, 248);
        [self configureView];
    }
    return self;
}

#pragma mark - *** Properties ***
- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.pageControl.frame.size.height);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl*)pageControl
{
    if (!_pageControl) {
        CGRect frame = CGRectMake((self.frame.size.width - 50 )/2.0f, self.frame.size.height - 37, 50, 37);
        _pageControl = [[UIPageControl alloc] initWithFrame:frame];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return _pageControl;
}


#pragma mark - *** Configure view ***
- (void)configureView
{
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    CGFloat panelWidth = SCREENWIDTH;
    CGFloat panelHeight = self.height - self.pageControl.height;
    
    CGFloat buttonWidth = 50.0f;
    CGFloat buttonHeight = 50.0f;
    
    NSUInteger rowCount = 2;
    NSUInteger columnCount = 4;
    
    NSArray* titileArray = @[@"照片",@"拍摄",@"小视屏",@"视频聊天",@"红包",@"转账",@"位置",@"收藏",@"个人名片",@"语音输入"];
    NSArray* imageNameArray = @[@"te_sharemore_pic",@"te_sharemore_video",@"te_sharemore_sight",@"te_sharemore_videovoip",@"te_sharemore_wallet",@"te_sharemorePay",@"te_sharemore_location",@"te_sharemore_myfav",@"te_sharemore_friendcard",@"te_sharemore_voiceinput"];
    
    CGFloat horizontalSpace = (panelWidth - columnCount*buttonWidth) / (columnCount + 1);
    CGFloat verticalSpace = (panelHeight - rowCount*buttonHeight) / (rowCount + 1);
    NSInteger remainCount = titileArray.count % (rowCount * columnCount);
    NSUInteger pageCount = titileArray.count / (rowCount * columnCount);
    pageCount = remainCount > 0 ? pageCount + 1 : pageCount;
    self.pageControl.numberOfPages = pageCount;
    self.scrollView.contentSize = CGSizeMake(panelWidth * pageCount, panelHeight);
    
    for (NSUInteger i = 0; i < titileArray.count; i++) {
        NSUInteger pageIndex = i / (rowCount * columnCount);
        NSUInteger rowIndex = (i % (rowCount * columnCount)) / columnCount;
        NSUInteger columnIndex = i % columnCount;
        
        CGRect frame = CGRectMake(pageIndex * panelWidth + horizontalSpace * (columnIndex + 1) + buttonWidth * columnIndex, verticalSpace * (rowIndex + 1) + buttonHeight * rowIndex, buttonWidth, buttonHeight);
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"te_sharemore_other"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"te_sharemore_other_HL"] forState:UIControlStateHighlighted];
        [self.scrollView addSubview:button];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(button.x, button.y + buttonHeight + 5, button.width, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titileArray[i];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = TERGB(149, 149, 149);
        [self.scrollView addSubview:label];
        
        button.tag = i;
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    

}

#pragma mark - *** UIScrollViewDelegate  ***
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger pageIndex = scrollView.contentOffset.x / self.frame.size.width;
    self.pageControl.currentPage = pageIndex;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - *** Target Action ***
- (void)btnClicked:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectItemOfType:)]) {
        [self.delegate didSelectItemOfType:sender.tag];
    }
}


@end
