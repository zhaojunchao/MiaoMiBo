//
//  JcShapeButton.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/23.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcShapeButton.h"
#import "JcAnimate.h"

@interface JcShapeButton ()<CAAnimationDelegate>

@property (nonatomic,assign) CFTimeInterval shrinkDuration;

@property (nonatomic,strong) CAMediaTimingFunction *shrinkCurve;

@property (nonatomic,strong) CAMediaTimingFunction *expandCurve;


@property (nonatomic,strong) UIColor *color;

@end

@implementation JcShapeButton

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _Layer = [[JcLayer alloc] initWithFrame:self.frame];
        
        _shrinkCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        _expandCurve = [CAMediaTimingFunction functionWithControlPoints:0.95 :0.02 :1 :0.05];
         _expandCurve = [CAMediaTimingFunction functionWithControlPoints:0.6 :0.1 :0.7 :0.2];
        self.shrinkDuration = 0.1;
        [self.layer addSublayer:_Layer];
        [self setup];
        
    }
    return self;
}

-(void)setup{
    
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2;
    self.clipsToBounds = true;
    [self addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)
   forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit];
    
}

- (void)scaleToSmall
{
    typeof(self) __weak weak = self;
    
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:nil];
}

- (void)scaleAnimation
{
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    [self StartAnimation];
}

- (void)scaleToDefault
{
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.4f options:UIViewAnimationOptionLayoutSubviews animations:^{
        weak.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

-(void)StartAnimation{
    
    [self performSelector:@selector(Revert) withObject:nil afterDelay:0.f];
    [self.layer addSublayer:_Layer];
    
    CABasicAnimation *shrinkAnim = [JcAnimate JcAnimationWithKeyPath:@"bounds.size.width" fromValue:@(CGRectGetWidth(self.bounds)) toValue:@(CGRectGetHeight(self.bounds)) TimeInterval: _shrinkDuration MediaTimingFunctionStr:_shrinkCurve repeatCount:0 FillMode:kCAFillModeForwards removedOnCompletion:false];
    [self.layer addAnimation:shrinkAnim forKey:shrinkAnim.keyPath];
    [_Layer animation];
    [self setUserInteractionEnabled:false];
}

-(void)JcShakeAnimation:(Completion)completion
{
    _block = completion;
    CABasicAnimation *shrinkAnim = [JcAnimate JcAnimationWithKeyPath:@"bounds.size.width" fromValue:@(CGRectGetHeight(self.bounds)) toValue:@(CGRectGetWidth(self.bounds)) TimeInterval:_shrinkDuration MediaTimingFunctionStr:_shrinkCurve repeatCount:0 FillMode:kCAFillModeForwards removedOnCompletion:false];
    _color = self.backgroundColor;
    
    CABasicAnimation *backgroundColor = [JcAnimate JcAnimationWithKeyPath:@"backgroundColor" fromValue:nil toValue:(__bridge id)[UIColor redColor].CGColor TimeInterval:0.1f MediaTimingFunctionStr:_shrinkCurve repeatCount:0 FillMode:kCAFillModeForwards removedOnCompletion:false];
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    keyFrame.delegate = self;
    self.layer.position = point;
    
    [self.layer addAnimation:backgroundColor forKey:backgroundColor.keyPath];
    [self.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
    [self.layer addAnimation:shrinkAnim forKey:shrinkAnim.keyPath];
    [_Layer stopAnimation];
    [self setUserInteractionEnabled:true];
}

-(void)JcBeganToCircleAnimation:(Completion)completion{
    
    _block = completion;
    CABasicAnimation *expandAnim = [JcAnimate JcAnimationWithKeyPath:@"transform.scale" fromValue:@(1.0) toValue:@(33.0) TimeInterval: 0.3 MediaTimingFunctionStr:_expandCurve repeatCount:0 FillMode:kCAFillModeForwards removedOnCompletion:false];
    expandAnim.delegate = self;
    [self.layer addAnimation:expandAnim forKey:expandAnim.keyPath];
    [_Layer stopAnimation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    CABasicAnimation *cab = (CABasicAnimation *)anim;
    if ([cab.keyPath isEqualToString:@"transform.scale"]) {
        [self setUserInteractionEnabled:true];
        if (_block) {
            _block();
        }
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(DidStopAnimation) userInfo:nil repeats:nil];
    }
}

-(void)Revert{
    
    CABasicAnimation *backgroundColor = [JcAnimate JcAnimationWithKeyPath:@"backgroundColor"fromValue:nil toValue:(__bridge id)self.backgroundColor.CGColor TimeInterval:0.1f MediaTimingFunctionStr:_shrinkCurve repeatCount:0 FillMode:kCAFillModeForwards removedOnCompletion:false];
    [self.layer addAnimation:backgroundColor forKey:@"backgroundColors"];
    
}

-(void)DidStopAnimation{
    [self.layer removeAllAnimations];
}

@end
