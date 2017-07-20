//
//  HomeViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/26.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "HomeViewController.h"
#import "ZJScrollPageView.h"
#import "JcHotRoomViewController.h"
#import "JcNewRoomViewController.h"
#import "JcCityRoomViewController.h"
#import "JcSignRoomViewController.h"
#import "JcforeignCountryViewController.h"
@interface HomeViewController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showLine = YES;
    style.gradualChangeTitleColor = YES;
    style.autoAdjustTitlesWidth = YES;
    style.contentViewBounces = NO;
    style.scrollLineColor = KeyColor;
    style.normalTitleColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170/255.0 alpha:1.0];
    style.selectedTitleColor = KeyColor;
    self.titles = @[@"热门",@"红人",@"同城",@"签约",@"海外"];
    _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    [self.view addSubview:_scrollPageView];
}
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    if (index == 0) {

        JcHotRoomViewController *childVc = (JcHotRoomViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[JcHotRoomViewController alloc] init];
        }
        return childVc;
    } else if (index == 1) {
        JcNewRoomViewController *childVc = (JcNewRoomViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[JcNewRoomViewController alloc] init];
        }
        
        return childVc;
    } else if (index == 2) {
        JcCityRoomViewController *childVc = (JcCityRoomViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[JcCityRoomViewController alloc] init];
        }
        
        return childVc;
    }
    else if (index == 3) {
        JcSignRoomViewController *childVc = (JcSignRoomViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[JcSignRoomViewController alloc] init];
        }
        
        return childVc;
    }
    else {
        JcforeignCountryViewController *childVc = (JcforeignCountryViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[JcforeignCountryViewController alloc] init];
        }
        
        return childVc;
    }
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}
@end
