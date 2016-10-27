//
//  ViewController.m
//  Telescope
//
//  Created by Showers on 16/9/2.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "LoginViewController.h"
#import "TENetworkKit.h"
#import "TETextField.h"
#import "TEBezierPathButton.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TETextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet TETextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet TEBezierPathButton *verifyButton;

@property (assign, nonatomic) CGRect verifyBtnFrame;

@end


@implementation LoginViewController

#pragma mark - *** Properties ****


#pragma makr - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];

    //[self.client connectToHost:@"123.57.20.30" onPort:9997 error:&error];

//    self.view.backgroundColor = RGB(30, 30, 30);
    
    //[TENetworkKit defaultNetKit];

}


- (void)dealloc
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.verifyBtnFrame = self.verifyButton.frame;
//    while (true) {
//        [self loginBtnClicked:nil];
//        sleep(5);
//        [self disconnectBtnClicked:nil];
//    }
}

#pragma mark - *** Target Action ***

- (IBAction)loginBtnClicked:(id)sender {
    NSError* error;
    //[self.netEngine connectToHost:@"123.57.20.31" onPort:9997 error:&error];
    //[self.netEngine connectToHost:@"192.168.0.103" onPort:9997 error:&error];
    [[TENetworkKit defaultNetKit] loginWithAccountNum:self.userNameTextfield.text password:self.passwordTextfield.text];
    if(error){
        NSLog(@"%@",error);
    }
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





@end
