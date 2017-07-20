//
//  JcAnchorInfoView.m
//  MiaoMibo
//
//  Created by 赵俊超 on 2017/7/6.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcAnchorInfoView.h"
#import "UIView+JcRadius.h"
#import "UIImage+JcImage.h"
#import "JcLiveHotModel.h"
#import "DatabaseManager.h"
@interface JcAnchorInfoView()
@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet UILabel *roomID;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation JcAnchorInfoView

+ (instancetype)anchorInfoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.anchorView Jc_setAllCornerWithCornerRadius:30];
    [self.careBtn Jc_setAllCornerWithCornerRadius:12];
}
static int randomNum = 0;
-(void)setLiveModel:(JcLiveHotModel *)LiveModel{
    _LiveModel = LiveModel;
    [self.headImageView imageWithURL:[NSURL URLWithString:LiveModel.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] completed:^(UIImage *image, NSError *error, NSURL *url) {
            image = [UIImage circleImage:image borderColor:KeyColor borderWidth:0];
            self.headImageView.image = image;
        }];
    self.nameLabel.text = LiveModel.myname;
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人", (long)LiveModel.allnum];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNum) userInfo:nil repeats:YES];
    
    
    [self.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderView:)]];
    self.headImageView.userInteractionEnabled = YES;
    
    self.roomID.text = [NSString stringWithFormat:@"房间:%ld",(long)LiveModel.roomid];
    
    if ([self setupDatabaseCount] >0) {
        self.careBtn.selected = YES;
    }else{
        self.careBtn.selected = NO;
    }

}
-(NSInteger)setupDatabaseCount{
    //是否有这条数据
   return  [[DatabaseManager shareDatabaseManager]select:[JcLiveHotModel class] tableName:DB_TABLE_NAME where:[NSString stringWithFormat:@"userId = '%@'",_LiveModel.userId]].count;
}
- (void)clickHeaderView:(UITapGestureRecognizer *)tapGes
{
    if (_selectBlock){
        _selectBlock();
    }
}
- (void)updateNum
{
    randomNum += arc4random_uniform(5);
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人",_LiveModel.allnum + randomNum];
}
- (IBAction)careClick:(UIButton *)sender {
    if (! ([self setupDatabaseCount] > 0)) {
        [JcMessageHelper showSuccess:@"关注成功"];
        [[DatabaseManager shareDatabaseManager] insert:_LiveModel tableName:DB_TABLE_NAME];
        
        sender.selected = YES;
    }else{
        [JcMessageHelper showSuccess:@"取消关注"];
        [[DatabaseManager shareDatabaseManager]deleteTableName:DB_TABLE_NAME where:[NSString stringWithFormat:@"userId = '%@'",_LiveModel.userId]];
        sender.selected = NO;
    }
}
/**
 *  先删除数据库中所有数据
 */
//[[DatabaseManager shareDatabaseManager] deleteALLTableName:DB_TABLE_NAME];

//[[DatabaseManager shareDatabaseManager] insert:[MapDataModel objectWithKeyValues:dic] tableName:DB_TABLE_NAME];
//[[DatabaseManager shareDatabaseManager]creatTable:[MapDataModel class] tableName:DB_TABLE_NAME];

//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    
//    
//    NSArray * dataArray  = [[DatabaseManager shareDatabaseManager] selectALL:[MapDataModel class] tableName:DB_TABLE_NAME];
//    
//    
//    //         [[PINCache sharedCache] setObject:dataArray forKey:DB_DATACACHE];
//    [[PINDiskCache sharedCache] setObject:dataArray forKey:DB_DATACACHE];
//    
//});


@end
