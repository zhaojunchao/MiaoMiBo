//
//  MainViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/26.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "MainViewController.h"
#import "MainNaViewController.h"
#import "HomeViewController.h"
#import "PlayLiveViewController.h"
#import "MyCenterViewController.h"
#import "UIDeviceHardware.h"
#import <AVFoundation/AVFoundation.h>
#import "JcRankingViewController.h"
#import "JcFavoritesViewController.h"
@interface MainViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UIButton *composeButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];

}
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
            animation.duration = 1;
            animation.calculationMode = kCAAnimationCubic;
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}
+ (void)initialize
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = KTabBarColor;
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

#pragma mark - 懒加载控件
- (UIButton *)composeButton {
    if (_composeButton == nil) {
        _composeButton = [[UIButton alloc] init];
         [_composeButton setImage:[UIImage imageNamed:@"toolbar_live"] forState:UIControlStateNormal];
        [self.tabBar addSubview:_composeButton];
        [_composeButton addTarget:self action:@selector(clickComposeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _composeButton;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setupComposeButton];
    for (UIControl *button in self.tabBar.subviews) {
        if ([button isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [button addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
- (void)clickComposeButton {
    [self playLiveClick];
}
- (void)playLiveClick
{
    if([[UIDeviceHardware platform] isEqualToString:@"iPhone Simulator"]){
         [JcMessageHelper showError:@"请用真机进行测试,此模块不支持模拟器测试"];
        return ;
    }
    
    
    //判断是否有摄像头
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [JcMessageHelper showError:@"你的设备没有摄像头不能直播"];
        return ;
    }
    
    //判断是否有摄像头权限
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted||authorizationStatus == AVAuthorizationStatusDenied) {
        [JcMessageHelper showError:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
        return ;
    }
    
    
    // 开启麦克风权限
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted){
            if (granted) {
                return YES;
            }else{
                 [JcMessageHelper showError:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                return NO;
            }
        }];
    }
    
   [self presentViewController:[[PlayLiveViewController alloc] init] animated:YES completion:nil];
}
- (void)setupComposeButton {
    CGRect rect = self.tabBar.bounds;
    CGFloat w = rect.size.width / self.childViewControllers.count - 1;
    self.composeButton.frame = CGRectInset(rect, 2 * w, 0);
}
- (void)setupBasic
{
    
    [self addChildViewController:[[HomeViewController alloc]init] notmalimageNamed:@"toolbar_home_44x44_" selectedImage:@"toolbar_home_sel_44x44_" title:@"首页"];
 
    [self addChildViewController:[[JcFavoritesViewController alloc]init] notmalimageNamed:@"toolbar_video_44x44_" selectedImage:@"toolbar_video_sel_44x44_" title:@"关注"];
    
    // 添加一个空白控制器
    [self addChildViewController:[[UIViewController alloc] init]];
    
     [self addChildViewController:[[JcRankingViewController alloc] init] notmalimageNamed:@"toolbar_rank_44x44_" selectedImage:@"toolbar_rank_sel_44x44_" title:@"排行"];
    
    MyCenterViewController *showTimeVc = [UIStoryboard storyboardWithName:@"MyCenterViewController" bundle:nil].instantiateInitialViewController;
    [self addChildViewController:showTimeVc notmalimageNamed:@"toolbar_me_44x44_" selectedImage:@"toolbar_me_sel_44x44_" title:@"我的"];

}

- (void)addChildViewController:(UIViewController *)childController notmalimageNamed:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title
{
    MainNaViewController *nav = [[MainNaViewController alloc] initWithRootViewController:childController];
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childController.title = title;
    [self addChildViewController:nav];
}

@end
