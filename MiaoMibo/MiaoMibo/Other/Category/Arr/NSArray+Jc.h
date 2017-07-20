//
//  NSArray+Jc.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Jc)
- (id)objectAtIndexCheck:(NSUInteger)index;

- (NSInteger)integerAtIndex:(NSUInteger)index;

- (NSString *)stringAtIndex:(NSUInteger)index;

- (NSString *)stringAtIndexCheck:(NSUInteger)index;
@end
