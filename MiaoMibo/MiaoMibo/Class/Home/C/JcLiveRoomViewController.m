//
//  JcLiveRoomViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#define DEFAULT_MASK_ALPHA 0.9

#import "JcLiveRoomViewController.h"
#import "JcLiveHotModel.h"
#import "UIViewController+Jc.h"
#import "JcRoomBottomView.h"
#import "JcAnchorInfoView.h"
#import "UIImage+JcImage.h"
#import "JcLiveEndView.h"
#import "JcUserInfoView.h"
#import <BarrageRenderer/BarrageRenderer.h>
#import "NSSafeObject.h"
#import "JcAnimate.h"
@interface JcLiveRoomViewController ()

/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
/** 底部的工具栏 */
@property(nonatomic, weak) JcRoomBottomView *bottomToolView;
/** 顶部主播相关视图 */
@property(nonatomic, weak) JcAnchorInfoView *anchorView;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 直播结束的界面 */
@property (nonatomic, weak) JcLiveEndView *endView;
@property (nonatomic, weak) JcUserInfoView *userinfoView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;
/** 弹幕 */
@property(nonatomic, strong) BarrageRenderer *renderer;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic,assign)BOOL endViewisLoad;


@end

@implementation JcLiveRoomViewController
static NSString *const ID = @"ID";


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.player.isPlaying) {
        [self.player prepareToPlay];
        [self.player play];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.player.isPlaying) {
        [self.player pause];
    }

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.player.isPlaying) {
        [self.player pause];
        [self.player stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUi];
    [self initObserver];
}



-(void)setupUi{
    [self.view addSubview:self.player.view];
    _renderer = [[BarrageRenderer alloc] init];
    [self.view addSubview:_renderer.view];
    _renderer.canvasMargin = UIEdgeInsetsMake(ScreenH * 0.3, 10, 10, 10);
    _renderer.view.userInteractionEnabled = YES;
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    self.bottomToolView.hidden = NO;
    self.anchorView.hidden  = NO;
    self.placeHolderView.hidden = NO;
}

- (void)quit
{
    [self RemoveRenderer]; //移除弹幕
    [self RemoveEmitterLayer];//移除粒子动画
    [self RemoveAnchorView];
    [self RemoveBottomToolView];
    [self RemoveplaceHolderView];
    [self.timer invalidate];
    self.timer = nil;
    self.Model = nil;
    _renderer = nil;
    [_renderer.view removeFromSuperview];
    [self.player pause];
    [self.player stop];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    self.player = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)RemoveplaceHolderView{
    
    if (_placeHolderView) {
        [_placeHolderView removeFromSuperview];
        _placeHolderView = nil;
    }
}
-(void)RemoveAnchorView{
    if (_anchorView) {
        [_anchorView removeFromSuperview];
        _anchorView = nil;
    }
}
-(void)RemoveBottomToolView{
    if (_bottomToolView) {
        [_bottomToolView removeFromSuperview];
        _bottomToolView = nil;
    }
}
-(void)RemoveEmitterLayer{
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
}
-(void)RemoveRenderer{
    if (_renderer) {
        [_renderer pause];
        [_renderer stop];
        [_renderer.view removeFromSuperview];
        _renderer = nil;
    }
}
#pragma mark - 懒加载
- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(ScreenW -50,ScreenH -50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1.5;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 2;
            // 颜色
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 10;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.35;
            [array addObject:stepCell];
        }
        
        emitterLayer.emitterCells = array;
        [self.player.view.layer addSublayer:emitterLayer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}
- (JcLiveEndView *)endView
{
   MJWeakSelf
    if (!_endView) {
        JcLiveEndView *endView = [JcLiveEndView liveEndView];
        endView.sd_layout.leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .widthIs(ScreenW)
        .heightIs(ScreenH);
        [endView setQuitBlock:^{
            [weakSelf quit];
        }];
        _endView = endView;
    }
    return _endView;
}
-(JcUserInfoView *)userinfoView{
    if (_userinfoView == nil) {
        JcUserInfoView *userInfoView = [JcUserInfoView userInfoView];
        [self.view addSubview:userInfoView];
         userInfoView.Model = self.Model;
        userInfoView.sd_layout.centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        .widthRatioToView(self.view, 0.9)
        .heightIs(395);
        _userinfoView = userInfoView;
    }
        return _userinfoView;
}
- (UIImageView *)placeHolderView
{
    if (_placeHolderView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.player.view addSubview:imageView];
        imageView.frame = self.player.view.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView imageWithURLString:self.Model.bigpic placeholderImage:[UIImage imageNamed:@"profile_user_414x414"] completed:^(UIImage *image, NSError *error, NSURL *url) {
            imageView.image = [image blur];
        }];
        [self showGifLoding:nil inView:imageView];
        _placeHolderView = imageView;
    }
    return _placeHolderView;
}
- (JcRoomBottomView *)bottomToolView
{
    if (_bottomToolView == nil) {
        JcRoomBottomView *bottomToolView = [[JcRoomBottomView alloc] init];
        [self.view addSubview:bottomToolView];
        [bottomToolView setClickToolBlock:^(NSInteger tag,BOOL select) {
            switch (tag) {
                case 0:
                    NSLog(@"点击了消息%ld",(long)tag);
                    break;
                case 1:
                    NSLog(@"点击了弹幕%ld",(long)tag);
                    select ? [_renderer start]: [_renderer stop];
                    break;
                case 2:
                    NSLog(@"点击了礼物%ld,%d",(long)tag,select);
                    break;
                case 3:
                    NSLog(@"点击了排行%ld,%d",(long)tag,select);
                    self.emitterLayer.hidden = !select;
                    if (self.emitterLayer.hidden) {
                        [self RemoveEmitterLayer];
                    }
                    break;
                case 4:
                    NSLog(@"点击了分享%ld",(long)tag);
                    break;
                case 5:
                    NSLog(@"点击了退出%ld",(long)tag);
                    [self quit];
                    break;
                default:
                    break;
            }
        }];
        bottomToolView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 10)
        .heightIs(40);
        _bottomToolView = bottomToolView;
    }
    return _bottomToolView;
}
- (JcAnchorInfoView *)anchorView
{
    if (_anchorView == nil) {
        JcAnchorInfoView *anchorView = [JcAnchorInfoView anchorInfoView];
        [self.view addSubview:anchorView];
        anchorView.LiveModel = self.Model;
        anchorView.sd_layout.leftSpaceToView(self.view, 15)
        .rightSpaceToView(self.view, 15)
        .heightIs(60)
        .topSpaceToView(self.view, 20);
        _anchorView = anchorView;
                MJWeakSelf;
        _anchorView.selectBlock = ^() {
                weakSelf.userinfoView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                [UIView animateWithDuration:0.7 animations:^{
                    weakSelf.userinfoView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:nil];
        };
    }
    return _anchorView;
}

- (IJKFFMoviePlayerController *)player
{
    if (!_player)
    {
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        //开启硬件解码
        //   [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
        //
        [options setPlayerOptionIntValue:512 forKey:@"vol"];
        //        // 最大fps
        [options setPlayerOptionIntValue:29.97 forKey:@"max-fps"];
        //        // 重连次数
        [options setFormatOptionIntValue:1 forKey:@"reconnect"];
        //        超时时间
        [options setFormatOptionIntValue:30 * 1000 * 1000 forKey:@"timeout"];
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.Model.flv withOptions:options];
        // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
        //        _player.shouldAutoplay = NO;
        _player.view.frame = [UIScreen mainScreen].bounds;
        _player.scalingMode = IJKMPMovieScalingModeFill;
        [_player prepareToPlay];
        
    }
    return _player;
}

#pragma mark - 通知
- (void)initObserver
{
    [self.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];
}
//typedef NS_ENUM(NSInteger, MPMoviePlaybackState) {
//    MPMoviePlaybackStateStopped,//停止播放
//    MPMoviePlaybackStatePlaying,//正在播放
//    MPMoviePlaybackStatePaused,//暂停播放
//    MPMoviePlaybackStateInterrupted,//中断播放
//    MPMoviePlaybackStateSeekingForward,//快进
//    MPMoviePlaybackStateSeekingBackward//快退
//};
//typedef NS_OPTIONS(NSUInteger, MPMovieLoadState) {
//    MPMovieLoadStateUnknown        = 0,//状态未知
//    MPMovieLoadStatePlayable       = 1 << 0,//缓存数据足够开始播放，但是视频并没有缓存完全
//    MPMovieLoadStatePlaythroughOK  = 1 << 1, //已经缓存完成，如果设置了自动播放，这时会自动播放
//    MPMovieLoadStateStalled        = 1 << 2, //数据缓存已经停止，播放将暂停
//};
- (void)didFinish:(NSNotification *) notification{
    NSLog(@"完成状态loadState% ldplaybackState%ld", self.player.loadState, self.player.playbackState);
    // 如果是网速或其他原因导致直播stop了，也要显示gif
    if (self.player.loadState & IJKMPMovieLoadStateStalled && !self.gifView) {
        [self showGifLoding:nil inView:self.player.view];
        return;
    }
//          1、重新获取直播地址，服务端控制是否有地址返回。
//          2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    [[JcNetWorkTool shareTool]GET:self.Model.flv parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功%@, 等待继续播放", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
                [JcMessageHelper showError:@"主播已下线"];
                [self.player shutdown];
                [self.player.view removeFromSuperview];
                self.player = nil;
                [_bottomToolView removeFromSuperview];
                [_anchorView removeFromSuperview];
                [self.view addSubview:self.endView];
                _endViewisLoad = YES;
            return;
        }
        
    }];
}

- (void)stateDidChange:(NSNotification *)notification {
    NSLog(@"加载状态...%ld %ld", self.player.loadState, self.player.playbackState);
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.player.isPlaying) {
            [self hideGufLoding];
            [self.player play];
        }else{
            if (self.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_placeHolderView) {
                        [_placeHolderView removeFromSuperview];
                        _placeHolderView = nil;
                    }
                    [self hideGufLoding];
                });
            }
        }
    }else if (self.player.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        [self showGifLoding:nil inView:self.player.view];
       
    }
}
- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}
#pragma mark - 弹幕描述符生产方法
long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        [JcMessageView.sharedInstance ShowMessage:@"给你点个赞👍👍👍"];
    };
    return descriptor;
}

- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    if (_endViewisLoad) {
        return;
    }
    [self.bottomToolView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 5) {
            [JcAnimate showMoreLoveAnimateFromView:obj addToView:self.view];
            *stop = YES;
        }
    }];
}
-(void)dealloc{
    NSLog(@"释放了%@",self.Model);
}
@end
