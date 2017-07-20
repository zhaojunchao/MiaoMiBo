//
//  JcLiveHotModel.m
//  MiaoMibo
//
//  Created by 赵俊超 on 2017/6/28.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcLiveHotModel.h"

@implementation JcLiveHotModel
-(UIImage *)starImage{
    if (self.starlevel) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"girl_star%ld_40x19",self.starlevel]];
    }
    return nil;
}
@end
