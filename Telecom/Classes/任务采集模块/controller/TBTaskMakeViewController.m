//
//  TBTaskMakeViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTaskMakeViewController.h"
// 视图加载在这个类里
#import "TBMaskMakeGuideFile.h"

@interface TBTaskMakeViewController ()<UIScrollViewDelegate,TBTaskMakeViewModeDelegate,TBTaskMakeFootViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
//业务处理模型
@property (nonatomic, strong) TBTaskMakeViewMode *viewMode;
//尾部视图
@property (nonatomic, strong) TBTaskMakeFootView *footTool;

@property (nonatomic, strong) TBTaskMakeTitleView *titleView;

@property (nonatomic) AFNetworkReachabilityStatus workStatus;//网络状态
// 适配iPhone X
@property (nonatomic, assign) CGFloat bottomFloat;
@property (nonatomic, assign) CGFloat topFloat;
// 加载的子视图集合
@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation TBTaskMakeViewController
- (NSMutableArray *)viewArray
{
    if (!_viewArray)
    {
        _viewArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _viewArray;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, _SCREEN_WIDTH, _SCREEN_HEIGHT-64)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        
    }
    return _scrollView;
}

#pragma mark ----initView----
- (void)initNacItemView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem setRitWithTitel:@"教程" itemWithIcon:nil target:self action:@selector(strategyClick)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem setRitWithTitel:@"返回" itemWithIcon:@"nav_back" target:self action:@selector(goBackClick)];
}
// 视图布局
- (void)initSupViews;
{
    TBWeakSelf
    
    self.bottomFloat = 0.0f;
    self.topFloat   = 64.0f;
    if (_SCREEN_HEIGHT == 812) {
        self.bottomFloat = 34;
        self.topFloat = 96;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.top.right.equalTo(weakSelf.view);
     }];
    self.footTool = [[TBTaskMakeFootView alloc] init];
    self.footTool.backgroundColor = [UIColor whiteColor];
    
    self.footTool.delegate = self;
    [self.footTool updateFootViewStyle:0];
    [self.view addSubview:self.footTool];
    
    self.titleView = [[TBTaskMakeTitleView alloc] initWithFrame:CGRectMake(0, 24, _SCREEN_WIDTH-100, 40) type:self.type];
    [self.navigationItem setTitleView:self.titleView];
    
    [self.footTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-self.bottomFloat);
        make.top.equalTo(weakSelf.scrollView.mas_bottom);
        make.height.equalTo(@44);
    }];
    
}
// 加载内容
- (void)setScrollViewContent
{
    CGFloat viewHeight = _SCREEN_HEIGHT-self.topFloat-44-self.bottomFloat;
    
    self.viewArray = [TBMaskMakeGuideFile obtainLoadCollectionTask:self.type];
    // 布局
    self.scrollView.contentSize = CGSizeMake(_SCREEN_WIDTH*self.viewArray.count, _SCREEN_HEIGHT-self.topFloat-44-self.bottomFloat);
    
    [self.viewArray enumerateObjectsUsingBlock:^(TBTemplateBaseView *base, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.scrollView addSubview:base];
         base.frame = CGRectMake(_SCREEN_WIDTH*idx, 0, _SCREEN_WIDTH,viewHeight);
    }];
    
    //设置页数
    self.footTool.maxPage = self.viewArray.count-1;
    //此模式输入视图在scrollView上或其子view中,即其下级体系中,superView传该scrollView
    [[CDPMonitorKeyboard defaultMonitorKeyboard] sendValueWithSuperView:self.scrollView higherThanKeyboard:34 andMode:CDPMonitorKeyboardScrollViewMode];
}
#pragma mark --- 监听网络状态---
/**
 监听网络状态
 */
- (void)workReachability
{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         self.workStatus = status;
     }];
    
    //开始监听
    [manager startMonitoring];
    
}

//更加类型来获取数据
- (void)initDataConfiguration
{
    self.viewMode = [[TBTaskMakeViewMode alloc] init];
    if (self.makingList)
    {
        self.typeID = [[self.makingList.infoDic valueForKey:@"type"] integerValue];
        self.merchantsID = self.makingList.merchantsID;
        self.modelsID = self.makingList.modelsID;
        [self assignmentData:self.makingList];
    }
    else
    {
        self.viewMode.delegate = self;
        
        if (self.templateType == TBMakingProductionNewAdded)
        {
            TBMakingListMode *mode = [[TBMakingListMode alloc] init];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[NSNumber numberWithInteger:self.typeID] forKey:@"type"];
            mode.modelsID = self.modelsID;
            mode.infoDic = dic;
            [self assignmentData:mode];
            
        }
        else if (self.templateType == TBMakingProductionMaking)
        {
            [self.viewMode postMakingDataID:self.merchantsID];
        }
        else if (self.templateType == TBMakingProductionModifyThe)
        {
            [self.viewMode postEditDataID:self.merchantsID];
        }
    }
}
#pragma mark  ---- 逻辑处理 ---

/**
 全部view数据提交
 
 @return 数据是否完整
 */
- (BOOL)valuesViewTableViewAll
{
    NSInteger tag = 0;
    
    for (TBTemplateBaseView *baseView in self.viewArray) {
        
        if ([baseView updataMakingIsPrompt:NO]) {
            tag ++;
        }
    }
    self.makingList.merchantsID = self.merchantsID;
    self.makingList.modelsID = self.modelsID;
    self.viewMode.makingMode = self.makingList;
    
    return tag == self.viewArray.count;
}
#pragma mark --- 导航栏点击事件 -----
- (void)strategyClick
{
    TBStrategyViewController *strategyView = [[TBStrategyViewController alloc] init];
    [self.navigationController pushViewController:strategyView animated:YES];
}
- (void)goBackClick
{
    [self.view endEditing:YES];
    if (self.makingList.msg.length == 0 ||self.makingList.appearancePhotos.count>0 )
    {
        [self showPrompt];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)showPrompt
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveAlert = [UIAlertAction actionWithTitle:@"保存本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self footViewTouchUpInsideSave];
    }];
    
    UIAlertAction *exitAler = [UIAlertAction actionWithTitle:@"退出制作" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self backLevelController];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [alert addAction:saveAlert];
    [alert addAction:exitAler];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark ----TBTaskMakeViewModeDelegate---
/**
 开始请求
 */
- (void)postDataStart;
{
    hudShowLoading(@"数据加载中...");
}
/**
 制作数据获取
 
 @param data data
 */
- (void)makingTemplateData:(TBMakingListMode *)data;
{
    data.modelsID = self.modelsID;
    [self assignmentData:data];
    hudDismiss();
}
/**
 编辑数据获取
 
 @param data data
 */
- (void)editTemplateData:(TBMakingListMode *)data;
{
    [self assignmentData:data];
    hudDismiss();
}
/**
 数据请求失败
 
 @param err string
 */
- (void)dataPostError:(NSString *)err;
{
    hudShowError(err);
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 赋值
 
 @param mode 模型
 */
- (void)assignmentData:(TBMakingListMode *)mode
{
    self.modelsID = mode.modelsID;
    self.merchantsID = mode.merchantsID;
    self.makingList = mode;
    self.makingList.type = self.type;
    [self.titleView.titelArray removeAllObjects];
    for (TBTemplateBaseView *baseView in self.viewArray) {
        
        NSDictionary *dic = [baseView updataData:self.makingList];
        if (dic) {
            [self.titleView.titelArray addObject:dic];
        }
        
    }
    // 更新标题
    NSInteger offset =  self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self.titleView selectIndex:offset];
}

#pragma mark ---TBTaskMakeFootViewDelegate--
/**
 尾部视图点击代理
 
 @param type 左右点击类型 yes左点击
 */
- (void)footViewTouchUpInsideType:(BOOL)type
{
    NSInteger offset =  self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    if (offset == 1||offset == self.footTool.maxPage)
    {
        [self sendVoiceStopNotice];
    }
    if (type == YES)
    {
        //  上一步
        [self scrollViewOffsetIndex:offset-1 animateDuration:0.2];
    }
    else
    {
        TBTemplateBaseView *baseView = self.viewArray[offset];
        BOOL isNext = [baseView updataMakingIsPrompt:YES];
        
        if (isNext) {
            // 提交
            if (offset == self.footTool.maxPage)
            {
                [self touchUpInsideSubmit];
            }
            else
            {
                // 下一步
                [self scrollViewOffsetIndex:offset+1 animateDuration:0.2];
            }
        }
    }
}
#pragma mark  一些业务处理--
//偏移界面
- (void)scrollViewOffsetIndex:(NSInteger)row animateDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentOffset = CGPointMake(_SCREEN_WIDTH*row, 0);
        [self.footTool updateFootViewStyle:row];
        [self.titleView selectIndex:row];
    }];
}

/**
 保存
 */
- (void)footViewTouchUpInsideSave;
{ 
    hudShowSuccess(@"正在保存");
    self.makingList.type = self.type;
    
    self.makingList.complete = [self valuesViewTableViewAll];
    if (self.makingList.saveID.length == 0)
    {
        self.makingList.saveID = [ZKUtil timeStamp];
    }
    self.viewMode.makingMode.type = self.type;
    TBWeakSelf
    [self.viewMode saveState:^(BOOL state) {
        hudDismiss();
        if (state == YES)
        {
            [weakSelf showSavePromptViewState:weakSelf.makingList.complete == 0];
        }
    }];
    
}
- (void)showSavePromptViewState:(BOOL)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *msg = state == YES?@"草稿箱":@"待提交任务";
        TBSaveSuccessTipsView *tipsView = [[TBSaveSuccessTipsView alloc] initShowPrompt:msg];
        [tipsView showHandler:^{
            
            [self disappearHUD];
        }];
    });
}
// 返回上一级
- (void)disappearHUD
{
    if (self.dataStatusChange)
    {
        self.dataStatusChange();
    }
    [self backLevelController];
}
/**
 提交最后的判断
 */
- (void)touchUpInsideSubmit;
{
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否开始提交任务信息?"];
    [more showHandler:^{
        
        if (weakSelf.workStatus == AFNetworkReachabilityStatusUnknown)
        {
            hudShowError(@"网络连接异常!");
        }
        else if (weakSelf.workStatus == AFNetworkReachabilityStatusNotReachable)
        {
            // 不可达的网络(未连接)
            hudShowError(@"网络异常!");
        }
        else if (weakSelf.workStatus == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            // 2G,3G,4G...的网络
            [weakSelf showPrompt:@"当前网络非WiFi连接,是否继续上传资源信息?"];
        }
        else if (weakSelf.workStatus == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            // wifi的网络
            [weakSelf uploadingResources];
        }
        
    }];
    
}
/**
 上传
 */
- (void)uploadingResources
{
    [self sendVoiceStopNotice];
    
    if ([self valuesViewTableViewAll])
    {
        TBWeakSelf
        [self.viewMode submitDataSuccessful:^(TBMakingListMode *mode) {
            
            weakSelf.makingList = mode;
            [weakSelf pushCompleteController];
        } failure:^{
            
        }];
    }
    else
    {
        hudShowError(@"有数据遗漏?");
    }
}
// 调到结果页
- (void)pushCompleteController
{
    TBWeakSelf
    [self.viewMode deleteMode:self.makingList state:^(BOOL successful) {
        
        if (weakSelf.dataStatusChange)
        {
            weakSelf.dataStatusChange();
        }
    }];
    
    [self scrollViewOffsetIndex:0 animateDuration:0.0];
    self.templateType = TBMakingProductionModifyThe;
    TBTemplateCompleteViewController *vc = [[TBTemplateCompleteViewController alloc] init];
    vc.makingModel = self.makingList;
    [self.navigationController pushViewController:vc animated:YES];
    
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:TaskToInform object:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}
// 发送停止声音通知
- (void)sendVoiceStopNotice
{
    NSNotification * notice = [NSNotification notificationWithName:@"VoiceStopNotice" object:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}
- (void)showPrompt:(NSString *)stateInfo
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:stateInfo preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"任性上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self uploadingResources];
        
    }]];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)backLevelController
{
    [self sendVoiceStopNotice];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}
#pragma mark --- UIScrollViewDelegate ---
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger offset =  self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self.footTool updateFootViewStyle:offset];
}

#pragma mark ---self---
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [(AppDelegate *)APPDELEGATE setIsProcessingNotice:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIView dismissMJNotifier];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    [(AppDelegate *)APPDELEGATE setIsProcessingNotice:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNacItemView];
    [self initSupViews];
    [self setScrollViewContent];
    [self initDataConfiguration];
    [self workReachability];
}
- (void)dealloc
{
    [self sendVoiceStopNotice];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
