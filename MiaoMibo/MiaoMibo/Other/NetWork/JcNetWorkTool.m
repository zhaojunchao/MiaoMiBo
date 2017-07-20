//
//  JcNetWorkTool.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/22.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcNetWorkTool.h"

@implementation JcNetWorkTool
static JcNetWorkTool * _manager;
+(instancetype)shareTool{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [JcNetWorkTool manager];
        _manager.requestSerializer.timeoutInterval = 20.f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    });
    
    return _manager;
}
- (JcNetWorkTool *)copyWithZone:(NSZone *)zone {
    return _manager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}


//判断网络类型
+(NetWorkStates)getNetworkStates{
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"]subviews];
    //保存网络状态
    NetWorkStates states = NetWorkStatesNone;
#pragma mark --------------------------
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (networkType) {
                case 0:
                    //无网模式
                    states = NetWorkStatesNone;
                    break;
                case 1:
                    states = NetWorkStates2G;
                    break;
                case 2:
                    states = NetWorkStates3G;
                    break;
                case 3:
                    states = NetWorkStates4G;
                    break;
                case 5:
                    states = NetWorkStatesWIFI;
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return states;
}
@end
