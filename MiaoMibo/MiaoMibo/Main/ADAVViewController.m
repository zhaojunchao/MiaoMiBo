//
//  ADAVViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/22.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "ADAVViewController.h"
#import "UIButton+WHButton.h"
#import "MainViewController.h"
#import "JcShapeButton.h"
@interface ADAVViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong)IJKFFMoviePlayerController *player;
@property (nonatomic, weak) JcShapeButton *loginBtn;
@property (nonatomic, weak) UIImageView *coverView;
@end

@implementation ADAVViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.player  play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player shutdown];

}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.player.view removeFromSuperview];
    self.player =nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self coverView];
    [self notificationOfPlayer];

}
- (void)notificationOfPlayer
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)stateDidChange
{
        __weak typeof(self) weakSelf = self;
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.player.isPlaying) {
            
            [self.view insertSubview:self.coverView atIndex:0];
            [self.player play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 weakSelf.loginBtn.hidden = NO;
            });
        }
    }
}

- (void)didFinish
{
    [self.player play];
}
//- (void)didPresentControllerButtonTouch
//{
//    
//    MainViewController  *controller = [[MainViewController alloc]init];
//    controller.transitioningDelegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
//                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    
//    return [[JcTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:true];
//}
//
//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//    
//    return [[JcTransitions alloc]initWithTransitionDuration:0.4f StartingAlpha:0.5f isBOOL:false];
//}
//
//-(void)jump{
//    
//        [_loginBtn JcBeganToCircleAnimation:^{
//            [self.player stop];
//            [self didPresentControllerButtonTouch];
//        
//        }];
//    
//
//        
//}
-(void)PresentViewController:(JcShapeButton *)button{
    
    MJWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        MainViewController  *controller = [[MainViewController alloc]init];
        [weakSelf presentViewController:controller animated:NO completion:^{
            [self.player stop];
        }];
    });
   


    
}
- (JcShapeButton *)loginBtn
{
    if (_loginBtn == nil){
        JcShapeButton *log = [[JcShapeButton alloc] initWithFrame:CGRectMake(self.view.centerX, ScreenH - 70, ScreenW *0.55, 35)];
        [log setBackgroundColor:RGB(214, 41, 117)];
        [log setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [log setTitle:@"立即体验" forState:UIControlStateNormal];
        [log addTarget:self action:@selector(PresentViewController:) forControlEvents:UIControlEventTouchUpInside];
         [self.view addSubview:log];
        log.sd_layout.centerXEqualToView(self.view);
        _loginBtn = log;
    }
    return _loginBtn;
}

- (IJKFFMoviePlayerController *)player
{
    if (_player == nil){
        
        NSString *path = arc4random_uniform(2) ? @"login_video" : @"loginmovie";
        
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:[[NSBundle mainBundle] pathForResource:path ofType:@"mp4"] withOptions:[IJKFFOptions optionsByDefault]];
        
        _player.view.frame = self.view.bounds;
        _player.scalingMode = IJKMPMovieScalingModeAspectFill;
        _player.shouldAutoplay = NO;
        [_player prepareToPlay];
        
        [self.view addSubview:_player.view];
        
    }
    
    return _player;
}
- (UIImageView *)coverView
{
    if (_coverView == nil) {
        UIImageView *cover = [[UIImageView alloc] initWithFrame:self.view.bounds];
        cover.image = [UIImage imageNamed:@"LaunchImage"];
        [self.player.view addSubview:cover];
        _coverView = cover;
    }
    return _coverView;
}
@end
