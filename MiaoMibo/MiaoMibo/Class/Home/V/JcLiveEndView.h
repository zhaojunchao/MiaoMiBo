//
//  JcLiveEndView.h
//  MiaoMibo
//
//  Created by zjc on 2017/7/7.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JcLiveEndView : UIView
/** 退出 */
@property (nonatomic, copy) void (^quitBlock)();


+ (instancetype)liveEndView;
@end
