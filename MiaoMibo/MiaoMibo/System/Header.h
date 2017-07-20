//
//  Header.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/22.
//  Copyright © 2017年 zjc. All rights reserved.
//

#ifndef Header_h
#define Header_h

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomColor xyColorWithRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define KeyColor RGB(216, 41, 116)
#define KTabBarColor RGB(242, 98, 128)

#define sharedApp [UIApplication sharedApplication]
#define JcNoteCenter [NSNotificationCenter defaultCenter]

/******** 屏幕 *********/
#define ScreenW CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenH CGRectGetHeight([UIScreen mainScreen].bounds)
#define TabBarH 49
#define NavigationBarH 44

#define DocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
#define CachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define PreferencePath NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES).firstObject



#define interfaceSingleton(name)  +(instancetype)share##name


#if __has_feature(objc_arc)
// ARC
#define implementationSingleton(name)  \
+ (instancetype)share##name \
{ \
name *instance = [[self alloc] init]; \
return instance; \
} \
static name *_instance = nil; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[super allocWithZone:zone] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone{ \
return _instance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
}
#else
// MRC

#define implementationSingleton(name)  \
+ (instancetype)share##name \
{ \
name *instance = [[self alloc] init]; \
return instance; \
} \
static name *_instance = nil; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[super allocWithZone:zone] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone{ \
return _instance; \
} \
- (id)mutableCopyWithZone:(NSZone *)zone \
{ \
return _instance; \
} \
- (oneway void)release \
{ \
} \
- (instancetype)retain \
{ \
return _instance; \
} \
- (NSUInteger)retainCount \
{ \
return  MAXFLOAT; \
}
#endif


/************* 网络 *********************/
#define JcBaseURLStr @"http://live.9158.com"
/** 数据库表名*/
#define DB_TABLE_NAME @"FavoritesTable"






#import <IJKMediaFramework/IJKMediaFramework.h>
#import "JcMessageView.h"
#import "JcNetWorkTool.h"
#import "UIView+SDAutoLayout.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import "JcConst.h"
#import "JcTool.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Jc.h"
#import "JcMessageHelper.h"
#import "UIView+Frame.h"
#import "JcncBlock.h"
#endif /* Header_h */
