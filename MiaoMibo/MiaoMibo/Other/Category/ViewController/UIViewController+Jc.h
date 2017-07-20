//
//  UIViewController+Jc.h
//  MiaoMibo
//
//  Created by zjc on 2017/7/3.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Jc)
/** Gif加载状态 */
@property(nonatomic, weak) UIImageView *gifView;

/**
 *  显示GIF加载动画
 *
 *  @param images gif图片数组, 不传的话默认是自带的
 *  @param view   显示在哪个view上, 如果不传默认就是self.view
 */
- (void)showGifLoding:(NSArray *)images inView:(UIView *)view;

/**
 *  取消GIF加载动画
 */
- (void)hideGufLoding;
@end
