//
//  NSDictionary+Jc.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Jc)
- (BOOL)containsKey:(NSString *)key;

- (NSString *)stringForKey:(id)aKey;

- (NSInteger)integerForKey:(id)aKey;

- (long long)longlongForKey:(id)aKey;

- (BOOL)boolForKey:(id)aKey;

- (float)floatForKey:(id)aKey;

- (double)doubleForKey:(id)aKey;

- (NSDate *)dateForKey:(id)aKey;

- (void)setBoolValue:(BOOL)value forKey:(NSString *)forKey;

- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)forKey;

- (void)setFloatValue:(CGFloat)value forKey:(NSString *)forKey;

- (void)setDoubleValue:(double)value forKey:(NSString *)forKey;
@end
