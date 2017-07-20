//
//  JcHotRoomViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/7/6.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcHotRoomViewController.h"
#import "JcLivehotTableViewCell.h"
#import "JcLiveHotModel.h"
#import "JcRefresh.h"
#import "JcLiveRoomViewController.h"
#import "UIScrollView+JcRefresh.h"
#import "UIScrollView+JcEmptyData.h"
@interface JcHotRoomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** 直播 */
@property(nonatomic, strong) NSMutableArray *lives;

@end

@implementation JcHotRoomViewController

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
        _tableview.contentInset = UIEdgeInsetsMake(0, 0,NavigationBarH + TabBarH + 46 + 20, 0);
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
        weakSelf.currentPage = 1;
        [weakSelf SetupNetWork];
        
    } footerBlock:^{
        weakSelf.currentPage++;
        [weakSelf SetupNetWork];
    }];
    [self.tableview headerBeginRefreshing];
    
    
}

// http://live.9158.com/Room/GetNewRoomOnline?page=1 最新
//http://live.9158.com/Room/GetHotLive_v2?cache=1&page=1&type=8&useridx=65952190 海外 8
//签约 9
//同城 2
//    http://live.9158.com/Room/GetHotLive_v2?cache=1&lat=30.26647308164829&lon=119.9573422224254&page=1&province=%25E6%25B5%2599%25E6%25B1%259F%25E7%259C%2581&type=1&useridx=65952190

//    http://live.9158.com/Room/GetHotLive_v2?cache=1&page=1&type=3&useridx=65952190


-(void)err{
    [JcMessageHelper showError:self.view text:@"暂时没有更多最新数据"];
    [self.tableview.mj_footer endRefreshingWithNoMoreData];
    self.currentPage--;
}
-(void)SetupNetWork{

    //数组有值时候没数据
    //数组没值没数据
    //有数据
    self.tableview.scrollEnabled = NO;
    [[JcNetWorkTool shareTool] GET:[self loadLiveURLStr] parameters:[self loadLiveParameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tableview.scrollEnabled  = YES;
        NSLog(@"发送请求%@===和参数%@",[self loadLiveURLStr],[self loadLiveParameters]);
        NSLog(@"数据返回%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue] == 106) {
            //  msg = "No data";
            [self err];
            [self SetupNodata];
            [self.tableview reloadData];
            return ;
        }
        NSArray *result = [JcLiveHotModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if ([jcSingleTool isNotEmptyArray:result]) {
            [self.lives addObjectsFromArray:result];
        }else{
            [self err];
        }
        [self.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.tableview.scrollEnabled  = YES;
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        self.currentPage--;
        [self SetupNodata];
        [self.tableview reloadData];
        [JcMessageHelper showError:self.view text:@"网络异常"];
    }];
}

-(void)SetupNodata{
    [self.tableview setupEmptyDataText:@"啥也没有啊!" verticalOffset:0 emptyImage:[UIImage imageNamed:@"comment_nodata"] tapBlock:^{
        [self SetupNetWork];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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

}
// http://live.9158.com/Room/GetNewRoomOnline?page=1 最新
//http://live.9158.com/Room/GetHotLive_v2?cache=1&page=1&type=8&useridx=65952190 海外 8
//签约 9
//同城 2
//    http://live.9158.com/Room/GetHotLive_v2?cache=1&lat=30.26647308164829&lon=119.9573422224254&page=1&province=%25E6%25B5%2599%25E6%25B1%259F%25E7%259C%2581&type=1&useridx=65952190
- (NSString *)loadLiveURLStr {
    NSString *urlStr;
    if (self.liveType == JcHomeLiveTypeHot) {
        urlStr = [NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage];
    } else {
        urlStr = [JcBaseURLStr stringByAppendingPathComponent:@"Room/GetHotLive_v2"];
    }
    return urlStr;
}

- (NSMutableDictionary *)loadLiveParameters{
    if (self.liveType == 1) {
        return nil;
    }else{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"page"] = @(self.currentPage);
        parameters[@"useridx"] = @65952190;
        parameters[@"type"] = @(self.liveType);
        parameters[@"province"] = @"%E6%B5%99%E6%B1%9F%E7%9C%81"; // 此字段为省份浙江省
        parameters[@"lon"] = @119.95734222242542; // 此字段为经度
        parameters[@"lat"] = @30.26647308164829; // 此字段为纬度
        parameters[@"cache"] = @1;
        return parameters;
    }
}
- (JcHomeLiveType)liveType {
    return 1;
}
@end
