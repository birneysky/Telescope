//
//  TEChatViewController.m
//  Telescope
//
//  Created by zhangguang on 16/12/1.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEChatViewController.h"
#import "TEChatTableViewController.h"

#import "TEChatMorePanel.h"
#import "TEChatEmojiPanel.h"
#import "TEEmojiNamesManager.h"

#import "TEChatMessage.h"
#import "TEMsgSubItem.h"

#import "TECoreDataHelper.h"
#import "TEMessage+CoreDataProperties.h"
#import "TEChatSession+CoreDataProperties.h"
#import "TEMediaFileLocation+CoreDataProperties.h"

#import "CTAssetsPickerController.h"

#import <Photos/Photos.h>
#import "TESizeAspect.h"

#import <V2Kit/V2Kit.h>

#import "TEV2KitChatDemon.h"

#import "TEAudioRecordingHUD.h"


#import "TECoreDataHelper+Chat.h"


typedef NS_ENUM(NSUInteger,TEChatToolBarState){
    TEToolbarNormalState          = 0,
    TEToolbarAudioRecordState     = 1 << 0,
    TEToolbarEmojiPanelState = 1 << 1,
    TEToolbarExtraPanelState      = 1 << 2,
    TEToolbarInputTextState       = 1 << 3
};

#define TEToolbarMaxHeight 84

@interface TEChatViewController ()<TEChatEmojiPannelDelegate,TEChatMorePanelDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,AudioRecordingAndPlaybackDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *expressionBtn;
@property (weak, nonatomic) IBOutlet UIButton *pressTalkBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet TEChatTableViewController *chatTVC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (strong, nonatomic) IBOutlet TEAudioRecordingHUD *recordingHUD;
@property (nonatomic, strong) TEChatMorePanel* morePanel;
@property (nonatomic, strong) TEChatEmojiPanel* emojiPanel;
@property (nonatomic, assign) TEChatToolBarState toolbarState;

@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic,strong) NSMutableArray<TEChatMessage*>* cacheArray;
@property (nonatomic,strong) NSMutableArray<TEMessage*>* messageChache;

@property (nonatomic,strong) NSString* currentRecordingUUID;

@end

@implementation TEChatViewController

#pragma mark - *** Properties ***
- (TEChatMorePanel*)morePanel
{
    if (!_morePanel) {
        _morePanel = [[TEChatMorePanel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240)];
        _morePanel.delegate = self;
    }
    return _morePanel;
}

- (TEChatEmojiPanel*)emojiPanel
{
    if (!_emojiPanel) {
        _emojiPanel = [[TEChatEmojiPanel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240)];
        _emojiPanel.delegate = self;
    }
    return _emojiPanel;
}

- (void)setToolbarState:(TEChatToolBarState)toolbarState
{
    _toolbarState = toolbarState;
    [self resetToolbarState];
}

#pragma mark - *** ***
- (NSMutableArray<TEChatMessage*>*)cacheArray
{
    if (!_cacheArray) {
        _cacheArray = [[NSMutableArray alloc] init];
    }
    return _cacheArray;
}

- (NSMutableArray<TEMessage*>*)messageChache
{
    if (!_messageChache) {
        _messageChache = [[NSMutableArray alloc] init];
    }
    return _messageChache;
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.session) {
        
    }
    
    self.chatTVC.session = self.session;
    [self addChildViewController:self.chatTVC];
    [V2Kit defaultKit].recordingAndPlaybackDelegate = self;

    [self.view addSubview:self.morePanel];
    [self.view addSubview:self.emojiPanel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.recordingHUD.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
     NSLog(@"♻️♻️♻️♻️ TEChatViewController dealloc");
    [self.textView removeObserver:self forKeyPath:@"contentSize"];
    [self.chatTVC.timer invalidate];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"te_present_video_chat"]) {
        
    }
}

#pragma mark - *** target action ***
- (IBAction)moreBtnClicked:(id)sender {
    if (TEToolbarExtraPanelState == self.toolbarState) {
        [self.textView becomeFirstResponder];
        self.toolbarState = TEToolbarInputTextState;
    }
    else{
        [self.textView resignFirstResponder];
        self.toolbarState = TEToolbarExtraPanelState;
    }
}


- (IBAction)expressionBtnClicked:(id)sender {
    if (TEToolbarEmojiPanelState == self.toolbarState) {
        [self.textView becomeFirstResponder];
        self.toolbarState = TEToolbarInputTextState;
    }
    else{
        [self.textView resignFirstResponder];
        self.toolbarState = TEToolbarEmojiPanelState;
    }
}

- (IBAction)voiceBtnClicked:(id)sender {
    if (TEToolbarAudioRecordState == self.toolbarState) {
        [self.textView becomeFirstResponder];
        self.toolbarState = TEToolbarInputTextState;
    }
    else{
        [self.textView resignFirstResponder];
        self.toolbarState = TEToolbarAudioRecordState;
    }
}

- (IBAction)pressTalkBtnTouchDown:(UIButton*)sender {
    [sender setTitle:@"松开结束" forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor lightGrayColor]];
    NSLog(@"pressTalkBtnTouchDown");
    self.recordingHUD.state = TEAudioRecordingStateRecording;
    [self.view addSubview:self.recordingHUD];
    
    self.currentRecordingUUID = [NSString UUID];
    
    [[V2Kit defaultKit] startAudioRecording:self.currentRecordingUUID];
}
- (IBAction)pressTalkBtnTouchUpInside:(id)sender {
    NSLog(@"pressTalkBtnTouchUpInside");
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setTitle:@"按住说话" forState:UIControlStateNormal];
    //发送消息
    [self.recordingHUD removeFromSuperview];
    [[V2Kit defaultKit] stopAudioRecording:self.currentRecordingUUID];
}

- (IBAction)pressTalkBtnTouchUpOutSide:(id)sender {
    NSLog(@"pressTalkBtnTouchUpOutSide");
     [sender setBackgroundColor:[UIColor whiteColor]];
     [sender setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.recordingHUD removeFromSuperview];
    //取消发送
}

- (IBAction)pressTalkBtnTouchDragOutSide:(id)sender {
    NSLog(@"pressTalkBtnTouchDragOutSide");
    self.recordingHUD.state = TEAudioRecordingStateMyBeCancel;
     [sender setTitle:@"松开手指，取消发送" forState:UIControlStateNormal];
}
- (IBAction)pressTalkTouchDragInside:(UIButton *)sender {
    [sender setTitle:@"松开结束" forState:UIControlStateNormal];
     self.recordingHUD.state = TEAudioRecordingStateRecording;
}

#pragma mark - *** notification selector ***
- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardRect;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    self.keyboardHeight = keyboardRect.size.height;
    self.toolbarState = TEToolbarInputTextState;
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    
}

#pragma mark - *** Helper ***
- (void)resetToolbarState
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:7];
    switch (self.toolbarState) {
        case TEToolbarNormalState:
            self.toolbarBottomConstraint.constant = 0 ;
            //self.tableViewBottomConstraint.constant = 0;
            self.morePanel.y = SCREENHEIGHT;
            self.emojiPanel.y = SCREENHEIGHT;
            break;
        case TEToolbarAudioRecordState:
            self.toolbarBottomConstraint.constant = 0 ;
            self.tableViewBottomConstraint.constant = 0;
            self.morePanel.y = SCREENHEIGHT;
            self.emojiPanel.y = SCREENHEIGHT;
            break;
        case TEToolbarEmojiPanelState:
            self.emojiPanel.y = SCREENHEIGHT - self.emojiPanel.height;
            self.toolbarBottomConstraint.constant = self.emojiPanel.height;
           // self.tableViewBottomConstraint.constant = self.expressionPanel.height;
            self.morePanel.y = SCREENHEIGHT;
            break;
        case TEToolbarExtraPanelState:
            self.morePanel.y = SCREENHEIGHT - self.morePanel.height;
            self.toolbarBottomConstraint.constant = self.morePanel.height;
            //self.tableViewBottomConstraint.constant = self.morePanel.height;
            self.emojiPanel.y = SCREENHEIGHT;
            break;
        case TEToolbarInputTextState:
            self.toolbarBottomConstraint.constant = self.keyboardHeight ;
           // self.tableViewBottomConstraint.constant = self.keyboardHeight;
            self.morePanel.y = SCREENHEIGHT;
            self.emojiPanel.y = SCREENHEIGHT;
            break;
        default:
            break;
    }
    self.tableViewBottomConstraint.constant = self.toolbarBottomConstraint.constant;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    
    if (TEToolbarAudioRecordState == self.toolbarState) {
        [self.voiceBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_keyboard"] forState:UIControlStateNormal];
        [self.voiceBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_more_hl"] forState:UIControlStateHighlighted];
        self.pressTalkBtn.hidden = NO;
        self.textView.hidden = YES;
        
    }
    else{
        [self.voiceBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_input_voice"] forState:UIControlStateNormal];
        [self.voiceBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_input_voice_hl"] forState:UIControlStateHighlighted];
        self.pressTalkBtn.hidden = YES;
        self.textView.hidden = NO;
        
    }
    
    if (TEToolbarEmojiPanelState == self.toolbarState ) {
        [self.expressionBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_keyboard"] forState:UIControlStateNormal];
        [self.expressionBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_keyboard_hl"] forState:UIControlStateHighlighted];
    }
    else{
        [self.expressionBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_emotion"] forState:UIControlStateNormal];
        [self.expressionBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_emotion_hl"] forState:UIControlStateHighlighted];
    }

}


/**
 构建新的文本消息对象

 @return 返回消息对象
 */
- (TEChatMessage*)buildNewTextMessage
{
    /*
     匹配带方括号的汉字
     [[\u4e00-\u9fa5]+]
     匹配方括号中包含英文和数字
     [[a-zA-Z0-9]+]
     匹配不带http://的网址
     [a-zA-Z0-9\\.\\-]+\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?
     带http的网址
     (http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?
     */
    NSString* pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]|((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,3})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression* regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString* sendText = self.textView.text;
    NSArray<NSTextCheckingResult*>* result = [regularExpression matchesInString:sendText options:NSMatchingWithTransparentBounds range:NSMakeRange(0, sendText.length)];
    
    TEChatMessage* chatMessage = [TEChatMessage buildTextMessage];
    
    if (result.count<=0) {
        TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
        textItem.textContent = sendText;
        [chatMessage addItem:textItem];
    }
    
    __block NSUInteger location = 0;
    [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.range;
        if (range.location > location) {
            //大于 说明range.location前面还有文本没有处理
            NSString* subText = [sendText substringWithRange:NSMakeRange(location, range.location - location)];
            TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
            textItem.textContent = subText;
            [chatMessage addItem:textItem];
        }
        location = NSMaxRange(range);
        NSLog(@"range %@:%@",NSStringFromRange(range),[sendText substringWithRange:range]);
        NSString* subText = [sendText substringWithRange:range];
        if ([subText characterAtIndex:0] == '[') {
            TEExpresssionSubItem* expressionItem = [[TEExpresssionSubItem alloc] initWithType:Face];
            NSString* fileName = [[TEEmojiNamesManager defaultManager] indexOfName:subText];
            assert(fileName);
            expressionItem.fileName = [[TEEmojiNamesManager defaultManager] indexOfName:subText];
            [chatMessage addItem:expressionItem];
        }
        else{
            TEMsgLinkSubItem* linkItem = [[TEMsgLinkSubItem alloc] initWithType:Link];
            linkItem.title = subText;
            linkItem.url = subText;
            [chatMessage addItem:linkItem];
        }
    }];
    
    if(location < sendText.length && location > 0){
        TEMsgTextSubItem* textItem = [[TEMsgTextSubItem alloc] initWithType:Text];
        textItem.textContent = [sendText substringWithRange:(NSRange){location,sendText.length - location}];
        [chatMessage addItem:textItem];
    }
    
    
    NSAssert(regularExpression,@"正则%@有误",pattern);

    return chatMessage;
}

- (TEChatMessage*)buildNewAudioMessage
{
    TEChatMessage* chatMessage = [TEChatMessage buildAudioMessage];

    TEMSgAudioSubItem* audioItem = [[TEMSgAudioSubItem alloc] initWithType:Audio];
    audioItem.duration = 0.5;
    audioItem.fileExt = @".mp3";
    audioItem.fileName = @"";
    [chatMessage addItem:audioItem];
    
    return chatMessage;
}


/**
 存储消息对象
 
 @param chatMessages 消息对象数组
 */
- (void)storeMessage:(NSArray<TEChatMessage*>*)chatMessages
{
    int64_t senderID = [TEV2KitChatDemon defaultDemon].selfUser.userID;
    [[TECoreDataHelper defaultHelper]
        insertNewMessages:chatMessages
                 senderID:senderID
              chatSession:self.session
               completion:nil ];
}

/**
 发送消息对象

 @param chatMessages 消息对象数组
 */
- (void)sendMessages:(NSArray<TEChatMessage*>*)chatMessages
{
    [chatMessages enumerateObjectsUsingBlock:^(TEChatMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        [[V2Kit defaultKit] sendTextMessage:[message xmlString]
                                   toUserID:self.session.remoteUsrID
                                    inGroup:0
                                  messageID:message.messageID];
        [message.msgItemList enumerateObjectsUsingBlock:^(TEMsgSubItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if (Image ==  item.type) {
                TEMsgImageSubItem* imageItem = (TEMsgImageSubItem*)item;
                NSString* filePath = [[TEV2KitChatDemon defaultDemon].pictureStorePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",imageItem.fileName,imageItem.fileExt]];
                [[V2Kit defaultKit] sendMediaFileMessage:filePath
                                                toUserID:self.session.remoteUsrID
                                                 inGroup:0
                                                    type:MediaFileTypePicture
                                               messageID:message.messageID];
            }
        }];
    }];
}

#pragma mark - *** KVO ***
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        //NSLog(@"textVewContentSize %@",NSStringFromCGSize(self.textView.contentSize));
        CGFloat contentHeight = self.textView.contentSize.height;
        CGFloat constantValue = 0;
        if (contentHeight > 34 && contentHeight <= TEToolbarMaxHeight) {
            constantValue = contentHeight + 16;
        }
        else if(contentHeight <= 34){
            constantValue = 50;
        }
        else{
            return;
        }
       
        [UIView  animateWithDuration:0.3 animations:^{
            self.toolbarHeightConstraint.constant = constantValue;
            self.chatTVC.tableView.contentInset = UIEdgeInsetsMake(64, 0, constantValue, 0);
            [self.toolbar layoutIfNeeded];
            [self.view layoutIfNeeded];
        }];
    }
}


#pragma mark - *** TextViewDelegate ***
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.textView.text.length > 0) {
            TEChatMessage* message =  [self buildNewTextMessage];
            [self storeMessage:@[message]];
            [self sendMessages:@[message]];
            self.textView.text = nil;
        }
        return NO;
    }
    return YES;
}


#pragma mark - ***TEChatExpressionPannelDelegate ***
- (void)factButtonClickedAtIndex:(NSUInteger)index
{
    TEEmojiNamesManager* manager = [TEEmojiNamesManager defaultManager];
    
    NSString* expresssionName =  [manager nameAtIndex:index];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"[%@]",expresssionName];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
}

- (void)sendButtonClickedInPannnel
{
    if (self.textView.text.length <= 0) {
        return;
    }
    TEChatMessage* message =  [self buildNewTextMessage];
    [self storeMessage:@[message]];
    [self sendMessages:@[message]];
    self.textView.text = nil;
}

#pragma mark - *** TEChatMorePanelDelegate ***
- (void)didSelectItemOfType:(TEMorePanelBizType)type
{
    switch (type) {
        case Photo:
        {
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.assetsFilter         = [ALAssetsFilter allPhotos];
            picker.showsCancelButton    = YES;
            picker.delegate             = self;
            picker.selectedAssets       = [[NSMutableArray alloc] initWithCapacity:0];
            
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case VideoChat:
        {
            [self performSegueWithIdentifier:@"te_present_video_chat" sender:nil];
            //te_present_video_chat
        }
        default:
            break;
    }
}

#pragma mark - *** CTAssetsPickerControllerDelegate ***
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSString* pictureStorePath = [TEV2KitChatDemon defaultDemon].pictureStorePath;
    [picker dismissViewControllerAnimated:YES completion:^{
        //NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TEImages"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:pictureStorePath])
        {
            [[NSFileManager defaultManager]  createDirectoryAtPath:pictureStorePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSMutableArray<TEChatMessage*>* array = [[NSMutableArray alloc] init];
        for (ALAsset * asset in assets)
        {
            NSString* fileName = [NSString UUID];
            
            CGImageRef fullImg = [[asset defaultRepresentation] fullScreenImage];
            CGFloat fullWidth = CGImageGetWidth(fullImg);
            CGFloat fullHeight = CGImageGetHeight(fullImg);
            
            CGImageRef thumbnailAspectImg = asset.aspectRatioThumbnail;
            CGFloat thumbnailAspectWidth = CGImageGetWidth(thumbnailAspectImg);
            CGFloat thumbnailAspectHeight = CGImageGetHeight(thumbnailAspectImg);
            aspectSizeInContainer(&thumbnailAspectWidth, &thumbnailAspectHeight, CGSizeMake(40, 40), CGSizeMake(200, 200));
            
            //生成压缩图片
            CGSize imageSize = CGSizeMake(thumbnailAspectWidth, thumbnailAspectHeight);
            UIGraphicsBeginImageContext(imageSize);
            UIImage* thumbnailImage = [UIImage imageWithCGImage:thumbnailAspectImg];
            [thumbnailImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
            UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //缩略图写入文件
            NSData* thumbnailJPGData = UIImageJPEGRepresentation(resultImage, 1);
            NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",fileName,@"thumbnail"];
            NSString* thumbnailImgPath = [pictureStorePath stringByAppendingPathComponent:fileThumbnailName];
            [thumbnailJPGData writeToFile:thumbnailImgPath atomically:YES];
            
            //原始图片写入文件
            NSData* fullJPGData = UIImageJPEGRepresentation([UIImage imageWithCGImage:fullImg], 1);
            NSString* fileFullImageName = [NSString stringWithFormat:@"%@.jpg",fileName];
            NSString* fullImagePath = [pictureStorePath stringByAppendingPathComponent:fileFullImageName];
            [fullJPGData writeToFile:fullImagePath atomically:YES];
            
            //生成消息实例
            TEMsgImageSubItem* imageItem = [[TEMsgImageSubItem alloc] initWithType:Image];
            imageItem.path = pictureStorePath;
            imageItem.fileName = fileName;
            imageItem.fileExt = @".jpg";
            imageItem.frame = CGRectMake(0, 0, fullWidth, fullHeight);
            
            TEChatMessage* chatMessage = [TEChatMessage buildTextMessage];
            [chatMessage addItem:imageItem];
            
            
            [array addObject:chatMessage];
        }
        
        //存储发送消息
        NSArray* messages = [array copy];
        [self storeMessage:messages];
        [self sendMessages:messages];
    }];
}

#pragma mark - *** AudioRecordingAndPlaybackDelegate ***

- (void)reportMicrophoneInputVolume:(NSInteger)value
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordingHUD setAudioVolume:value];
    });
}


- (void)didStartRecordFile:(NSString*)name errorCode:(NSInteger)code
{
    
}


- (void)didStopRecordFileSequence:(NSString*)sID path:(NSString*)path errorCode:(NSInteger)code
{
    
}


- (void)didStartPlayFile:(NSString*)name errorCode:(NSInteger)code
{
    
}


- (void)didStopPlayFile:(NSString*)name errorCode:(NSInteger)code
{
    
}

@end
