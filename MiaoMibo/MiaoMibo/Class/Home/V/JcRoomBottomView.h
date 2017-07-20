//
//  JcRoomBottomView.h
//  MiaoMibo
//
//  Created by 赵俊超 on 2017/7/6.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JcRoomBottomView : UIView
@property (nonatomic, copy) void (^clickToolBlock)(NSInteger tag,BOOL select);

@end
