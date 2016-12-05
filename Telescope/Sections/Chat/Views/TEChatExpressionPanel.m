//
//  ChatExpressionPanel.m
//  WeChat
//
//  Created by zhangguang on 16/3/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TEChatExpressionPanel.h"


@interface TEChatExpressionPanel () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;

@property (nonatomic,strong) UIPageControl* pageControl;

@end

@implementation TEChatExpressionPanel

#pragma mark - *** Properties ***
- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - self.pageControl.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl*) pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.width - 50) / 2.0f, self.height - 37, 50, 37)];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

#pragma mark - *** Init ***
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TERGB(246, 246, 248);
        [self configureView];
    }
    return self;
}



#pragma mark - *** Helper ***
- (void)configureView
{
    [self addSubview:self.pageControl];
    [self addSubview:self.scrollView];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"TEExpressionNames" ofType:@"plist"];
    NSArray*  expressionStringArray = [NSArray arrayWithContentsOfFile:filePath];
    
    CGFloat panelWith = self.width;
    CGFloat panelHeight = self.height - self.pageControl.height;
    
    CGFloat expressionWidth = 44.0f;
    CGFloat expressionHeight = 44.0f;
    
    NSUInteger rowCount = panelHeight / (expressionHeight );
    NSUInteger columnCount = panelWith / (expressionWidth );
    
    NSUInteger numberPerPage = rowCount * columnCount;
    
    NSUInteger remainCount = expressionStringArray.count % (rowCount * columnCount);
    NSUInteger pageCount = expressionStringArray.count / (rowCount * columnCount);
    pageCount = remainCount > 0 ? pageCount + 1 : pageCount;
    
    self.scrollView.contentSize = CGSizeMake(pageCount * panelWith, panelHeight);
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    
    NSString* expressionBundlePath = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
    
    for (NSUInteger i = 0; i < expressionStringArray.count; i++) {
        NSUInteger pageIndex = i / numberPerPage;
        NSUInteger rowIndex = (i%numberPerPage) / columnCount;
        NSUInteger columnIndex = i % columnCount;
        
        CGRect frame = CGRectMake(pageIndex * panelWith + columnIndex * expressionWidth + 8, rowIndex * expressionHeight + 4, expressionWidth, expressionHeight);
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        NSString* imageName = [NSString stringWithFormat:@"Expression_%lu",i+1];
        NSString* imagePathName = [expressionBundlePath stringByAppendingPathComponent:imageName];
        [button setImage:[UIImage imageNamed:imagePathName] forState:UIControlStateNormal];
        [self.scrollView addSubview:button];
    }

}


#pragma mark - *** UIScrollViewDelegate ***

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger pageIndex = scrollView.contentOffset.x / self.width;
    self.pageControl.currentPage = pageIndex;
}

@end
