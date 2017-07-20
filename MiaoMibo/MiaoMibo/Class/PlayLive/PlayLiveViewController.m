//
//  PlayLiveViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/26.
//  Copyright © 2017年 zjc. All rights reserved.
//
 
#import "PlayLiveViewController.h"
#import "UIDeviceHardware.h"
#import <LFLiveKit/LFLiveKit.h>
#import "UIView+JcRadius.h"
@interface PlayLiveViewController ()<LFLiveSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *beautiful;

@property (weak, nonatomic) IBOutlet UIButton *livingBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)beautifulBtn:(UIButton *)sender;
- (IBAction)switchBtn:(UIButton *)sender;
- (IBAction)close;
- (IBAction)beginLive;
/** RTMP地址 */
@property (nonatomic, copy) NSString *rtmpUrl;
@property (nonatomic, strong) LFLiveSession *session;
@property (nonatomic, weak) UIView *livingPreView;
@end

@implementation PlayLiveViewController

- (UIView *)livingPreView
{
    if (_livingPreView == nil) {
        UIView *livingPreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        livingPreView.backgroundColor = [UIColor clearColor];
        [self.view insertSubview:livingPreView atIndex:0];
        _livingPreView = livingPreView;
    }
    return _livingPreView;
}

- (LFLiveSession *)session
{
    if (_session == nil){
          _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High3]];
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingPreView;
        
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasic];
}

- (void)setupBasic
{
    [self.beautiful Jc_setAllCornerWithCornerRadius:15];
    [self.livingBtn Jc_setAllCornerWithCornerRadius:20];
    self.session.captureDevicePosition = AVCaptureDevicePositionFront;
}


- (IBAction)beautifulBtn:(UIButton *)sender {
    
    if (![self beginClick]) return;
    sender.selected = !sender.selected;
    // 开启了美颜
    self.session.beautyFace = !self.session.beautyFace;
    self.session.beautyLevel = 1.0;
}

- (IBAction)switchBtn:(UIButton *)sender {
    if (![self beginClick]) return;
    sender.selected = !sender.selected;
    self.session.captureDevicePosition = sender.selected?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
}


- (IBAction)close {
    
    if (self.session.state == LFLivePending || self.session.state == LFLiveStart){
        [self.session stopLive];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)beginLive {
    
    if (![self beginClick]) return;
    
    self.livingBtn.selected = !self.livingBtn.selected;
    if (self.livingBtn.selected) { 
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        // 记得填写你电脑的IP地址
        stream.url = @"rtmp://192.168.10.76:1935/rtmplive/room";
        self.rtmpUrl = stream.url;
        [self.session startLive:stream];
    }else{ // 结束直播
        [self.session stopLive];
        self.statusLabel.text = [NSString stringWithFormat:@"状态: 直播被关闭\nRTMP: %@", self.rtmpUrl];
    }
    
}

#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"状态: %@\nRTMP: %@", tempStatus, self.rtmpUrl];
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}

- (BOOL)beginClick
{
    // 判断是否是模拟器
    
    if ([[UIDeviceHardware platformString] isEqualToString:@"iPhone Simulator"]) {
         [JcMessageHelper showError:@"请用真机进行测试, 此模块不支持模拟器测试"];
        return NO;
    }
    
    // 判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
         [JcMessageHelper showError:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
        return NO;
    }
    
    // 判断是否有摄像头权限
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        
        [JcMessageHelper showError:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
        return NO;
    }
    
    // 开启麦克风权限
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                return YES;
            }
            else {
                [JcMessageHelper showError:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                return NO;
            }
        }];
    }
    
    return YES;
}

@end

