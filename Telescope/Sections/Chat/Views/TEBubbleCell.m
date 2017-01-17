//
//  TEBubbleCell.m
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEBubbleCell.h"
#import "TETextLayoutView.h"
#import "TEMessage+CoreDataProperties.h"
#import "TEMessageView.h"

@interface TEBubbleCell ()<TETextLayoutViewDelegate>

@property (nonatomic,strong) UIButton* headImageBtn;

@property (nonatomic,strong) UILabel* timeLabel;

@property (nonatomic,strong) TEMessageView* messageView;

@property (nonatomic,strong) UIActivityIndicatorView* indicator;

@property (nonatomic,strong) UIImageView* errorView;

@end

@implementation TEBubbleCell



- (UIButton*) headImageBtn
{
    if (!_headImageBtn) {
        _headImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 44, 44)];
        [_headImageBtn setImage:[UIImage imageNamed:@"te_user_head_img_2"] forState:UIControlStateNormal];
        [_headImageBtn setImage:[UIImage imageNamed:@"te_user_head_img_3"] forState:UIControlStateHighlighted];
    }
    return _headImageBtn;
}

- (UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
    }
    return _timeLabel;
}

- (TEMessageView*)messageView
{
    if (!_messageView) {
        _messageView = [[TEMessageView alloc] init];
        _messageView.layoutView.delegate = self;
    }
    return _messageView;
}

- (UIActivityIndicatorView*)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicator;
}

- (UIImageView*)errorView
{
    if (!_errorView) {
        _errorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"te_error_icon"]];
    }
    return _errorView;
}

#pragma mark - *** Init ***
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.messageView];
    [self.contentView addSubview:self.headImageBtn];
    [self.contentView addSubview:self.timeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //UIImage* image = [UIImage imageNamed:@"xxx"];
    //image resizableImageWithCapInsets:<#(UIEdgeInsets)#> resizingMode:<#(UIImageResizingMode)#>
}


#pragma mark - *** Api ***

- (void)setMessage:(TEMessage*)message;
{
    self.messageView.contentInset = message.layout.contentInset;
    self.messageView.frame = message.layout.contentFrame;//CGRectMake(self.headImageBtn.rightTop.x, 8, message.layout.contentFrame.size.width, message.layout.cellHeight);
    self.headImageBtn.frame = message.layout.avatarFrame;
    self.timeLabel.frame = message.layout.timeLabelFrame;
  
    self.timeLabel.text = message.chatMessage.timeLabelString;
    
    if (message.senderIsMe) {
        UIImage* image = [UIImage imageNamed:@"sendto_bubble_bg"];
        self.messageView.image =  [image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10) resizingMode:UIImageResizingModeStretch];
    }
    else{
        UIImage* image = [UIImage imageNamed:@"recv_bubble_bg"];
        self.messageView.image =  [image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22) resizingMode:UIImageResizingModeStretch];

    }
    
    if (TEMsgTransStateSending == message.state) {
        self.indicator.frame = message.layout.indicatorFrame;
        [self.contentView addSubview:self.indicator];
        [self.indicator startAnimating];
        [self.errorView removeFromSuperview];
    }
    else if (TEMsgTransStateError == message.state) {
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        self.errorView.frame = message.layout.indicatorFrame;
        [self.contentView addSubview:self.errorView];
    }
    else if(TEMsgTransStateSucced == message.state){
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        [self.errorView removeFromSuperview];
    }

    if(TEChatMessageTypeText == message.chatMessage.type ||
       TEChatMessageTypeRichText == message.chatMessage.type){
        [self.messageView.layoutView setLayoutModel:message.layout.layoutModel];
    }
    
}


#pragma mark - *** TETextLayoutViewDelegate ***
- (void)didSelectImageOfRect:(CGRect)rect inView:(UIView *)view
{
    CGRect rectInCell =  [self convertRect:rect fromView:view];
    NSLog(@"🍎🍎🍎🍎🍎 rectInCell = %@",NSStringFromCGRect(rectInCell));
    if ([self.delegate respondsToSelector:@selector(didSelectImageOfRect:inView:cell:)]) {
        [self.delegate didSelectImageOfRect:rect inView:view cell:self];
    }
}

- (void)didSelectLinkOfURL:(NSString *)url
{
    NSLog(@"url %@",url);
    if ([self.delegate respondsToSelector:@selector(didSelectLinkOfURL:)]) {
        [self.delegate didSelectLinkOfURL:url];
    }
}
@end
