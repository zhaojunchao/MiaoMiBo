//
//  JcAnchorInfoView.h
//  MiaoMibo
//
//  Created by 赵俊超 on 2017/7/6.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JcLiveHotModel;
@interface JcAnchorInfoView : UIView

@property (nonatomic, strong) JcLiveHotModel *LiveModel;

@property (nonatomic, copy) void (^selectBlock)();

+ (instancetype)anchorInfoView;
@end
