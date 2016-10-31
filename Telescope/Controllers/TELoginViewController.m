//
//  ViewController.m
//  Telescope
//
//  Created by Showers on 16/9/2.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TELoginViewController.h"
#import "TENetworkKit.h"
#import "TETextField.h"
#import "TEBezierPathButton.h"
#import "TEActiveWheel.h"
#import "MLLinkLabel.h"

#import "TEWebViewController.h"

@interface TELoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TETextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet TETextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet TEBezierPathButton *verifyButton;
@property (weak, nonatomic) IBOutlet MLLinkLabel *protocolLabel;

@property (assign, nonatomic) CGRect verifyBtnFrame;

@end


@implementation TELoginViewController

#pragma mark - *** Properties ****


#pragma makr - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configProtocolLabel];
}


- (void)dealloc
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.verifyBtnFrame = self.verifyButton.frame;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"";
}

#pragma makr - *** Helper ***
- (void)configProtocolLabel
{
    self.protocolLabel.dataDetectorTypes = MLDataDetectorTypeAll;
    self.protocolLabel.allowLineBreakInsideLinks = YES;
    self.protocolLabel.linkTextAttributes = nil;
    self.protocolLabel.activeLinkTextAttributes = nil;
    self.protocolLabel.linkTextAttributes = @{NSForegroundColorAttributeName:RGB(64, 213, 171)};
    
    [self.protocolLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
        [self performSegueWithIdentifier:@"push_web_view" sender:link];
    }];
    
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.protocolLabel.text];
    
    NSRange range = [self.protocolLabel.text rangeOfString:@"《法律声明及隐私策略》" options:NSRegularExpressionSearch];
    NSString* linkValue = @"https://www.apple.com";
    [attrStr addAttribute:NSLinkAttributeName value:linkValue range:range];
    
    self.protocolLabel.attributedText = attrStr;
}


#pragma mark - *** Target Action ***

- (IBAction)loginBtnClicked:(id)sender {

    [self.view endEditing:YES];
    [TEActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在登录 ...";
    [TENETWORKKIT loginWithAccountNum:self.userNameTextfield.text
                             password:self.passwordTextfield.text
                           completion:^(TEResponse<TEUser *> *response) {
                               if (response.isSuccess) {
                                   [TEActiveWheel dismissForView:self.navigationController.view];
                                   [self performSegueWithIdentifier:@"te_show_main" sender:sender];
                               }
                               else{
                                   [TEActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:response.errorInfo];
                               }
                           } onError:^{
                               
                           }];
}


- (IBAction)disconnectBtnClicked:(id)sender {
    //[self.netEngine disconnect];
}

#pragma makr - *** UITextFieldDelegate ***

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.userNameTextfield == textField) {
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:4.0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect rect = self.verifyBtnFrame;
                             self.verifyButton.frame = CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, 0, rect.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else{
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.userNameTextfield == textField) {
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:4.0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect rect = self.verifyBtnFrame;
                             self.verifyButton.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else{
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        if (self.userNameTextfield == textField) {
            [self.passwordTextfield becomeFirstResponder];
        }
        else{
            [self.passwordTextfield resignFirstResponder];
        }
    }

    return YES;
}


#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"te_show_main"]) {
        
    }
    
    if ([segue.identifier isEqualToString:@"push_web_view"]) {
        TEWebViewController* wvc = (TEWebViewController*)segue.destinationViewController;
        MLLink* link = (MLLink*)sender;
        NSString *linkText = [self.protocolLabel.text substringWithRange:link.linkRange];
        wvc.url = link.linkValue;
        wvc.linkTitle = linkText;

    }
}


@end
