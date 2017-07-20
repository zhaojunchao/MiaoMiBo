//
//  JcLivehotTableViewCell.m
//  MiaoMibo
//
//  Created by 赵俊超 on 2017/6/28.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcLivehotTableViewCell.h"
#import "JcLiveHotModel.h"

#import "UIImage+JcImage.h"
@interface JcLivehotTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *ChaoYangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *StartView;

@property (weak, nonatomic) IBOutlet UIButton *LocationBtn;

@property (weak, nonatomic) IBOutlet UIImageView *BigPicView;

@end

@implementation JcLivehotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setLive:(JcLiveHotModel *)live{
    
    _live = live;

   
    [self.HeadImageView imageWithURL:[NSURL URLWithString:live.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] completed:^(UIImage *image, NSError *error, NSURL *url) {
        image = [UIImage circleImage:image borderColor:KeyColor borderWidth:0];
        self.HeadImageView.image = image;
    }];

    self.NameLabel.text = live.myname;
    if (!live.gps.length) {
        live.gps = @"喵星";
    }
    
    
    [self.LocationBtn setTitle:live.gps forState:UIControlStateNormal];
    [self.BigPicView imageWithURL:[NSURL URLWithString:live.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    self.StartView.image = live.starImage;
    self.StartView.hidden = !live.starlevel;
    
    //设置当前观众数量
    NSString *fullChaoyang = [NSString stringWithFormat:@"%ld人在看",live.allnum];
    NSRange range = [fullChaoyang rangeOfString:[NSString stringWithFormat:@"%ld",live.allnum]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:fullChaoyang];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:KeyColor range:range];
    self.ChaoYangeLabel.attributedText = attr;
    
}
@end
