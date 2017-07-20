//
//  NSDictionary+Jc.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "NSDictionary+Jc.h"

@implementation NSDictionary (Jc)
- (BOOL)containsKey:(NSString *)key
{
    id value = [self objectForKey:key];
    return value == nil ? NO : YES;
}

- (NSString *)stringForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if (value == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@", value];
}

- (NSInteger)integerForKey:(id)aKey
{
    return [[self stringForKey:aKey] integerValue];
}

- (long long)longlongForKey:(id)aKey
{
    return [[self stringForKey:aKey] longLongValue];
}

- (BOOL)boolForKey:(id)aKey
{
    NSNumber *value = [self objectForKey:aKey];
    if (value == nil) {
        return NO;
    }
    return [value boolValue];
}

- (float)floatForKey:(id)aKey
{
    NSNumber *value = [self objectForKey:aKey];
    if (value == nil) {
        return 0;
    }
    return [value floatValue];
}

- (double)doubleForKey:(id)aKey
{
    NSNumber *value = [self objectForKey:aKey];
    if (value == nil) {
        return 0;
    }
    return [value doubleValue];
}

- (NSDate *)dateForKey:(id)aKey
{
    NSNumber *value = [self objectForKey:aKey];
    if (value == nil) {
        return nil;
    }
    return [NSDate dateWithTimeIntervalSince1970:value.longLongValue / 1000];
    
}

- (void)setBoolValue:(BOOL)value forKey:(NSString *)forKey
{
    [self setValue:[NSString stringWithFormat:@"%d", value] forKey:forKey];
}

- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)forKey
{
    [self setValue:[NSString stringWithFormat:@"%zd", value] forKey:forKey];
}

- (void)setFloatValue:(CGFloat)value forKey:(NSString *)forKey
{
    [self setValue:[NSString stringWithFormat:@"%f", value] forKey:forKey];
}

- (void)setDoubleValue:(double)value forKey:(NSString *)forKey
{
    [self setValue:[NSString stringWithFormat:@"%f", value] forKey:forKey];
}
@end
