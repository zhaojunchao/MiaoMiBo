//
//  JcRoomBottomView.m
//  MiaoMibo
//
//  Created by 赵俊超 on 2017/7/6.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcRoomBottomView.h"

@implementation JcRoomBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupBasic];
    }
    return self;
}

- (NSArray *)tools
{
    return @[@"talk_public_40x40", @"talk_private_40x40", @"talk_sendgift_40x40", @"talk_rank_40x40", @"talk_share_40x40", @"talk_close_40x40"];
}

- (void)setupBasic
{
    CGFloat wh = 40;
    CGFloat margin = (ScreenW - wh * self.tools.count) / (self.tools.count + 1.0);
    CGFloat x = 0;
    CGFloat y = 0;
    for (int i = 0; i < self.tools.count; i++) {
        x = margin + (margin + wh) * i;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
        btn.userInteractionEnabled = YES;
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:self.tools[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
}

- (void)click:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.clickToolBlock) {
        self.clickToolBlock(btn.tag,btn.selected);
    }
}
@end
