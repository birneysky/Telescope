/*
 https://github.com/waynezxcv/Gallop

 Copyright (c) 2016 waynezxcv <liuweiself@126.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "LWImageBrowser.h"
#import "LWImageBrowserFlowLayout.h"
#import "LWImageBrowserCell.h"
#import "UIImage+ImageEffects.h"
#import "GallopUtils.h"
#import "GallopDefine.h"

#define kPageControlHeight 40.0f
#define kImageBrowserWidth ([UIScreen mainScreen].bounds.size.width + 10.0f)
#define kImageBrowserHeight [UIScreen mainScreen].bounds.size.height
#define kCellIdentifier @"LWImageBroserCellIdentifier"

@interface LWImageBrowser ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate,
UIAlertViewDelegate,
LWImageItemEventDelegate>

@property (nonatomic,strong) UIImageView* screenshotImageView;
@property (nonatomic,strong) UIImageView* blurImageView;

@property (nonatomic,strong) UIImage* screenshot;
@property (nonatomic,strong) UIImage* blurImage;

@property (nonatomic,strong) LWImageBrowserFlowLayout* flowLayout;
@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic,strong) UIPageControl* pageControl;
@property (nonatomic,weak) UIViewController* parentVC;
@property (nonatomic,assign,getter=isFirstShow) BOOL firstShow;
@end

@implementation LWImageBrowser

#pragma mark - ViewControllerLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.blurImageView];
    [self.view addSubview:self.screenshotImageView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
    //[self.view addSubview:self.button];
    [self.collectionView setContentOffset:CGPointMake(self.currentIndex * (SCREEN_WIDTH + 10.0f), 0.0f) animated:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.blurImageView.frame = SCREEN_BOUNDS;
    self.screenshotImageView.frame = SCREEN_BOUNDS;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2f animations:^{
        self.screenshotImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {

    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self _setCurrentItem];
    self.firstShow = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(imageBrowser:DidFinishSelectImageWithImages:)]) {
        NSMutableArray* tmp = [[NSMutableArray alloc] init];
        for (LWImageBrowserModel* model in self.imageModels) {
            UIImage* image = model.placeholder;
            [tmp addObject:image];
        }
        [self.delegate imageBrowser:self DidFinishSelectImageWithImages:tmp];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LWImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.imageItem.firstShow = self.isFirstShow;
    cell.imageModel = [self.imageModels objectAtIndex:indexPath.row];
    cell.imageItem.eventDelegate = self;
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset / SCREEN_WIDTH;
    self.currentIndex = index;
    self.pageControl.currentPage = self.currentIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self _setCurrentItem];
}

#pragma mark - LWImageItemDelegate

- (void)didClickedItemToHide {
    [self _hide];
}

- (void)didFinishRefreshThumbnailImageIfNeed {
    if ([self.delegate respondsToSelector:@selector(imageBrowserDidFnishDownloadImageToRefreshThumbnialImageIfNeed)]
        && [self.delegate conformsToProtocol:@protocol(LWImageBrowserDelegate)]) {
        [self.delegate imageBrowserDidFnishDownloadImageToRefreshThumbnialImageIfNeed];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            NSMutableArray* tmpArray = [[NSMutableArray alloc] initWithArray:[self.imageModels copy]];
            [tmpArray removeObjectAtIndex:self.currentIndex];
            self.imageModels = tmpArray;
            [self _setCurrentItem];
            [self.collectionView reloadData];
        }
            break;
        default:break;
    }
}

- (void)show {
    [self.parentVC presentViewController:self animated:NO completion:^{}];
}

- (void)_hide {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    __weak typeof(self) weakSelf = self;

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.currentImageItem.zoomScale != 1.0f) {
        self.currentImageItem.zoomScale = 1.0f;
    }

     [weakSelf dismissViewControllerAnimated:NO completion:^{
         weakSelf.imageModels = nil;
     }];
}

- (void)_hideNavigationBar {
    if (self.navigationController.navigationBarHidden == NO) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];

    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)_setCurrentItem {
    NSArray* cells = [self.collectionView visibleCells];
    if (cells.count != 0) {
        LWImageBrowserCell* cell = [cells objectAtIndex:0];
        if (self.currentImageItem != cell.imageItem) {
            self.currentImageItem = cell.imageItem;
            [self _preDownLoadImageWithIndex:self.currentIndex];
        }
    }
}

- (void)_preDownLoadImageWithIndex:(NSInteger)index {

}


#pragma mark - Save Photo

- (void)saveImageToPhotos:(UIImage*)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self,@selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    NSString* msg = @"";
    msg = @"图片已保存到本地";

}

#pragma mark - Setter & Getter

- (LWImageBrowserFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[LWImageBrowserFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             SCREEN_WIDTH + 10.0f,
                                                                             self.view.bounds.size.height)
                                             collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[LWImageBrowserCell class]
            forCellWithReuseIdentifier:kCellIdentifier];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f,
                                                                       SCREEN_HEIGHT - kPageControlHeight - 10.0f,
                                                                       SCREEN_WIDTH,
                                                                       kPageControlHeight)];
        _pageControl.numberOfPages = self.imageModels.count;
        _pageControl.currentPage = self.currentIndex;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIImageView *)screenshotImageView {
    if (_screenshotImageView) {
        return _screenshotImageView;
    }
    _screenshotImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _screenshotImageView.image = self.screenshot;
    return _screenshotImageView;
}

- (UIImageView *)blurImageView {
    if (_blurImageView) {
        return _blurImageView;
    }
    _blurImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _blurImageView.image = self.blurImage;
    return _blurImageView;
}

#pragma mark - Initialization

- (id)initWithParentViewController:(UIViewController *)parentVC
                       imageModels:(NSArray *)imageModels
                      currentIndex:(NSInteger)index {

    self  = [super init];
    if (self) {
        self.isScalingToHide = YES;
        self.parentVC = parentVC;
        self.imageModels = imageModels;
        self.currentIndex = index;
        self.screenshot = [self _screenshotFromView:[UIApplication sharedApplication].keyWindow];
        self.blurImage = [self.screenshot applyBlurWithRadius:20
                                                    tintColor:RGB(0, 0, 0, 0.5f)
                                        saturationDeltaFactor:1.4
                                                    maskImage:nil];
        self.firstShow = YES;
    }
    return self;
}

#pragma mark - Private
- (UIImage *)_screenshotFromView:(UIView *)aView {
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size,NO,[UIScreen mainScreen].scale);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}

@end
