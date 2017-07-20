//
//  JcncBlock.h
//  MiaoMibo
//
//  Created by 赵俊超 on 2017/7/12.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JcncBlock : NSObject
+ (void)startWatch;
+ (void)addToWatch:(id)object;
+ (NSArray *)allObjects;
@end
