//
//  TBAppearanceTemplateTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBAppearanceTemplateTableViewCell.h"
#import "YPTabBar.h"

@interface TBAppearanceTemplateTableViewCell()<YPTabBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *templateImageView;
@property (nonatomic, strong) YPTabBar *tabBarView;
@end

@implementation TBAppearanceTemplateTableViewCell
{
    __weak IBOutlet NSLayoutConstraint *imageViewWidth;
    __weak IBOutlet NSLayoutConstraint *imageViewHeight;
    
    __weak IBOutlet UIView             *sliderView;
    NSArray                            *_imageArray;
    BOOL                               _isClick;// 防止多次调用block
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    imageViewWidth.constant = _SCREEN_WIDTH*0.7;
    imageViewHeight.constant  = 1200*imageViewWidth.constant/750;
    
    self.tabBarView = [[YPTabBar alloc] initWithFrame:CGRectMake(0, (sliderView.frame.size.height-26)/2, _SCREEN_WIDTH, 26)];
    self.tabBarView.delegate = self;
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    self.tabBarView.itemSelectedBgColor = [UIColor orangeColor];
    self.tabBarView.itemTitleColor = [UIColor grayColor];
    self.tabBarView.itemTitleSelectedColor = [UIColor whiteColor];
    self.tabBarView.itemTitleFont = [UIFont systemFontOfSize:13];
    self.tabBarView.itemTitleSelectedFont = [UIFont systemFontOfSize:13];
    self.tabBarView.leftAndRightSpacing = 20;
    self.tabBarView.itemSelectedBgCornerRadius = self.tabBarView.frame.size.height/2;
    [self.tabBarView setScrollEnabledAndItemFitTextWidthWithSpacing:14];
    [self.tabBarView setTitles:@[@" 模板一 ",@" 模板二 ",@" 模板三 ",@" 模板四 "]];
    self.tabBarView.selectedItemIndex = 0;
    [sliderView addSubview:self.tabBarView];
    
    _isClick = YES;
    _imageArray = @[@"folkTemplates_01.png",
                    @"folkTemplates_02.png",
                    @"folkTemplates_03.png",
                    @"folkTemplates_04.png"];

}
#pragma mark  ----YPTabBarDelegate----
/**
 *  是否能切换到指定index
 */
- (BOOL)yp_tabBar:(YPTabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index;
{
    return YES;
}
/**
 *  将要切换到指定index
 */
- (void)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index;
{
    
}
/**
 *  已经切换到指定index
 */
- (void)yp_tabBar:(YPTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index;
{
    
    [self updateImageViewIndex:index];
    if (self.templateChooseUpdate && _isClick == YES)
    {
        self.templateChooseUpdate(index);
    }

}

/**
 更新图片
 
 @param index 第几个模板
 */
- (void)updateTemplateImageIndex:(NSInteger)index;
{
   _isClick = NO;
   [self updateImageViewIndex:index];
    self.tabBarView.selectedItemIndex = index;
   _isClick = YES;
}
#pragma mark  ----图片更新动画----
- (void)updateImageViewIndex:(NSInteger)index
{
    if (index < _imageArray.count)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 水波动画
            CATransition *transition = [CATransition animation];
            transition.duration = 0.7;
            //设置运动type
            transition.type = @"rippleEffect";
            //设置子类
            transition.subtype = @"rippleEffect";
            
            [self.templateImageView.layer addAnimation:transition forKey:@"animation"];
            NSString  *imageName = _imageArray[index];
            [self.templateImageView setImage:[UIImage imageNamed:imageName]];
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
