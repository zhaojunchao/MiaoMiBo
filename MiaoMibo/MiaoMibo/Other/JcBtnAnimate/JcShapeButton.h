//
//  JcShapeButton.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/23.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JcLayer.h"
typedef void(^Completion)();

@interface JcShapeButton : UIButton

@property (nonatomic,strong) JcLayer *Layer;
@property (nonatomic,copy) Completion block;

-(void)JcBeganToCircleAnimation:(Completion)completion;

-(void)JcShakeAnimation:(Completion)completion;
@end
