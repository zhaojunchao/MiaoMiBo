//
//  JcFavoritesViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/7/5.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcFavoritesViewController.h"
#import "JcLivehotTableViewCell.h"
#import "JcLiveRoomViewController.h"
#import "JcLiveHotModel.h"
#import "JcRefresh.h"
#import "UIScrollView+JcRefresh.h"
#import "UIScrollView+JcEmptyData.h"
#import "DatabaseManager.h"
@interface JcFavoritesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;

@property(nonatomic, strong) NSMutableArray *lives;



@end

@implementation JcFavoritesViewController

static NSString *const ID = @"ID";

- (NSMutableArray *)lives
{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}
-(UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 440;
        _tableview.contentInset = UIEdgeInsetsMake(0, 0, 46+ 20, 0);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableview];
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([JcLivehotTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    MJWeakSelf
    [self.tableview setRefreshWithHeaderBlock:^{
        [weakSelf SetupNetWork];
        
    } footerBlock:^{
        [weakSelf SetupNetWork];
    }];
    [self.tableview headerBeginRefreshing];


}
-(void)err{
    [JcMessageHelper showError:self.view text:@"暂时没有更多最新数据"];
    [self.tableview.mj_footer endRefreshingWithNoMoreData];
}
-(void)SetupNetWork{

    self.tableview.scrollEnabled = NO;
    [self.lives removeAllObjects];
    NSArray *dataArr =  [[DatabaseManager shareDatabaseManager]selectALL:[JcLiveHotModel class] tableName:DB_TABLE_NAME];
    NSArray *result = [JcLiveHotModel mj_objectArrayWithKeyValuesArray:dataArr];
    
    if ([jcSingleTool isNotEmptyArray:result]) {
        //有数据
        [self.lives addObjectsFromArray:result];
    }else{
        //没数据
        [self SetupNodata];
    }
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshingWithNoMoreData];
    [self.tableview reloadData];
    self.tableview.scrollEnabled = YES;

}

-(void)SetupNodata{
    [self.tableview setupEmptyDataText:@"啥也没有啊!" verticalOffset:0 emptyImage:[UIImage imageNamed:@"comment_nodata"] tapBlock:^{
        [self SetupNetWork];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"删除%lu",(unsigned long)self.lives.count);
    self.tableview.mj_footer.hidden = (self.lives.count == 0);
    return self.lives.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JcLivehotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (self.lives.count) {
        JcLiveHotModel *live = self.lives[indexPath.row];
        cell.live = live;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JcLiveRoomViewController *liveVc = [[JcLiveRoomViewController alloc]init];
    JcLiveHotModel *selectModel = self.lives[indexPath.row];
    liveVc.Model = selectModel;
    [self presentViewController:liveVc animated:YES completion:nil];
//    JcooViewController *o  = [[JcooViewController alloc]init];
//    [self presentViewController:o animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JcLiveHotModel *live = self.lives[indexPath.row];
    [[DatabaseManager shareDatabaseManager]deleteTableName:DB_TABLE_NAME where:[NSString stringWithFormat:@"userId = '%@'",live.userId]];
    [self.lives removeObjectAtIndex:indexPath.row];
    [JcMessageHelper showSuccess:@"删除关注"];

    [self SetupNodata];
    [self.tableview reloadData];
    

   
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消关注";
}
@end
