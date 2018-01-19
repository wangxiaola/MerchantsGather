//
//  JXVideoImagePickerViewController.m
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXVideoImagePickerViewController.h"
#import "JXUIService.h"
#import "TBRecordVideoMode.h"
#import "JXVideoImagePickerCell.h"
#import "JXVideoImageGenerator.h"
#import "JXVideoImagePickerCursorViewController.h"
#import "JXVideoImagePickerVideoPlayerController.h"

@interface JXVideoImagePickerViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;

/** UI*/
@property (nonatomic, strong)JXUIService *UIService;

@property (nonatomic, strong) JXVideoImagePickerCursorViewController *cursorContainerViewController;


@property (nonatomic, strong) JXVideoImagePickerVideoPlayerController *displayerVC;


@end

@implementation JXVideoImagePickerViewController

#pragma mark - lazy loading

- (JXVideoImagePickerVideoPlayerController *)displayerVC{
    if (_displayerVC == nil) {
        _displayerVC = [[JXVideoImagePickerVideoPlayerController alloc]init];
        _displayerVC.asset = [self getAsset];
    }
    return _displayerVC;
}

- (JXVideoImagePickerCursorViewController *)cursorContainerViewController{
    if (_cursorContainerViewController == nil) {
        _cursorContainerViewController = [[JXVideoImagePickerCursorViewController alloc]init];
    }
    return _cursorContainerViewController;
}


- (JXUIService *)UIService{
    if (_UIService == nil) {
        _UIService = [[JXUIService alloc]init];
        _UIService.asset = [self getAsset];
        JXWeakSelf(self);
        [_UIService setScrollDidBlock:^(CMTime currentTime) {
            JXStrongSelf(self);
            
            [self.displayerVC seekToTime:currentTime];
        }];
    }
    return _UIService;
}


- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(KeyframePickerViewCellHeight*16/9, KeyframePickerViewCellHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.dataSource = self.UIService;
        _collectionView.delegate = self.UIService;
        
        [_collectionView registerClass:[JXVideoImagePickerCell class] forCellWithReuseIdentifier:kVideoCellIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        //左右留白（屏幕一半宽），目的是让collectionView中的第一个和最后一个cell能滚动到屏幕中央
        //
        _collectionView.contentInset = UIEdgeInsetsMake(0, _SCREEN_WIDTH * 0.5, 0, _SCREEN_WIDTH * 0.5);
        
        _collectionView.backgroundColor = [UIColor blackColor];
        
    }
    
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    self.navigationItem.title = @"封面选择";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    JXWeakSelf(self);
    [self.UIService loadData:[self getAsset] callBlock:^{
        [weakself.collectionView reloadData];
    }];
}


- (void)setupUI{
    
    
    [self addChildViewController:self.displayerVC];
    [self.view addSubview:self.displayerVC.view];
    [self.view addSubview:self.collectionView];
    [self addChildViewController:self.cursorContainerViewController];
    [self.view addSubview:self.cursorContainerViewController.view];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text     = @"一个好看的封面会更吸引用户观看哦！";
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.font     = [UIFont systemFontOfSize:14];
    [self.view addSubview:promptLabel];
    
    UIView *bottomView   = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    UIView *buttonBackView = [[UIView alloc] init];
    buttonBackView.backgroundColor = [UIColor whiteColor];
    buttonBackView.layer.masksToBounds = YES;
    buttonBackView.layer.cornerRadius  = 65/2;
    [self.view addSubview:buttonBackView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setImage:[UIImage imageNamed:@"video_ confirm"] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(senderClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonBackView addSubview:sendButton];
    
    //    video_ confirm
    JXWeakSelf(self);
    
    CGFloat videoWidth = _SCREEN_WIDTH - 20 ;
    CGFloat videoHeigth = videoWidth*9/16;
    
    self.displayerVC.view.frame = CGRectMake(10, 10, videoWidth, videoHeigth);
    self.displayerVC.playerLayer.frame = CGRectMake(0, 0, videoWidth, videoHeigth);
    
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.bottom.equalTo(weakself.collectionView.mas_top).offset(-20);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-(_SCREEN_HEIGHT-64-videoHeigth-20)/2);
        make.height.equalTo(@(KeyframePickerViewCellHeight));
    }];
    
    [self.cursorContainerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakself.view);
        make.bottom.equalTo(weakself.collectionView);
        make.size.mas_equalTo(CGSizeMake(25, KeyframePickerViewCellHeight));
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakself.view);
        make.top.equalTo(weakself.collectionView.mas_bottom);
    }];
    
    [buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.width.height.equalTo(@65);
    }];
    
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(buttonBackView);
        make.width.height.equalTo(@65);
    }];
    [self.collectionView setContentOffset:CGPointMake(_SCREEN_WIDTH/2, 0) animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark  ----touch----
- (void)senderClick:(UIButton *)sender
{
    NSString *url = [self.videoPath componentsSeparatedByString:@"tmp/"].lastObject;
    
    JXWeakSelf(self);
    hudShowLoading(@"请稍等");
    [self.displayerVC getCurrentImage:^(UIImage *image) {
        JXStrongSelf(self);
        hudDismiss();
        TBRecordVideoMode *mode = [[TBRecordVideoMode alloc] init];
        mode.videoPath = url;
        mode.videoTime = self.videoTime;
        if (image == nil) {
            mode.coverImage = self.UIService.mrImage;
        }
        else
        {
            mode.coverImage = image;
        }
        //发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:Verification_video object:mode];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}

#pragma mark - Actions
- (AVAsset *)getAsset{
    
    if (_asset) {
        return _asset;
    }
    
    NSURL *videoURL = [NSURL URLWithString:_videoPath];
    
    if (videoURL == nil || videoURL.scheme == nil ) {
        videoURL = [NSURL fileURLWithPath:_videoPath];
    }

    if (videoURL) {
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        
        return urlAsset;
    }
    
    return nil;
    
}


@end
