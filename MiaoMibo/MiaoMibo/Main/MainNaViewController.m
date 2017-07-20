//
//  MainNaViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/26.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "MainNaViewController.h"

@interface MainNaViewController ()

@end

@implementation MainNaViewController


+(void)initialize{
    UINavigationBar *Bar = [UINavigationBar appearance];
    [Bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
}


//重写push方法，给子控制器自定义返回按钮并隐藏底部bar
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //push后，如果子控件存在隐藏底部Bar导航栏
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //自定义返回按钮
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"back_9x16"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        //如果自定义返回按钮后，滑动返回可能失效，需添加以下代码
        __weak typeof(viewController)Weakself =  viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
    }
    
    [super pushViewController:viewController animated:animated];
    
    
    
}

//判断返回后的界面是dismiss，还是push
-(void)back{
    if ((self.presentedViewController || self.presentingViewController)&& self.childViewControllers.count == 1){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self popViewControllerAnimated:YES];
    }
}
@end
