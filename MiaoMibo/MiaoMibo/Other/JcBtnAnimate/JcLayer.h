//
//  JcLayer.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/23.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface JcLayer : CAShapeLayer
-(instancetype)initWithFrame:(CGRect)frame;

-(void)animation;

-(void)stopAnimation;
@end

@interface JcTransitions : NSObject <UIViewControllerAnimatedTransitioning>

-(instancetype)initWithTransitionDuration:(NSTimeInterval)transitionDuration StartingAlpha:(CGFloat)startingAlpha isBOOL:(BOOL)is;

@end
