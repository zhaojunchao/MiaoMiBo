//
//  NSArray+Jc.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "NSArray+Jc.h"

@implementation NSArray (Jc)
- (id)objectAtIndexCheck:(NSUInteger)index {
    if (index < self.count) {
        return self[index];
    } else {
        //数组越界了就返回nil
        return nil;
    }
}

- (NSInteger)integerAtIndex:(NSUInteger)index
{
    NSNumber *value = [self objectAtIndex:index];
    if (value == nil) {
        return 0;
    }
    return value.integerValue;
}

- (NSString *)stringAtIndex:(NSUInteger)index
{
    id value = [self objectAtIndex:index];
    if (value == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@", value];
}

- (NSString *)stringAtIndexCheck:(NSUInteger)index
{
    id value = [self objectAtIndexCheck:index];
    if (value == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@", value];
    
}

@end
