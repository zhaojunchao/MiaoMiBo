//
//  MyCenterViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/26.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "MyCenterViewController.h"
#import "UINavigationBar+WRAddition.h"
@interface MyCenterViewController ()

@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,10, 0);
    //排行
    //https://live.9158.com/Rank/giftStarRank?showtype=hall&useridx=62395282&photo=http://liveimg.9158.com/default.png&Random=8
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar wr_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

// 改变导航栏颜色对应的透明度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    // 除数表示 -> 导航栏从完全透明到完全不透明的过渡距离
    CGFloat alpha = (offsetY - 60) / 64;
    
    if (offsetY > 60) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController.navigationBar wr_setBackgroundColor:[KeyColor colorWithAlphaComponent:alpha]];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationController.navigationBar wr_setBackgroundColor:[UIColor clearColor]];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
