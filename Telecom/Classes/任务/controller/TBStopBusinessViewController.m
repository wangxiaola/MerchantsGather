//
//  TBStopBusinessViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/7/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

/**
 营业状态

 - BusinessStateStop: 暂停
 - BusinessStatePermanent: 永久
 */
typedef NS_ENUM(NSInteger, BusinessState) {

    BusinessStateStop = 0,
    BusinessStatePermanent
};
#import "TBStopBusinessViewController.h"
#import "TBGroupPhotoChooseView.h"
#import "IQTextView.h"
#import "TBTaskListMode.h"
@interface TBStopBusinessViewController ()

@property (weak, nonatomic) IBOutlet TBGroupPhotoChooseView *photoChooseView;
@property (weak, nonatomic) IBOutlet IQTextView *rulesTextView;

@property (weak, nonatomic) IBOutlet UIButton *stopBusinessButton;

@property (weak, nonatomic) IBOutlet UIButton *permanentBusinessButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoChooseHeight;

@property (nonatomic) BusinessState businessState;
@end

@implementation TBStopBusinessViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.rulesTextView resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"停止营业申请";
    [self setupViews];
}
#pragma mark  ----界面布局----
- (void)setupViews
{
    [self.photoChooseView updataCollectionView];
    TBWeakSelf
    //照片选择事件
    self.photoChooseView.backgroundColor = [UIColor whiteColor];
    self.photoChooseView.collectionView.backgroundColor = [UIColor whiteColor];
    [self.photoChooseView setUpdataPhotoViewHeight:^(CGFloat height){
        
        weakSelf.photoChooseHeight.constant = height;
    }];
}
#pragma mark  ----按钮点击事件----
- (IBAction)resetClick:(UIButton *)sender
{

}
- (IBAction)submitClick:(UIButton *)sender
{

}
- (IBAction)stopBusiness:(UIButton *)sender
{
    self.businessState = BusinessStateStop;
    self.permanentBusinessButton.selected = sender.selected;
    self.stopBusinessButton.selected = !sender.selected;

}
- (IBAction)permanentBusiness:(UIButton *)sender
{
    self.businessState = BusinessStatePermanent;
    self.stopBusinessButton.selected = sender.selected;
    self.permanentBusinessButton.selected = !sender.selected;
}
#pragma mark  ----逻辑处理----



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
