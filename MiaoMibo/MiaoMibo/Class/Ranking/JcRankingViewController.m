//
//  JcRankingViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/27.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcRankingViewController.h"
#import <WebKit/WebKit.h>
@interface JcRankingViewController ()
@property(nonatomic,strong)WKWebView *webview;
@end

@implementation JcRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TabBarH)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://live.9158.com/Rank/giftStarRank?showtype=hall&useridx=62395282&photo=http://liveimg.9158.com/default.png&Random=8"]]];
    [self.view addSubview:webView];
     self.webview = webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
