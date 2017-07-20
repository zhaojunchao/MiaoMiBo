//
//  JcMessageHelper.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcMessageHelper.h"
#import "MBProgressHUD.h"
#import "NSDictionary+Jc.h"

NSTimer *tipTimer;
MBProgressHUD *loadingHUDView;
MBProgressHUD *hudView;
MBProgressHUD *loadingView;

@implementation JcMessageHelper

+ (void)show:(UIView *)view text:(NSString *)text icon:(NSString *)icon
{
    if (text == nil || [text isEqualToString:@""]) {
        return;
    }
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    if (hudView != nil) {
        [hudView hide:YES];
    }
    // 快速显示一个提示信息
    hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hudView.labelText = text;
    // 设置图片
    hudView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hudView.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hudView.removeFromSuperViewOnHide = YES;
    hudView.userInteractionEnabled = NO;
    [hudView hide:YES afterDelay:1.5];
    
}

+ (void)showSuccess:(NSString *)text
{
    [self show:nil text:text icon:@"success"];
}

+ (void)showSuccess:(UIView *)view text:(NSString *)text
{
    [self show:view text:text icon:@"success"];
}

+ (void)showError:(NSString *)text
{
    [self show:nil text:text icon:@"error"];
}

+ (void)showError:(UIView *)view text:(NSString *)text
{
    [self show:nil text:text icon:@"error"];
}

+ (void)showTips:(UILabel *)label text:(NSString *)text
{
    label.hidden = NO;
    label.text = text;
    if (tipTimer != nil) {
        [tipTimer invalidate];
        tipTimer = nil;
    }
    tipTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hideTips:) userInfo:label repeats:YES];
}

+ (void)hideTips:(NSTimer *)timer
{
    if (tipTimer != nil) {
        UILabel *label = [timer userInfo];
        label.hidden = YES;
        [tipTimer invalidate];
        tipTimer = nil;
    }
}

+ (void)loading
{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    loadingHUDView = [[MBProgressHUD alloc] initWithView:view];
    loadingHUDView.labelFont = [UIFont boldSystemFontOfSize:15];
    loadingHUDView.labelColor = RGB(226, 226, 226);
    loadingHUDView.square = YES;
    [view addSubview:loadingHUDView];
    loadingHUDView.labelText = @"请稍后";
    [loadingHUDView show:YES];
    tipTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(stopOutTimeTimer) userInfo:nil repeats:NO];
}

+ (void)stopOutTimeTimer
{
    if (tipTimer) {
        [tipTimer invalidate];
        tipTimer = nil;
        [self loaded];
    }
}

+ (void)loaded
{
    if (loadingHUDView != nil) {
        [loadingHUDView hide:YES];
        [loadingHUDView removeFromSuperview];
        loadingHUDView = nil;
    }
}

+ (void)loadingWithText:(NSString *)text
{
    if (loadingView == nil) {
        UIView *view = [UIApplication sharedApplication].keyWindow;
        loadingView = [[MBProgressHUD alloc] initWithView:view];
        loadingView.labelFont = [UIFont boldSystemFontOfSize:15];
        loadingView.labelColor = RGB(226, 226, 226);
        loadingView.minSize = CGSizeMake(80, 80);
        [loadingView show:YES];
        [view addSubview:loadingView];
    }
    loadingView.labelText = text;
}

+ (void)hideLoading
{
    if (loadingView == nil) {
        return;
    }
    [loadingView removeFromSuperview];
    loadingView = nil;
}

@end
