//
//  JcUserInfoView.h
//  MiaoMibo
//
//  Created by zjc on 2017/7/10.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JcLiveHotModel.h"
@interface JcUserInfoView : UIView
@property (nonatomic, strong) JcLiveHotModel *Model;
+ (instancetype)userInfoView;
@end
