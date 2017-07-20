//
//  JcUserInfoView.m
//  MiaoMibo
//
//  Created by zjc on 2017/7/10.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcUserInfoView.h"
#import "UIView+JcRadius.h"
#import "UIImageView+Jc.h"
#import "UIImage+JcImage.h"
#import "DatabaseManager.h"
@interface JcUserInfoView()
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *careNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIButton *care;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraints;
@property (weak, nonatomic) IBOutlet UIButton *CloseBtn;

@property (nonatomic, weak) JcUserInfoView *userInfoView;

@end

@implementation JcUserInfoView

+ (instancetype)userInfoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
self.careNumLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(500) + 500];
self.fansNumLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(300) + 500];
    [self.userView Jc_setAllCornerWithCornerRadius:10];
}

-(void)setModel:(JcLiveHotModel *)Model{
    _Model = Model;
    self.nickNameLabel.text = Model.myname;
    [self.coverView imageWithURLString:Model.smallpic placeholderImage:[UIImage imageNamed:@"placeholder_head"] completed:^(UIImage *image, NSError *error, NSURL *url) {
        image = [UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:1];
        self.coverView.image = image;
    }];
    if ([[DatabaseManager shareDatabaseManager]select:[JcLiveHotModel class] tableName:DB_TABLE_NAME where:[NSString stringWithFormat:@"userId = '%@'",Model.userId]].count >0) {
        self.care.selected = YES;
    }else{
        self.care.selected = NO;
    }
}
- (IBAction)care:(UIButton *)sender {

    if (! ([self setupDatabaseCount] > 0)) {
         [JcMessageHelper showSuccess:@"关注成功"];
        [[DatabaseManager shareDatabaseManager] insert:_Model tableName:DB_TABLE_NAME];
        
        sender.selected = YES;
    }else{
        [JcMessageHelper showSuccess:@"取消关注"];
        [[DatabaseManager shareDatabaseManager]deleteTableName:DB_TABLE_NAME where:[NSString stringWithFormat:@"userId = '%@'",_Model.userId]];
        sender.selected = NO;
    }

    
}
-(NSInteger)setupDatabaseCount{
    //是否有这条数据
    return  [[DatabaseManager shareDatabaseManager]select:[JcLiveHotModel class] tableName:DB_TABLE_NAME where:[NSString stringWithFormat:@"userId = '%@'",_Model.userId]].count;
}
- (IBAction)tipoffs {
    
    [JcMessageHelper showSuccess:@"举报成功"];
}

- (IBAction)close {
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.7 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.userInfoView = nil;
    }];
    
}
- (IBAction)watchLive {
    
    [self close];
}
@end
