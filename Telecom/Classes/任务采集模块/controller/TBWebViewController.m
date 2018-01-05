//
//  TBWebViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/1/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBWebViewController.h"
#import "UIBarButtonItem+Custom.h"
#import <AVFoundation/AVFoundation.h>
#import "TBTaskListMode.h"
#import "TBHtmlShareTool.h"
@interface TBWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
//返回按钮
@property (nonatomic)UIBarButtonItem* customBackBarItem;
//关闭按钮
@property (nonatomic)UIBarButtonItem* closeButtonItem;

@property (nonatomic, assign) BOOL isAnimate;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TBWebViewController
- (UIWebView *)webView
{
    if (_webView == nil) {
        
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        //适应你设定的尺寸
        [_webView sizeToFit];
    }
    return _webView;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 2);
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor groupTableViewBackgroundColor]];
        _progressView.progressTintColor = [UIColor orangeColor];
    }
    return _progressView;
}
-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        
        _customBackBarItem = [UIBarButtonItem setRitWithTitel:@"返回" itemWithIcon:@"nav_back" target:self action:@selector(customBackItemClicked) ];
    }
    return _customBackBarItem;
}
-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [UIBarButtonItem setRitWithTitel:@"关闭" itemWithIcon:nil target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        
    }];
    
    //添加进度条
    [self.view addSubview:self.progressView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
    if (self.root)
    {
        //添加右边刷新按钮
//        UIBarButtonItem *roadLoad = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(roadLoadClicked)];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem setRitWithTitel:@"分享" itemWithIcon:nil target:self action:@selector(roadLoadClicked)];
    }
    // 解决播放音乐无声音的问题
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL flag;
    NSError *setCategoryError = nil;
    flag = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    
}

/**
 加载纯外部链接网页
 
 @param string URL地址
 */
- (void)loadWebURLSring:(NSString *)string;
{
    self.urlString = string;
    
}
#pragma mark ================ 自定义返回/关闭按钮 ================

-(void)updateNavigationItems{
    if (self.webView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonItem] animated:NO];
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
    }
}

#pragma mark -- 点击事件 ---
- (void)roadLoadClicked
{
    if (self.root)
    {
        TBHtmlShareTool *shareView = [[TBHtmlShareTool alloc] init];
        NSString *str = [NSString stringWithFormat:@"\n电话：%@\n地址：%@",self.root.tel,self.root.address];
        [shareView showWXTitle:self.root.name deacription:str image:self.root.img webpageUrl:HTML_URL(self.root.ID)];
    }
}
-(void)customBackItemClicked
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else
    {
        [self closeItemClicked];
    }
}
-(void)closeItemClicked
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- UIWebViewDelegate --
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    self.isAnimate = NO;
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
    self.progressView.progress = 0.0f;
    [self updataProgressView];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.title = @"正在加载";
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    self.isAnimate = YES;
    self.progressView.hidden = YES;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    self.title = @"加载异常";
    self.isAnimate = YES;
    self.progressView.hidden = YES;
    
}
- (void)updataProgressView
{
    if (self.timer == nil)
    {
        self.timer = [NSTimer timerWithTimeInterval:0.6 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    
}
- (void)timerAction
{
    if (self.isAnimate == YES)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    float tol =self.progressView.progress;
    tol = tol+0.2;
    if (tol >= 0.6) {
        self.isAnimate = YES;
    }
    self.progressView.progress = tol;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView setDelegate:nil];
}
- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    
}
- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    [self.webView stopLoading];
    self.webView.delegate = nil;
    self.webView = nil;
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
