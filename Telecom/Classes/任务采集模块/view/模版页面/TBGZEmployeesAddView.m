//
//  TBGZEmployeesAddView.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGZEmployeesAddView.h"
#import "TBGZEmployeesAddViewMode.h"
#import "TBGZPeopleStatisticsViewController.h"
#import "ZKNavigationController.h"
#import "TBMoreReminderView.h"
#import "TBTagsLabelView.h"
// 选中
static NSString *const hollow_selected = @"hollow_selected";
// 未选中
static NSString *const hollow_cancel   = @"hollow_cancel";

@interface TBGZEmployeesAddView()<UIScrollViewDelegate>


@end;
@implementation TBGZEmployeesAddView
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *iDCardTextField;//身份证
    __weak IBOutlet UITextField *nameTextfield;//姓名
    __weak IBOutlet UITextField *phoneTextfield;//联系方式
    __weak IBOutlet UITextField *salaryTextfield;//薪资
    __weak IBOutlet UITextField *ageTextfield;//年龄
    __weak IBOutlet UITextField *jobsTextfield;//岗位
    __weak IBOutlet UIButton *saveButton;
    __weak IBOutlet TBTagsLabelView *tagsLabelView;//贫困集合展示view
    __weak IBOutlet UIButton *statisticalButton;
    __weak IBOutlet UIView *genderView;// 性别
    __weak IBOutlet UIView *marriageView;// 婚姻
    __weak IBOutlet UIView *healthView;// 健康状态
    
    NSMutableDictionary  *_editorDic;// 编辑数据
    NSMutableArray <NSDictionary *>* _dataArray;//所以添加的数据
    NSMutableArray * _titleArray;//显示的名称数组
    TBGZEmployeesAddViewMode *_viewMode;// 数据处理类
    NSInteger _editorIndex;// 正在编辑第几个数据
}
#pragma mark  ----视图添加设置----

/**
 加载view
 
 @param frame frame
 @return self
 */
+ (TBGZEmployeesAddView *)loadingNibConetenViewWithFrame:(CGRect)frame;
{
    TBGZEmployeesAddView *view = [[[NSBundle mainBundle] loadNibNamed:@"TBGZEmployeesAddView" owner:nil options:nil] lastObject];
    
    view.myFrame = frame;
    [view setUpViews];
    
    return view;
}
/**
 设置控件
 */
- (void)setUpViews;
{
    scrollView.delegate = self;
    
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 4;
    saveButton.backgroundColor = NAVIGATION_COLOR;
    
    statisticalButton.layer.borderColor = NAVIGATION_COLOR.CGColor;
    statisticalButton.layer.borderWidth = 0.5;
    [statisticalButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
    statisticalButton.layer.shadowOpacity = 0.6;// 阴影透明度
    statisticalButton.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    statisticalButton.layer.shadowRadius = 3;// 阴影扩散的范围控制
    statisticalButton.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    
    TBWeakSelf
    [tagsLabelView setCellClick:^(NSInteger index) {
     [weakSelf tagViewTouchIndex:index];
    }];

    _editorIndex  = 0;
    _viewMode     = [[TBGZEmployeesAddViewMode alloc] init];
    _editorDic    = [NSMutableDictionary dictionaryWithDictionary:[_viewMode createTheRawData]];
    _dataArray    = [NSMutableArray arrayWithCapacity:0];
    _titleArray   = [NSMutableArray arrayWithCapacity:0];
    
}
#pragma mark  ----数据加载----
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    if (makingList.poorPeopleArray.count > 0 && makingList.poorPeopleArray != nil)
    {
        _dataArray = makingList.poorPeopleArray;
    }
    [self upTagsViewIsPrompt:nil];
     return @{@"name":@"精准扶贫",@"prompt":@""};
}
#pragma mark  ----数据更新上传----
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    self.makingList.povertyInfoDic = @{@"totalNum":@"0",
                                       @"below20Num":@"0",
                                       @"below35Num":@"0",
                                       @"below50Num":@"0",
                                       @"below65Num":@"0",
                                       @"above65Num":@"0",
                                       @"menNum":@"0",
                                       @"womanNum":@"0",
                                       @"lowSalary":@"0",
                                       @"highSalary":@"0",};
    
    self.makingList.poorPeopleArray = _dataArray;
    return YES;
}
#pragma mark  ----点击事件----

- (IBAction)saveButtonClick:(UIButton *)sender
{
    [self endEditing:YES];
    if ([self dataValidation])
    {
        [self addData];
    }
}
- (IBAction)statisticalButtonClick:(UIButton *)sender
{
    [self endEditing:YES];
    if (_dataArray.count == 0)
    {
        [UIView addMJNotifierWithText:@"没有数据可展示！" dismissAutomatically:YES];
    }
    else
    {
        [_viewMode obtainStatisticalResultsData:_dataArray results:^(NSDictionary *data)
        {// push到统计结果页面
            TBGZPeopleStatisticsViewController *poView = [[TBGZPeopleStatisticsViewController alloc] initShowData:data];
            ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:poView];
            [[ZKUtil getPresentedViewController] presentViewController:nav animated:YES completion:nil];
        }];
       
    }
}
- (IBAction)radioButtonClick:(UIButton *)sender
{
    [self endEditing:YES];
    NSInteger radioButtonTag = sender.tag;
    UIView *view;
    NSString *tagString = @"";
    NSString *key       = @"";
    
    if (radioButtonTag < 2000)
    {// 性别
        view = genderView;
        tagString = [NSString stringWithFormat:@"%ld",radioButtonTag - 1000];
        key = Key_gender;
        
        
    }
    else if (radioButtonTag < 3000)
    {//婚姻
        view = marriageView;
        tagString = [NSString stringWithFormat:@"%ld",radioButtonTag - 2000];
        key = Key_marriage;
    }
    else
    {//健康状态
        view = healthView;
        tagString = [NSString stringWithFormat:@"%ld",radioButtonTag - 3000];
        key = Key_health;
    }
    // 保存值 修改状态
    [_editorDic setValue:tagString forKey:key];
    [self updateSelectButtonView:view select:radioButtonTag];
}

/**
 点击选择名称
 
 @param index 第几个
 */
- (void)tagViewTouchIndex:(NSInteger)index
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    TBWeakSelf
    [alert addAction:[UIAlertAction actionWithTitle:@"重新编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [weakSelf formAssignmentIndex:index];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [weakSelf removePoorWorkersDataIndex:index];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [[ZKUtil getPresentedViewController] presentViewController:alert animated:true completion:nil];
}
#pragma mark  ----tool fun----
/**
 更新选中按钮
 
 @param view 父视图
 @param index 第几个按钮选中
 */
- (void)updateSelectButtonView:(UIView *)view select:(NSInteger)index
{
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIButton class]])
        {
            NSString *imageName = obj.tag == index?hollow_selected:hollow_cancel;
            
            [obj setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
    }];
}

/**
 刷新数据
 */
- (void)upTagsViewIsPrompt:(NSString *)prompt;
{
    TBWeakSelf dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [_titleArray removeAllObjects];
        
        _titleArray = [TagsModel mj_objectArrayWithKeyValuesArray:_dataArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [tagsLabelView setViewWithTagsArr:_titleArray];
            [weakSelf clearTable];
            if (prompt.length > 0)
            {
                [UIView addMJNotifierWithText:prompt dismissAutomatically:YES];
            }
        });
    });
}
/**
 表格赋值
 */
- (void)formAssignmentIndex:(NSInteger)index
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_editorDic removeAllObjects];
    [_editorDic addEntriesFromDictionary:_dataArray[index]];
    iDCardTextField.userInteractionEnabled = NO;
    _editorIndex  = index;
    
    NSInteger gender = [[_editorDic valueForKey:Key_gender] integerValue]+1000;
    NSInteger marriage = [[_editorDic valueForKey:Key_marriage] integerValue]+2000;
    NSInteger health = [[_editorDic valueForKey:Key_health] integerValue]+3000;
    
    iDCardTextField.text = [_editorDic valueForKey:Key_iDCardTextField];
    nameTextfield.text   = [_editorDic valueForKey:Key_nameTextfield];
    phoneTextfield.text  = [_editorDic valueForKey:Key_phoneTextfield];
    salaryTextfield.text = [_editorDic valueForKey:Key_salaryTextfield];
    ageTextfield.text    = [_editorDic valueForKey:Key_ageTextfield];
    jobsTextfield.text   = [_editorDic valueForKey:Key_jobsTextfield];
    
    [self updateSelectButtonView:genderView select:gender];
    [self updateSelectButtonView:marriageView select:marriage];
    [self updateSelectButtonView:healthView select:health];
}
/**
 清空表格
 */
- (void)clearTable
{
    iDCardTextField.text = @"";
    nameTextfield.text = @"";
    phoneTextfield.text = @"";
    salaryTextfield.text = @"";
    ageTextfield.text = @"";
    jobsTextfield.text = @"";
    
    iDCardTextField.userInteractionEnabled = YES;
    _editorIndex  = 0;
    [_editorDic removeAllObjects];
    _editorDic = nil;
    _editorDic    = [NSMutableDictionary dictionaryWithDictionary:[_viewMode createTheRawData]];
    
    [self updateSelectButtonView:genderView select:1001];
    [self updateSelectButtonView:marriageView select:2001];
    [self updateSelectButtonView:healthView select:3000];
}

/**
 删除贫困员工数据
 
 @param index 第几个
 */
- (void)removePoorWorkersDataIndex:(NSInteger)index
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲！真的要删除此人的录入信息吗？"];
    TBWeakSelf
    [more showHandler:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 更新界面
            [_dataArray removeObjectAtIndex:index];
            [_titleArray removeObjectAtIndex:index];
            [weakSelf upTagsViewIsPrompt:@"数据已删除"];
        }];
    }];
}
#pragma mark  ----数据处理----(void (^)(void))block
- (BOOL)dataValidation
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if ([ZKUtil checkIsIdentityCard:iDCardTextField.text])
    {
        [_editorDic setValue:iDCardTextField.text forKey:Key_iDCardTextField];
    }
    else
    {
        [self showPrompts:@"身份证格式有误！" shakeAnimationForView:iDCardTextField.superview];
        return NO;
    }
    if (nameTextfield.text.length > 0)
    {
        [_editorDic setValue:nameTextfield.text forKey:Key_nameTextfield];
    }
    else
    {
        [self showPrompts:@"请填写姓名！" shakeAnimationForView:nameTextfield.superview];
        return NO;
    }
    
    if (phoneTextfield.text.length > 0)
    {
        [_editorDic setValue:phoneTextfield.text forKey:Key_phoneTextfield];
    }
    else
    {
        [self showPrompts:@"请填写联系方式！" shakeAnimationForView:phoneTextfield.superview];
        return NO;
    }
    
    if ([ZKUtil ismoney:salaryTextfield.text])
    {
        [_editorDic setValue:salaryTextfield.text forKey:Key_salaryTextfield];
    }
    else
    {
        [self showPrompts:@"薪资格式错误！" shakeAnimationForView:salaryTextfield.superview];
        return NO;
    }
    
    if (ageTextfield.text.length > 0 && ageTextfield.text.integerValue >0)
    {
        [_editorDic setValue:ageTextfield.text forKey:Key_ageTextfield];
    }
    else
    {
        [self showPrompts:@"请填写正确的年龄！" shakeAnimationForView:ageTextfield.superview];
        return NO;
    }
    
    if (jobsTextfield.text.length > 0)
    {
        [_editorDic setValue:jobsTextfield.text forKey:Key_jobsTextfield];
    }
    else
    {
        [self showPrompts:@"请填写岗位信息！" shakeAnimationForView:jobsTextfield.superview];
        return NO;
    }
    
    return YES;
}
/**
 添加数据
 */
- (void)addData
{
    
    if (iDCardTextField.userInteractionEnabled == YES)
    {
        [self validationDataRepeat:^(BOOL results)
         {
             if (results == NO)
             {// 不存在重复数据
                 // 开启验证
                 TBWeakSelf
                 [_viewMode validationData:_editorDic validationResults:^(BOOL results, NSInteger code)
                  {
                      if (results == NO)
                      {
                          [UIView addMJNotifierWithText:@"查询异常！" dismissAutomatically:YES];
                      }
                      else
                      {
                          NSString *type = code == 200?@"1":@"0";
                          [_editorDic setValue:type forKey:Key_type];
                          [_dataArray addObject:[_editorDic mutableCopy]];
                          [weakSelf upTagsViewIsPrompt:@"数据添加成功"];
                      }
                  }];
             }
             else
             {
                 [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                 [UIView addMJNotifierWithText:@"身份证重复了" dismissAutomatically:YES];
                 [ZKUtil shakeAnimationForView:iDCardTextField.superview];
             }
         }];
    }
    else
    {
        [_dataArray replaceObjectAtIndex:_editorIndex withObject:[_editorDic mutableCopy]];
        [self upTagsViewIsPrompt:@"数据已保存"];
    }
}
/**
 验证数据的重复
 
 @param results no 没有
 */
- (void)validationDataRepeat:(void(^)(BOOL results))results
{
    BOOL repeat = NO;
    for (NSDictionary *dic in _dataArray)
    {
        NSString *card = [dic valueForKey:Key_iDCardTextField];
        if ([card isEqualToString:iDCardTextField.text])
        {
            repeat = YES;
        }
    }
    if (results)
    {
        results(repeat);
    }
}

/**
 异常回馈
 
 @param meg 消息
 @param view 动画视图
 */
- (void)showPrompts:(NSString *)meg shakeAnimationForView:(UIView *)view
{
    [UIView addMJNotifierWithText:meg dismissAutomatically:YES];
    [ZKUtil shakeAnimationForView:view];
}
#pragma mark  ----UIScrollViewDelegate----
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}
-(void)drawRect:(CGRect)rect
{
    self.frame = self.myFrame;//关键点在这里
}
@end
