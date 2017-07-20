//
//  JcMessageHelper.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JcMessageHelper : NSObject
+ (void)showSuccess:(NSString *)text;

+ (void)showSuccess:(UIView *)view text:(NSString *)text;

+ (void)showError:(NSString *)text;

+ (void)showError:(UIView *)view text:(NSString *)text;

+ (void)showTips:(UILabel *)label text:(NSString *)text;

+ (void)loading;

+ (void)loaded;

+ (void)loadingWithText:(NSString *)text;

+ (void)hideLoading;

@end
