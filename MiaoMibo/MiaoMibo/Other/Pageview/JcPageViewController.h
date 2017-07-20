//
//  JcPageViewController.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/28.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JcPageHorizonalCollectionViewController.h"
@interface TitleBarView : UIScrollView

/**标题数组*/
@property (nonatomic, strong) NSMutableArray *titleButtons;
/**下划线*/
@property (nonatomic, strong) UILabel *navLabel,*linelabel;
/**当前页*/
@property (nonatomic, assign) NSUInteger currentIndex;
/**标题点击*/
@property (nonatomic, copy) void (^titleButtonClicked)(NSUInteger index);

@end


@interface JcPageViewController : UIViewController
@property (nonatomic, strong) JcPageHorizonalCollectionViewController *pageVc;
@property (nonatomic, strong) TitleBarView *titleBar;
/**初始化*/
- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers andBtnTitleColor:(UIColor *)TitleColor andSeleteBtnColor:(UIColor *)SeleteBtnColor andBottomLineColor:(UIColor *)BottomLineColor;
@end
