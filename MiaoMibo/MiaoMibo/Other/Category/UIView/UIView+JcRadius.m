//
//  UIView+JcRadius.m
//  JcCorner
//
//  Created by zjc on 2017/7/7.
//  Copyright © 2017年 zhh. All rights reserved.
//

#import "UIView+JcRadius.h"
#import <objc/runtime.h>

static NSString * const JcCornerPositionKey = @"JcCornerPositionKey";
static NSString * const JcCornerRadiusKey = @"JcCornerRadiusKey";

@implementation UIView (JcRadius)

@dynamic Jc_cornerPosition;
- (JcCornerPosition)Jc_cornerPosition
{
    return [objc_getAssociatedObject(self, &JcCornerPositionKey) integerValue];
}

- (void)setJc_cornerPosition:(JcCornerPosition)Jc_cornerPosition
{
    objc_setAssociatedObject(self, &JcCornerPositionKey, @(Jc_cornerPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@dynamic Jc_cornerRadius;
- (CGFloat)Jc_cornerRadius
{
    return [objc_getAssociatedObject(self, &JcCornerRadiusKey) floatValue];
}

- (void)setJc_cornerRadius:(CGFloat)Jc_cornerRadius
{
    objc_setAssociatedObject(self, &JcCornerRadiusKey, @(Jc_cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load
{
    SEL ori = @selector(layoutSublayersOfLayer:);
    SEL new = NSSelectorFromString([@"hh_" stringByAppendingString:NSStringFromSelector(ori)]);
    hh_swizzle(self, ori, new);
}

void hh_swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    
    method_exchangeImplementations(origMethod, newMethod);
}

- (void)hh_layoutSublayersOfLayer:(CALayer *)layer
{
    [self hh_layoutSublayersOfLayer:layer];
    
    if (self.Jc_cornerRadius > 0) {
        
        UIBezierPath *maskPath;
        switch (self.Jc_cornerPosition) {
            case JcCornerPositionTop:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                       cornerRadii:CGSizeMake(self.Jc_cornerRadius, self.Jc_cornerRadius)];
                break;
            case JcCornerPositionLeft:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                                       cornerRadii:CGSizeMake(self.Jc_cornerRadius, self.Jc_cornerRadius)];
                break;
            case JcCornerPositionBottom:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                       cornerRadii:CGSizeMake(self.Jc_cornerRadius, self.Jc_cornerRadius)];
                break;
            case JcCornerPositionRight:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                                       cornerRadii:CGSizeMake(self.Jc_cornerRadius, self.Jc_cornerRadius)];
                break;
            case JcCornerPositionAll:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:UIRectCornerAllCorners
                                                       cornerRadii:CGSizeMake(self.Jc_cornerRadius, self.Jc_cornerRadius)];
                break;
        }
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

- (void)Jc_setCornerOnTopWithRadius:(CGFloat)radius
{
    self.Jc_cornerPosition = JcCornerPositionTop;
    self.Jc_cornerRadius = radius;
}

- (void)Jc_setCornerOnLeftWithRadius:(CGFloat)radius
{
    self.Jc_cornerPosition = JcCornerPositionLeft;
    self.Jc_cornerRadius = radius;
}

- (void)Jc_setCornerOnBottomWithRadius:(CGFloat)radius
{
    self.Jc_cornerPosition = JcCornerPositionBottom;
    self.Jc_cornerRadius = radius;
}

- (void)Jc_setCornerOnRightWithRadius:(CGFloat)radius
{
    self.Jc_cornerPosition = JcCornerPositionRight;
    self.Jc_cornerRadius = radius;
}

- (void)Jc_setAllCornerWithCornerRadius:(CGFloat)radius
{
    self.Jc_cornerPosition = JcCornerPositionAll;
    self.Jc_cornerRadius = radius;
}

- (void)Jc_setNoneCorner
{
    self.layer.mask = nil;
}

@end
