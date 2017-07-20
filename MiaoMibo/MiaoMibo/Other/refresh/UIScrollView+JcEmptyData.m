//
//  UIScrollView+JcEmptyData.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/30.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "UIScrollView+JcEmptyData.h"
#import <objc/runtime.h>

static const void *KClickBlock = @"clickBlock";
static const void *KEmptyText = @"emptyText";
static const void *KOffSet = @"offset";
static const void *Kimage = @"emptyImage";
static const void *KMargin = @"Margin";

@implementation UIScrollView (JcEmptyData)
#pragma mark - Getter Setter

- (ClickBlock)clickBlock{
    return objc_getAssociatedObject(self, &KClickBlock);
}

- (void)setClickBlock:(ClickBlock)clickBlock{
    
    objc_setAssociatedObject(self, &KClickBlock, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyText{
    return objc_getAssociatedObject(self, &KEmptyText);
}

- (void)setEmptyText:(NSString *)emptyText{
    objc_setAssociatedObject(self, &KEmptyText, emptyText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (CGFloat)offset{
    
    NSNumber *number = objc_getAssociatedObject(self, &KOffSet);
    return number.floatValue;
}

- (void)setOffset:(CGFloat)offset{
    
    NSNumber *number = [NSNumber numberWithDouble:offset];
    
    objc_setAssociatedObject(self, &KOffSet, number, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)Margin{
    
    NSNumber *number = objc_getAssociatedObject(self, &KMargin);
    return number.floatValue;
}
-(void)setMargin:(CGFloat)Margin{
    NSNumber *number = [NSNumber numberWithDouble:Margin];
    
    objc_setAssociatedObject(self, &KMargin, number, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIImage *)emptyImage{
    return objc_getAssociatedObject(self, &Kimage);
}

- (void)setEmptyImage:(UIImage *)emptyImage{
    objc_setAssociatedObject(self, &Kimage, emptyImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



- (void)setupEmptyData:(ClickBlock)clickBlock{
    self.clickBlock = clickBlock;
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


- (void)setupEmptyDataText:(NSString *)text tapBlock:(ClickBlock)clickBlock{
    
    self.clickBlock = clickBlock;
    self.emptyText = text;
    
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset tapBlock:(ClickBlock)clickBlock{
    
    self.emptyText = text;
    self.offset = offset;
    self.clickBlock = clickBlock;
    
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock{
    
    self.emptyText = text;
    self.offset = offset;
    self.emptyImage = image;
    self.clickBlock = clickBlock;
    
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image Margin:(CGFloat)Margin tapBlock:(ClickBlock)clickBlock{
    self.emptyText = text;
    self.offset = offset;
    self.emptyImage = image;
    self.Margin = Margin;
    self.clickBlock = clickBlock;
        self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}



#pragma mark - DZNEmptyDataSetSource
// 空白界面的标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = self.emptyText?:@"暂无数据";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 5;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 空白页的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return self.emptyImage?:[UIImage imageNamed:@"comment_nodata"];
}

//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
//是否允许点击，默认YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}
// 垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.offset;
}
//组件上下间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return self.Margin;
}

#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end
