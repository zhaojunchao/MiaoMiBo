//
//  AppDelegate.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/22.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "AppDelegate.h"
#import "JcNetWorkTool.h"
#import "YYFPSLabel.h"
#import "Reachability.h"
#import "ADAVViewController.h"
#import "DatabaseManager.h"
#import "JcLiveHotModel.h"
@interface AppDelegate ()
@property(nonatomic,strong)Reachability *reachability;
@property(nonatomic,assign)NetWorkStates previousState;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([[DatabaseManager shareDatabaseManager]isTableOK:DB_TABLE_NAME] == NO){
        [[DatabaseManager shareDatabaseManager]creatTable:[JcLiveHotModel class] tableName:DB_TABLE_NAME];
    }
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 开始检测
//    [JcncBlock startWatch];
    
    ADAVViewController *VC = [[ADAVViewController alloc] init];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];

    [self checkNetworkstate];
#if defined(DEBUG)||defined(_DEBUG)
    YYFPSLabel *label = [YYFPSLabel new];
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor blueColor];
    label.frame = CGRectMake(200, 200, 50, 30);
    [label sizeToFit];
    [label bringSubviewToFront:self.window];
    [self.window addSubview:label];
#endif
    
#ifdef DEBUG
    //  设置报告日志
    [IJKFFMoviePlayerController setLogReport:YES];
    //  设置日志的级别为Debug
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    //1.2否则(如果不是debug状态的)
#else
    //  设置不报告日志
    [IJKFFMoviePlayerController setLogReport:NO];
    //  设置日志级别为信息
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    return YES;
}

// 实时监测网络状态
- (void)checkNetworkstate {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    _reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [_reachability startNotifier];
}

- (void)networkChange {
    
    NSString *StateStr = nil;
    
    // 获取当前网络状态
    NetWorkStates currentState = [JcNetWorkTool getNetworkStates];
    if (currentState == _previousState) return;
    
    _previousState = currentState;
    switch (currentState) {
        case NetWorkStatesNone:
            StateStr = @"世上最痛苦的事情就是有手机却没有网!";
            break;
        case NetWorkStates2G:
            StateStr = @"切换到了2G网络,请您注意流量";
            break;
        case NetWorkStates3G:
            StateStr = @"切换到了3G网络,请您注意流量";
            break;
        case NetWorkStates4G:
            StateStr = @"切换到了4G网络,请您注意流量";
            break;
        case NetWorkStatesWIFI:
            StateStr = nil;
            break;
            
        default:
            break;
    }
    NSLog(@"网络状态码----%ld", currentState);
    if (StateStr.length) {
        [[JcMessageView sharedInstance]ShowMessage:StateStr];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
