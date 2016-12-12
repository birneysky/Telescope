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


typedef NS_ENUM(NSUInteger,TEChatToolBarState){
    TEToolbarNormalState          = 0,
    TEToolbarAudioRecordState     = 1 << 0,
    TEToolbarExpressionPanelState = 1 << 1,
    TEToolbarExtraPanelState      = 1 << 2,
    TEToolbarInputTextState       = 1 << 3
};

#define TEToolbarMaxHeight 100


@interface TEChatViewController ()<TEChatExpressionPannelDelegate>
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
    NSString* pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSRegularExpression* regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString* text = self.textView.text;
    NSArray<NSTextCheckingResult*>* result = [regularExpression matchesInString:text options:NSMatchingWithTransparentBounds range:NSMakeRange(0, text.length)];
    
    [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
    NSAssert(regularExpression,@"正则%@有误",pattern);
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
        
        return NO;
    }
    return YES;
}


#pragma mark - ***TEChatExpressionPannelDelegate ***
- (void)factButtonClickedAtIndex:(NSUInteger)index
{
    TEExpressionNamesManager* manager = [TEExpressionNamesManager defaultManager];
    
    NSString* expresssionName =  manager.names[index];
    self.textView.text = [self.textView.text stringByAppendingFormat:@"[%@]",expresssionName];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 1, 1)];
}

- (void)sendButtonClickedInPannnel
{
    if (self.textView.text.length <= 0) {
        return;
    }
    [self sendMessage];
}

@end
