//
//  UIScrollView+JcEmptyData.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/30.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

typedef void(^ClickBlock)();

@interface UIScrollView (JcEmptyData)<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**点击事件*/
@property (nonatomic,copy) ClickBlock clickBlock;
/**垂直偏移量*/
@property (nonatomic, assign) CGFloat offset;
/**控件间距*/
@property (nonatomic, assign) CGFloat Margin;
/**空数据显示内容*/
@property (nonatomic, strong) NSString *emptyText;
/**空数据的图片*/
@property (nonatomic, strong) UIImage *emptyImage;


/**空数据*/
- (void)setupEmptyData:(ClickBlock)clickBlock;
/**空数据文字*/
- (void)setupEmptyDataText:(NSString *)text tapBlock:(ClickBlock)clickBlock;
/**空数据文字和垂直偏移*/
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset tapBlock:(ClickBlock)clickBlock;
/**空数据的图片和文字和垂直偏移*/
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock;
/**空数据的图片和文字和垂直偏移间距*/
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image Margin:(CGFloat)Margin tapBlock:(ClickBlock)clickBlock;

@end
