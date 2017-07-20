//
//  UIImageView+Jc.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Jc)
@property (nonatomic, copy) NSString *imageName;

- (void)imageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)imageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(UIImage *image, NSError *error, NSURL *url))completedBlock;

- (void)imageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder;

- (void)imageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(UIImage *image, NSError *error, NSURL *url))completedBlock;

// 播放GIF
- (void)playGifAnim:(NSArray *)images;
// 停止动画
- (void)stopGifAnim;



@end
