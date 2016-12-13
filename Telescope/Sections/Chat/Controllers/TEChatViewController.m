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
#import "TEChatExpressionPanel.h"
#import "TEExpressionNamesManager.h"

#import "TEChatMessage.h"
#import "TEMsgSubItem.h"

#import "TECoreDataHelper.h"
#import "TEMessage+CoreDataProperties.h"
#import "TEChatSession+CoreDataProperties.h"

#import "CTAssetsPickerController.h"

#import <Photos/Photos.h>
#import "TESizeAspect.h"

typedef NS_ENUM(NSUInteger,TEChatToolBarState){
    TEToolbarNormalState          = 0,
    TEToolbarAudioRecordState     = 1 << 0,
    TEToolbarExpressionPanelState = 1 << 1,
    TEToolbarExtraPanelState      = 1 << 2,
    TEToolbarInputTextState       = 1 << 3
};

#define TEToolbarMaxHeight 100

@interface TEChatViewController ()<TEChatExpressionPannelDelegate,TEChatMorePanelDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate>
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
@property (nonatomic, strong) TEChatMorePanel* morePanel;
@property (nonatomic, strong) TEChatExpressionPanel* expressionPanel;
@property (nonatomic, assign) TEChatToolBarState toolbarState;

@property (nonatomic, assign) CGFloat keyboardHeight;

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

- (TEChatExpressionPanel*)expressionPanel
{
    if (!_expressionPanel) {
        _expressionPanel = [[TEChatExpressionPanel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240)];
        _expressionPanel.delegate = self;
    }
    return _expressionPanel;
}

- (void)setToolbarState:(TEChatToolBarState)toolbarState
{
    _toolbarState = toolbarState;
    [self resetToolbarState];
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.chatTVC.session = self.session;
    [self addChildViewController:self.chatTVC];

    [self.view addSubview:self.morePanel];
    [self.view addSubview:self.expressionPanel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    if (TEToolbarExpressionPanelState == self.toolbarState) {
        [self.textView becomeFirstResponder];
        self.toolbarState = TEToolbarInputTextState;
    }
    else{
        [self.textView resignFirstResponder];
        self.toolbarState = TEToolbarExpressionPanelState;
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
            self.expressionPanel.y = SCREENHEIGHT;
            break;
        case TEToolbarAudioRecordState:
            self.toolbarBottomConstraint.constant = 0 ;
            self.tableViewBottomConstraint.constant = 0;
            self.morePanel.y = SCREENHEIGHT;
            self.expressionPanel.y = SCREENHEIGHT;
            break;
        case TEToolbarExpressionPanelState:
            self.expressionPanel.y = SCREENHEIGHT - self.expressionPanel.height;
            self.toolbarBottomConstraint.constant = self.expressionPanel.height;
           // self.tableViewBottomConstraint.constant = self.expressionPanel.height;
            self.morePanel.y = SCREENHEIGHT;
            break;
        case TEToolbarExtraPanelState:
            self.morePanel.y = SCREENHEIGHT - self.morePanel.height;
            self.toolbarBottomConstraint.constant = self.morePanel.height;
            //self.tableViewBottomConstraint.constant = self.morePanel.height;
            self.expressionPanel.y = SCREENHEIGHT;
            break;
        case TEToolbarInputTextState:
            self.toolbarBottomConstraint.constant = self.keyboardHeight ;
           // self.tableViewBottomConstraint.constant = self.keyboardHeight;
            self.morePanel.y = SCREENHEIGHT;
            self.expressionPanel.y = SCREENHEIGHT;
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
    
    if (TEToolbarExpressionPanelState == self.toolbarState ) {
        [self.expressionBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_keyboard"] forState:UIControlStateNormal];
        [self.expressionBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_keyboard_hl"] forState:UIControlStateHighlighted];
    }
    else{
        [self.expressionBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_emotion"] forState:UIControlStateNormal];
        [self.expressionBtn setImage:[UIImage imageNamed:@"te_chat_toolbar_emotion_hl"] forState:UIControlStateHighlighted];
    }

}


- (void)sendMessage
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
    
//    NSString* text = @"http://www.baidu.comfjdkalfjdlsafjldsk[抓狂][调皮][大哭][尴尬][难过][酷],https:www.apple.com,fjdlafjdls https://www.baidu.com www.baidu.com [难过][酷] wolegequfdjlafcjdas ,,,fjdksajfdsa, [抓狂][调皮][大哭]fjdkSafjsda www.baidu.com,[尴尬][难过][酷] developer.apple.com,www.baidu.com http://www.baidu.com http://tool.oschina.net/regex/#";//self.textView.text;
    NSString* sendText = self.textView.text;
    NSArray<NSTextCheckingResult*>* result = [regularExpression matchesInString:sendText options:NSMatchingWithTransparentBounds range:NSMakeRange(0, sendText.length)];
    
    TEChatMessage* chatMessage = [[TEChatMessage alloc] init];
    chatMessage.messageID = [NSString UUID];
    chatMessage.isAutoReply = NO;
    
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
            NSString* fileName = [[TEExpressionNamesManager defaultManager] indexOfName:subText];
            assert(fileName);
            expressionItem.fileName = [[TEExpressionNamesManager defaultManager] indexOfName:subText];
            [chatMessage addItem:expressionItem];
        }
        else{
            TEMsgLinkSubItem* linkItem = [[TEMsgLinkSubItem alloc] initWithType:Link];
            linkItem.title = subText;
            linkItem.url = subText;
            [chatMessage addItem:linkItem];
        }
    }];

    NSAssert(regularExpression,@"正则%@有误",pattern);
    [self insertNewMessage:chatMessage];
    //    __weak NSManagedObjectContext* context = [[TECoreDataHelper defaultHelper] backgroundContext];
//    [context performBlock:^{
//        TEMessage* message =  [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:context];
//        message.mID = [NSString UUID];
//        message.senderID = 100001;
//        message.receiverID = self.session.senderID;
//        message.content = [chatMessage xmlString];
//        message.sendTime = [NSDate date];
//        message.type = 1;
//        message.sessionID = self.session.sID;
//        message.senderIsMe = YES;
//        
//        self.session.totalNumOfMessage += 1;
//        
//        if ([context hasChanges]) {
//            NSError* error;
//            [context save:&error];
//        }
//        [message layout];
//    }];
    
}

- (void)insertNewMessage:(TEChatMessage*)chatMessage
{
    __weak NSManagedObjectContext* context = [[TECoreDataHelper defaultHelper] backgroundContext];
    [context performBlock:^{
        TEMessage* message =  [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:context];
        message.mID = chatMessage.messageID;
        message.senderID = 100001;
        message.receiverID = self.session.senderID;
        message.content = [chatMessage xmlString];
        message.sendTime = [NSDate date];
        message.type = 1;
        message.sessionID = self.session.sID;
        message.senderIsMe = YES;
        
        self.session.totalNumOfMessage += 1;
        
        [message layout];
        
        if ([context hasChanges]) {
            NSError* error;
            [context save:&error];
        }
        
    }];
}

#pragma mark - *** KVO ***
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        //NSLog(@"textVewContentSize %@",NSStringFromCGSize(self.textView.contentSize));
        CGFloat totalHeight = self.textView.contentSize.height + 16;
        if (totalHeight > 50 && totalHeight <= TEToolbarMaxHeight) {
            self.toolbarHeightConstraint.constant = totalHeight;
        }
        else if(totalHeight <= 50){
            self.toolbarHeightConstraint.constant = 50;
        }
        else{
            return;
        }
        [self.toolbar setNeedsUpdateConstraints];
    }
}


#pragma mark - *** TextViewDelegate ***
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        self.textView.text = nil;
        return NO;
    }
    return YES;
}


#pragma mark - ***TEChatExpressionPannelDelegate ***
- (void)factButtonClickedAtIndex:(NSUInteger)index
{
    TEExpressionNamesManager* manager = [TEExpressionNamesManager defaultManager];
    
    NSString* expresssionName =  [manager nameAtIndex:index];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"[%@]",expresssionName];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
}

- (void)sendButtonClickedInPannnel
{
    if (self.textView.text.length <= 0) {
        return;
    }
    [self sendMessage];
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
            
        default:
            break;
    }
}

#pragma mark - *** CTAssetsPickerControllerDelegate ***
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TEImages"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager]  createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    
    for (ALAsset * asset in assets)
    {
        NSString* fileName = [NSString UUID];
        CGImageRef fullImg = [[asset defaultRepresentation] fullScreenImage];
        CGFloat fullWidth = CGImageGetWidth(fullImg);
        CGFloat fullHeight = CGImageGetHeight(fullImg);

        //        CGImageRef thumbnailImg = asset.thumbnail;
        //        CGFloat thumbnailWidth = CGImageGetWidth(thumbnailImg);
        //        CGFloat thumbnailHeight = CGImageGetHeight(thumbnailImg);
       
        CGImageRef thumbnailAspectImg = asset.aspectRatioThumbnail;
        CGFloat thumbnailAspectWidth = CGImageGetWidth(thumbnailAspectImg);
        CGFloat thumbnailAspectHeight = CGImageGetHeight(thumbnailAspectImg);
        aspectSizeInContainer(&thumbnailAspectWidth, &thumbnailAspectHeight, CGSizeMake(40, 40), CGSizeMake(200, 200));

        CGSize imageSize = CGSizeMake(thumbnailAspectWidth, thumbnailAspectHeight);
        UIGraphicsBeginImageContext(imageSize);
        UIImage* thumbnailImage = [UIImage imageWithCGImage:thumbnailAspectImg];
        [thumbnailImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //缩略图写入文件
        NSData* thumbnailJPGData = UIImageJPEGRepresentation(resultImage, 1);
        NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",fileName,@"thumbnail"];
        NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];
        [thumbnailJPGData writeToFile:thumbnailImgPath atomically:YES];
    
        //原始图片写入文件
        NSData* fullJPGData = UIImageJPEGRepresentation([UIImage imageWithCGImage:fullImg], 1);
        NSString* fileFullImageName = [NSString stringWithFormat:@"%@.jpg",fileName];
        NSString* fullImagePath = [filePath stringByAppendingPathComponent:fileFullImageName];
        [fullJPGData writeToFile:fullImagePath atomically:YES];
        
        //生成消息实例
        TEMsgImageSubItem* imageItem = [[TEMsgImageSubItem alloc] initWithType:Image];
        imageItem.fileName = fileName;
        imageItem.imagePosition = CGRectMake(0, 0, fullWidth, fullHeight);
        
        TEChatMessage* chatMessage = [[TEChatMessage alloc] init];
        chatMessage.messageID = [NSString UUID];
        chatMessage.isAutoReply = NO;
        [chatMessage addItem:imageItem];
        
        [self insertNewMessage:chatMessage];
        //保存消息实例
//         __weak NSManagedObjectContext* context = [[TECoreDataHelper defaultHelper] backgroundContext];
//        TEMessage* message =  [NSEntityDescription insertNewObjectForEntityForName:@"TEMessage" inManagedObjectContext:context];
//        message.mID = [NSString UUID];
//        message.senderID = 100001;
//        message.receiverID = self.session.senderID;
//        message.content = [chatMessage xmlString];
//        message.sendTime = [NSDate date];
//        message.type = 1;
//        message.sessionID = self.session.sID;
//        message.senderIsMe = YES;
//        
//        self.session.totalNumOfMessage += 1;
//        
//        if ([context hasChanges]) {
//            NSError* error;
//            [context save:&error];
//        }
//        [message layout];
        
        //发送消息
    }
    
//    __weak NSManagedObjectContext* context = [[TECoreDataHelper defaultHelper] backgroundContext];
//    [context performBlock:^{
//
//    }];

}
@end
