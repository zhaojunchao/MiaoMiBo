//
//  JcPageHorizonalCollectionViewController.h
//  MiaoMibo
//
//  Created by zjc on 2017/6/28.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JcPageHorizonalCollectionViewController : UICollectionViewController
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, copy) void (^changeIndex)(NSUInteger index);
@property (nonatomic, copy) void (^viewDidScroll)();

- (instancetype)initWithViewControllers:(NSArray *)controllers;

- (void)scrollToViewAtIndex:(NSUInteger)index;
@end
