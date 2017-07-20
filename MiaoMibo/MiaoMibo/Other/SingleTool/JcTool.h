//
//  JcTool.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#define jcSingleTool JcTool.shareJcTool


@interface JcTool : NSObject
interfaceSingleton(JcTool);

/**
 * conan:扩展字符串
 */
- (NSString *)psdAppandStringWithOriString:(NSString *)oriString appendString:(NSString *)appendString;
/**
 * 判断字符串是否为空
 */
- (BOOL)isEmpty:(NSString *)value;
/**
 * 判断字符串是否不为空
 */
- (BOOL)isNotEmpty:(NSString *)value;

-(BOOL)isEmptyArray:(NSArray *)values;

- (BOOL)isNotEmptyArray:(NSArray *)values;

- (NSInteger)toInteger:(id)value;

- (NSString *)toStr:(id)value;

- (NSString *)toString:(NSInteger)value;

/**
 * 获取字符个数，一个中文算一个长度，两个英文算一个长度
 */
- (NSUInteger)length:(NSString *)value;

/**
 * 编码字符串
 */
- (NSString *)encode:(NSString *)value;

/**
 * 解码字符串
 */
- (NSString *)decode:(NSString *)value;
/**
 * 去掉字符串空格
 */
- (NSString *)trim:(NSString *)value;
/**
 * conan:去掉字符串空格和换行
 */
-(NSString *)trimWhitespaceAndNewlineWithString : (NSString *)valueString;
/**
 * 获取window
 */
- (UIWindow *)lastWindow;
@end
