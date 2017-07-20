//
//  JcAnimate.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/23.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JcAnimate : NSObject


+(CABasicAnimation *_Nullable)JcAnimationWithKeyPath:(nullable NSString *)path fromValue:(id _Nullable )fromValue toValue:(id _Nullable )toValue TimeInterval:(CFTimeInterval)TimeInterval MediaTimingFunctionStr:(CAMediaTimingFunction *_Nullable)MediaTimingFunctionStr repeatCount:(float)repeatCount FillMode:(NSString *_Nullable)FillMode removedOnCompletion:(BOOL)removedOnCompletion;
+(void)JcAnimateWithDurationDuration:(NSTimeInterval)duration animations:(void (^_Nullable)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
+ (void)showMoreLoveAnimateFromView:(UIView *_Nullable)fromView addToView:(UIView *_Nullable)addToView;
@end
