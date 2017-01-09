//
//  ChatExpressionPanel.m
//  WeChat
//
//  Created by zhangguang on 16/3/21.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "TEChatEmojiPanel.h"
#import "TEEmojiButton.h"
#import "TEEmojiPreview.h"
#import "TEEmojiNamesManager.h"

@interface TEChatEmojiPanel () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;

@property (nonatomic,strong) UIPageControl* pageControl;

@property (nonatomic,strong) TEEmojiPreview* emojiPreview;

@end

@implementation TEChatEmojiPanel

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


- (TEEmojiPreview*)emojiPreview
{
    if (!_emojiPreview) {
        _emojiPreview = [TEEmojiPreview  emojiPreview];
    }
    return _emojiPreview;
}

#pragma mark - *** Init ***
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = TERGB(246, 246, 248);
        [self configureView];
        UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
        [self.scrollView addGestureRecognizer:longPressGesture];
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
    
    CGFloat expressionWidth = 48.0f;
    CGFloat expressionHeight = 48.0f;
    
    NSUInteger rowCount = panelHeight / (expressionHeight );
    NSUInteger columnCount = panelWith / (expressionWidth );
    
    NSUInteger numberPerPage = rowCount * columnCount;
    
    NSUInteger remainCount = expressionStringArray.count % (rowCount * columnCount);
    NSUInteger pageCount = expressionStringArray.count / (rowCount * columnCount);
    pageCount = remainCount > 0 ? pageCount + 1 : pageCount;
    
    self.scrollView.contentSize = CGSizeMake(pageCount * panelWith, panelHeight);
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    
    
    CGFloat xOffset = (self.width - columnCount * expressionWidth) / 2;
    CGFloat yOffset = (panelHeight - rowCount * expressionHeight) / 2;
    
    NSString* expressionBundlePath = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
    
    for (NSUInteger i = 0; i < expressionStringArray.count; i++) {
        NSUInteger pageIndex = i / numberPerPage;
        NSUInteger rowIndex = (i%numberPerPage) / columnCount;
        NSUInteger columnIndex = i % columnCount;
        
        CGRect frame = CGRectMake(pageIndex * panelWith + columnIndex * expressionWidth + xOffset, rowIndex * expressionHeight + yOffset, expressionWidth, expressionHeight);
        TEEmojiButton* button = [TEEmojiButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        NSString* imageName = [NSString stringWithFormat:@"Expression_%lu",i];
        NSString* imagePathName = [expressionBundlePath stringByAppendingPathComponent:imageName];
        button.tag = i;
        [button setImage:[UIImage imageNamed:imagePathName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(faceClicked:) forControlEvents:UIControlEventTouchUpInside];
        //button.imageView.contentMode = UIViewContentModeScaleToFill;
        //button.contentEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        [self.scrollView addSubview:button];

    }

    UIButton* sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 80, self.height - 30, 80, 30)];
    sendButton.backgroundColor = TERGB(23, 126, 253);
//    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
}

#pragma mark - ***Helper***
- (UIButton*)enumButtonWithLocation:(CGPoint)point
{
    NSArray<UIButton*>* emojiButtons = self.scrollView.subviews;
    __block UIButton* touchButton = nil;
    [emojiButtons  enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            touchButton = obj;
            *stop = YES;
        }
    }];
    return touchButton;
}

#pragma mark - *** UIScrollViewDelegate ***

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger pageIndex = scrollView.contentOffset.x / self.width;
    self.pageControl.currentPage = pageIndex;
}


#pragma mark - *** Target Action ***

- (void)faceClicked:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(factButtonClickedAtIndex:)]) {
        [self.delegate factButtonClickedAtIndex:sender.tag];
    }
}

- (void)sendBtnClicked:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(sendButtonClickedInPannnel)]) {
        [self.delegate sendButtonClickedInPannnel];
    }
}

#pragma mark - *** longPressView ***
- (void)longPressView:(UILongPressGestureRecognizer*)gesture
{
   CGPoint touchPoint = [gesture locationInView:self.scrollView];
    UIButton* touchButton = [self enumButtonWithLocation:touchPoint];
    NSLog(@"gesture state %ld",(long)gesture.state);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            if (touchButton) {
                TEEmojiNamesManager* emojiManager = [TEEmojiNamesManager defaultManager];
                [self.emojiPreview setPreviewImage:touchButton.currentImage];
                [self.emojiPreview setEmojiName:[emojiManager nameAtIndex:touchButton.tag]];
            }
            [self.emojiPreview showFromView:touchButton];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            [self.emojiPreview removeFromSuperview];
            break;
        default:
            break;
    }
}

@end
