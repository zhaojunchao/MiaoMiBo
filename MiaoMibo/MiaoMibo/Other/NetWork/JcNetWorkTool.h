//
//  JcNetWorkTool.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/22.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "AFHTTPSessionManager.h"
typedef NS_ENUM(NSUInteger, NetWorkStates) {
    NetWorkStatesNone,//没有网络
    NetWorkStates2G, //2G
    NetWorkStates3G, //3G
    NetWorkStates4G, //4G
    NetWorkStatesWIFI //WIFI
};
@interface JcNetWorkTool : AFHTTPSessionManager
+(instancetype)shareTool;

//判断网络类型
+(NetWorkStates)getNetworkStates;
@end
