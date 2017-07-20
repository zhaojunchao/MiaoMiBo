//
//  UIImageView+Jc.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "UIImageView+Jc.h"


@implementation UIImageView (Jc)


- (void)imageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{

    MJWeakSelf
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil || error != nil) {
            return;
        }
        if (cacheType == SDImageCacheTypeNone) {
            weakSelf.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.alpha = 1;
            }];
        } else {
            weakSelf.alpha = 1;
        }
    }];
}

- (void)imageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *, NSError *, NSURL *))completedBlock
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType == SDImageCacheTypeNone) {
            self.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 1;
            }];
        } else {
            self.alpha = 1;
        }
        completedBlock(image, error, imageURL);
    }];
}

- (void)imageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    [self imageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

- (void)imageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(void (^)(UIImage *, NSError *, NSURL *))completedBlock
{
    [self imageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:completedBlock];
}

- (void)setImageName:(NSString *)imageName
{
    self.image = [UIImage imageNamed:imageName];
}

- (NSString *)imageName
{
    return nil;
}
// 播放GIF
- (void)playGifAnim:(NSArray *)images
{
    if (!images.count) {
        return;
    }
    //动画图片数组
    self.animationImages = images;
    //执行一次完整动画所需的时长
    self.animationDuration = 0.5;
    //动画重复次数, 设置成0 就是无限循环
    self.animationRepeatCount = 0;
    [self startAnimating];
}
// 停止动画
- (void)stopGifAnim
{
    if (self.isAnimating) {
        [self stopAnimating];
    }
    [self removeFromSuperview];
}

@end
