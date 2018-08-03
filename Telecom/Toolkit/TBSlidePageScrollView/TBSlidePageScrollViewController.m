//
//  TBSlidePageScrollViewController.m
//  Telecom
//
//  Created by 小腊 on 17/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import "TBSlidePageScrollViewController.h"

@interface TBSlidePageScrollViewController ()
@property (nonatomic, weak) TBSlidePageScrollView *slidePageScrollView;
@end

@implementation TBSlidePageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSlidePageScrollView];
    
    [self layoutSlidePageScrollView];
}

- (void)addSlidePageScrollView
{
    TBSlidePageScrollView *slidePageScrollView = [[TBSlidePageScrollView alloc]initWithFrame:self.view.bounds];
    slidePageScrollView.dataSource = self;
    slidePageScrollView.delegate = self;
    [self.view addSubview:slidePageScrollView];
    _slidePageScrollView = slidePageScrollView;
}

- (void)layoutSlidePageScrollView
{
    _slidePageScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_slidePageScrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_slidePageScrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_slidePageScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_slidePageScrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

#pragma mark - TYSlidePageScrollViewDataSource


- (NSInteger)numberOfPageViewOnSlidePageScrollView
{
    return _viewControllers.count;
}

- (UIScrollView *)slidePageScrollView:(TBSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index
{
    UIViewController<TBDisplayPageScrollViewDelegate> *viewController = _viewControllers[index];

    if (![self.childViewControllers containsObject:viewController]) {
        // don't forget set frame and addChildViewController
        viewController.view.frame = self.view.frame;
        [self addChildViewController:viewController];
    }
    
    if ([viewController respondsToSelector:@selector(displayPageScrollView)]) {
        return [viewController displayPageScrollView];
    }else if([viewController isKindOfClass:[UITableViewController class]]){
        return ((UITableViewController *)viewController).tableView;
    }else if ([viewController isKindOfClass:[UICollectionViewController class]]){
        return ((UICollectionViewController *)viewController).collectionView;
    }else if ([viewController.view isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)viewController.view;
    }

    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
