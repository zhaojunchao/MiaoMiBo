//
//  JcAnimate.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/23.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcAnimate.h"

@implementation JcAnimate
+(CABasicAnimation *_Nullable)JcAnimationWithKeyPath:(nullable NSString *)path fromValue:(id _Nullable )fromValue toValue:(id _Nullable )toValue TimeInterval:(CFTimeInterval)TimeInterval MediaTimingFunctionStr:(CAMediaTimingFunction *_Nullable)MediaTimingFunctionStr repeatCount:(float)repeatCount FillMode:(NSString *_Nullable)FillMode removedOnCompletion:(BOOL)removedOnCompletion{
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:path];
    rotate.fromValue = fromValue;
    rotate.toValue = toValue;
    rotate.duration = TimeInterval;
    rotate.timingFunction = MediaTimingFunctionStr;
    rotate.repeatCount = repeatCount;
    rotate.fillMode = FillMode;
    rotate.removedOnCompletion = removedOnCompletion;
    return rotate;
}

+(void)JcAnimateWithDurationDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:duration animations:animations completion:completion];
}

+ (void)showMoreLoveAnimateFromView:(UIView *_Nullable)fromView addToView:(UIView *_Nullable)addToView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    CGRect loveFrame = [fromView convertRect:fromView.frame toView:addToView];
    CGPoint position = CGPointMake(fromView.layer.position.x, loveFrame.origin.y - 30);
    imageView.layer.position = position;
    NSArray *imgArr = @[@"live_like_s_blue",@"live_like_s_grn",@"live_like_s_orange",@"live_like_s_violet",@"live_like_s_yel",@"live_like_s_red"];
    NSInteger img = arc4random()%6;
    imageView.image = [UIImage imageNamed:imgArr[img]];
    [addToView addSubview:imageView];
    
    imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    CGFloat duration = 3 + arc4random()%5;
    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimate.repeatCount = 1;
    positionAnimate.duration = duration;
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    
    UIBezierPath *sPath = [UIBezierPath bezierPath];
    [sPath moveToPoint:position];
    CGFloat sign = arc4random()%2 == 1 ? 1 : -1;
    CGFloat controlPointValue = (arc4random()%50 + arc4random()%100) * sign;
    [sPath addCurveToPoint:CGPointMake(position.x, position.y - 300) controlPoint1:CGPointMake(position.x - controlPointValue, position.y - 150) controlPoint2:CGPointMake(position.x + controlPointValue, position.y - 150)];
    positionAnimate.path = sPath.CGPath;
    [imageView.layer addAnimation:positionAnimate forKey:@"heartAnimated"];
    
    
    [UIView animateWithDuration:duration animations:^{
        imageView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

@end
