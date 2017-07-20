//
//  JcPageHorizonalCollectionViewController.m
//  MiaoMibo
//
//  Created by zjc on 2017/6/28.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcPageHorizonalCollectionViewController.h"

@interface JcPageHorizonalCollectionViewController ()

@end

@implementation JcPageHorizonalCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithViewControllers:(NSArray *)controllers
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 0;

    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _controllers = [NSMutableArray arrayWithArray:controllers];
        for (UIViewController *controller in controllers) {
            [self addChildViewController:controller];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.frame.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _controllers.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIViewController  *indexController = _controllers[indexPath.row];
    indexController.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:indexController.view];
    return cell;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollStop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_viewDidScroll) {
        _viewDidScroll();
    }
    if (_changeIndex) {
        _changeIndex([self indexpage]);
    }
}

- (void)scrollToViewAtIndex:(NSUInteger)index
{
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    _currentIndex = index;
}

- (void)scrollStop:(BOOL)didScrollStop
{

    if (didScrollStop) {
        _currentIndex = [self indexpage];
        if (_changeIndex) {_changeIndex([self indexpage]);}
    }
}

-(NSUInteger)indexpage{
    CGFloat horizonalOffset = self.collectionView.contentOffset.x;
    CGFloat screenWidth = self.collectionView.frame.size.width;
    return (horizonalOffset + screenWidth / 2) / screenWidth;
}
@end
