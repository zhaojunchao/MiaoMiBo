//
//  JcHotRoomViewController.h
//  MiaoMibo
//
//  Created by zjc on 2017/7/6.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollSegmentView.h"
typedef NS_ENUM(NSInteger, JcHomeLiveType){
    JcHomeLiveTypeHot = 1, 
    JcHomeLiveTypeNew = 3,
    JcHomeLiveTypeSameCity = 2,
    JcHomeLiveTypeSign = 9,
    JcHomeLiveTypeOverseas = 8,
};
@interface JcHotRoomViewController : UIViewController<ZJScrollPageViewChildVcDelegate>
- (JcHomeLiveType)liveType;
@end
