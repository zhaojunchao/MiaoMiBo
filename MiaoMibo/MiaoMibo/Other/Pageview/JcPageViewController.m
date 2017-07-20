//
//  JcPageViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/28.
//  Copyright © 2017年 zjc. All rights reserved.
//
#define LINE_HEIGHT 4
#define TitleBarView_HEIGHT 46

#import "JcPageViewController.h"

@implementation TitleBarView

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
             andBtnTitleColor:(UIColor *)TitleColor andSeleteBtnColor:(UIColor *)SeleteBtnColor andBottomLineColor:(UIColor *)BottomLineColor
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _currentIndex = 0;//当前页
        _titleButtons = [NSMutableArray array];
        
        CGFloat buttonWidth = frame.size.width / titles.count;
        CGFloat buttonHeight = frame.size.height;
        
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];//背景色
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:TitleColor forState:UIControlStateNormal];//未选中字体颜色
            
            
            button.frame = CGRectMake(buttonWidth * idx, 0, buttonWidth, buttonHeight);
            button.tag = idx;
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_titleButtons addObject:button];
            [self addSubview:button];
            [self sendSubviewToBack:button];
        }];

        _linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TitleBarView_HEIGHT-0.5,ScreenW, 0.5)];
        _linelabel.backgroundColor = [UIColor grayColor];
        [self addSubview:_linelabel];
        
        _navLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonWidth/4, TitleBarView_HEIGHT - LINE_HEIGHT, buttonWidth/2, LINE_HEIGHT)];
        _navLabel.backgroundColor = BottomLineColor;
        [self addSubview:_navLabel];
        
        //
        self.contentSize = CGSizeMake(frame.size.width, TitleBarView_HEIGHT);
        self.showsHorizontalScrollIndicator = NO;
        UIButton *firstTitle = _titleButtons[0];
        [firstTitle setTitleColor:SeleteBtnColor forState:UIControlStateNormal];
        firstTitle.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }
    
    return self;
}


- (void)onClick:(UIButton *)button
{
    if (_currentIndex != button.tag) {
        UIButton *preTitle = _titleButtons[_currentIndex];
        /**未选中颜色*/
        [preTitle setTitleColor:button.currentTitleColor forState:UIControlStateNormal];
        preTitle.transform = CGAffineTransformIdentity;
        
        /**选中颜色*/
        [button setTitleColor:preTitle.currentTitleColor forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
        _currentIndex = button.tag;
        _titleButtonClicked(button.tag);
        
    }
}
@end


@interface JcPageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation JcPageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
}
- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers andBtnTitleColor:(UIColor *)TitleColor andSeleteBtnColor:(UIColor *)SeleteBtnColor andBottomLineColor:(UIColor *)BottomLineColor
{
    return [self initWithTitle:title andSubTitles:subTitles andControllers:controllers underTabbar:NO andBtnTitleColor:TitleColor andSeleteBtnColor:SeleteBtnColor andBottomLineColor:BottomLineColor];
}

- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers underTabbar:(BOOL)underTabbar andBtnTitleColor:(UIColor *)TitleColor andSeleteBtnColor:(UIColor *)SeleteBtnColor andBottomLineColor:(UIColor *)BottomLineColor
{
    self = [super init];
    if (self) {
        if (underTabbar == NO) {
            self.edgesForExtendedLayout = UIRectEdgeNone;//scrollView视图不延伸整个屏幕
        }
        
        if (title) {self.title = title;}
        
        CGFloat titleBarHeight = TitleBarView_HEIGHT;
        _titleBar = [[TitleBarView alloc]initWithFrame:CGRectMake(0, 0 +(underTabbar ? 51 : 0), self.view.bounds.size.width, titleBarHeight ) andTitles:subTitles andBtnTitleColor:TitleColor andSeleteBtnColor:BottomLineColor andBottomLineColor:BottomLineColor];
        _titleBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_titleBar];
        
        
        _pageVc = [[JcPageHorizonalCollectionViewController alloc] initWithViewControllers:controllers];
        
        CGFloat height = self.view.bounds.size.height - (underTabbar ? 0 : titleBarHeight) ;
        _pageVc.view.frame = CGRectMake(0, (underTabbar ? 0 : titleBarHeight), self.view.bounds.size.width, height);
        
        [self addChildViewController:_pageVc];
        [self.view addSubview:_pageVc.view];
        [self.view sendSubviewToBack:_pageVc.view];
        
        
        
        
        
        __weak TitleBarView *weakTitleBar = _titleBar;
        __weak JcPageHorizonalCollectionViewController *weakViewPager = _pageVc;
        
        _pageVc.changeIndex = ^(NSUInteger index) {
            weakTitleBar.currentIndex = index;
            for (UIButton *button in weakTitleBar.titleButtons) {
                if (button.tag != index) {
                    [button setTitleColor:TitleColor forState:UIControlStateNormal];
                    button.transform = CGAffineTransformIdentity;
                } else {
                    [button setTitleColor:SeleteBtnColor forState:UIControlStateNormal];
                    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }
            }
            
        };
        //滑动时移动直线条
        _pageVc.viewDidScroll = ^()
        {
            CGPoint offset = weakViewPager.collectionView.contentOffset;
            CGFloat x = offset.x/weakViewPager.controllers.count;
            
            if (x > 0 && x < weakViewPager.collectionView.frame.size.width)
            {
                CGRect frame = weakTitleBar.navLabel.frame;
                frame.origin.x = x + frame.size.width/2;//修正居中显示
                weakTitleBar.navLabel.frame = frame;
            }
        };
        
        
        _titleBar.titleButtonClicked = ^(NSUInteger index) {
            [weakViewPager scrollToViewAtIndex:index];
            
        };
    }
    return self;
}


@end
