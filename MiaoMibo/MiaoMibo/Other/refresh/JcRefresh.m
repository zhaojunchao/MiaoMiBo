//
//  JcRefresh.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcRefresh.h"

@implementation JcRefresh
-(instancetype)init{
    
    if (self = [super init]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
        
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"],[UIImage imageNamed:@"reflesh2_60x55"],[UIImage imageNamed:@"reflesh3_60x55"]] forState:MJRefreshStateRefreshing];
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"],[UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]] forState:MJRefreshStatePulling];
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]]  forState:MJRefreshStateIdle];
        
        
        
        
    }
    return self;
}
@end
