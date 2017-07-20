//
//  JcLayer.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/23.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcLayer.h"
#import "JcAnimate.h"
@implementation JcLayer
-(instancetype) initWithFrame:(CGRect)frame{
    
    self = [super init];
    if (self) {
        CGFloat radius = (CGRectGetHeight(frame) / 2) * 0.5;
        self.frame = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame));
        CGPoint center = CGPointMake(CGRectGetHeight(frame) / 2, CGRectGetMidY(self.bounds));
        CGFloat startAngle = 0 - M_PI_2;
        CGFloat endAngle = M_PI * 2 - M_PI_2;
        self.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES].CGPath;
        self.fillColor = nil;
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.lineWidth = 1;
        self.strokeEnd = 0.4;
        self.hidden = true;
    }
    return self;
}

-(void)animation{
    
    self.hidden = false;
    CABasicAnimation *rotate =  [JcAnimate JcAnimationWithKeyPath:@"transform.rotation.z" fromValue:0 toValue:@(M_PI * 2) TimeInterval:0.4 MediaTimingFunctionStr:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] repeatCount:MAXFLOAT FillMode:kCAFillModeForwards removedOnCompletion:NO];
    [self addAnimation:rotate forKey:rotate.keyPath];
}

-(void)stopAnimation{
    
    self.hidden = true;
    [self removeAllAnimations];
}

@end


@interface JcTransitions ()

@property (nonatomic,assign) NSTimeInterval transitionDuration;

@property (nonatomic,assign) CGFloat startingAlpha;

@property (nonatomic,assign) BOOL is;

@property (nonatomic,strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation JcTransitions

-(instancetype) initWithTransitionDuration:(NSTimeInterval)transitionDuration StartingAlpha:(CGFloat)startingAlpha isBOOL:(BOOL)is{
    self = [super init];
    if (self) {
        _transitionDuration = transitionDuration;
        _startingAlpha = startingAlpha;
        _is = is;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return _transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = [transitionContext containerView];
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    if (_is) {
        toView.alpha = _startingAlpha;
        fromView.alpha = 1.0f;
        
        [containerView addSubview:toView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            toView.alpha = 1.0f;
            fromView.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            fromView.alpha = 1.0f;
            [transitionContext completeTransition:true];
        }];
    }else{
        fromView.alpha = 1.0f;
        toView.alpha = 0;
        fromView.transform = CGAffineTransformMakeScale(1, 1);
        [containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            fromView.transform = CGAffineTransformMakeScale(3, 3);
            fromView.alpha = 0.0f;
            toView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            fromView.alpha = 1.0f;
            [transitionContext completeTransition:true];
        }];
    }
}


@end
