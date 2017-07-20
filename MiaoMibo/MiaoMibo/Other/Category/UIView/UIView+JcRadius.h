//
//  UIView+JcRadius.h
//  JcCorner
//
//  Created by zjc on 2017/7/7.
//  Copyright © 2017年 zhh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JcCornerPosition) {
    JcCornerPositionTop,
    JcCornerPositionLeft,
    JcCornerPositionBottom,
    JcCornerPositionRight,
    JcCornerPositionAll
};
@interface UIView (JcRadius)

@property (nonatomic, assign) JcCornerPosition Jc_cornerPosition;
@property (nonatomic, assign) CGFloat Jc_cornerRadius;

- (void)Jc_setCornerOnTopWithRadius:(CGFloat)radius;
- (void)Jc_setCornerOnLeftWithRadius:(CGFloat)radius;
- (void)Jc_setCornerOnBottomWithRadius:(CGFloat)radius;
- (void)Jc_setCornerOnRightWithRadius:(CGFloat)radius;
- (void)Jc_setAllCornerWithCornerRadius:(CGFloat)radius;
- (void)Jc_setNoneCorner;
@end
