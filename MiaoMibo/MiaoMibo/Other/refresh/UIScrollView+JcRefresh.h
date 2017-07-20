//
//  UIScrollView+JcRefresh.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/29.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RefreshingBlock)();

@interface UIScrollView (JcRefresh)
- (void)setRefreshWithHeaderBlock:(RefreshingBlock)headerBlock
                      footerBlock:(RefreshingBlock)footerBlock;


- (void)headerBeginRefreshing;
- (void)headerEndRefreshing;
- (void)footerEndRefreshing;
- (void)footerNoMoreData;

- (void)hideHeaderRefresh;
- (void)hideFooterRefresh;
@end
