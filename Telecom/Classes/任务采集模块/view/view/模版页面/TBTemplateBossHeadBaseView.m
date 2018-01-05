//
//  TBTemplateBossHeadBaseView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/12.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateBossHeadBaseView.h"
#import "TBChoosePhotosTool.h"
#import "TBMakingListMode.h"
#import "UIButton+ImageTitleStyle.h"
#import "TBBossRecordingView.h"
#import "TBBossPromptView.h"

@interface TBTemplateBossHeadBaseView ()<TBChoosePhotosToolDelegate,TBBossRecordingViewDelegate>

/**
 老板头像
 */
@property (nonatomic, strong) id bossHeadImage;
/**
 录制声音
 */
@property (nonatomic, strong) id audioData;

@end
@implementation TBTemplateBossHeadBaseView
{
    TBChoosePhotosTool * tool;
    
    UIImageView *headerImageView;
    
    TBBossRecordingView *recordingView;
    
    TBBossPromptView *prompView;
    
    UIScrollView *scrollView;
    
}
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contenView addSubview:scrollView];
        
        tool = [[TBChoosePhotosTool alloc] init];
        tool.delegate = self;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:headerView];
        
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:footView];
        
        prompView = [[TBBossPromptView alloc] init];
        [scrollView addSubview:prompView];
        
        UIButton *topTagView = [UIButton buttonWithType:UIButtonTypeCustom];
        [topTagView setTitle:@" 上传老板头像(或店铺招牌)" forState:UIControlStateNormal];
        [topTagView setImage:[UIImage imageNamed:@"task_bt"] forState:UIControlStateNormal];
        [topTagView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        topTagView.titleLabel.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:topTagView];
        
        UIButton *footTagView = [UIButton buttonWithType:UIButtonTypeCustom];
        [footTagView setTitle:@" 录制宣传语音(让更多游客知道您)" forState:UIControlStateNormal];
        [footTagView setImage:[UIImage imageNamed:@"task_bt"] forState:UIControlStateNormal];
        [footTagView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        footTagView.titleLabel.font = [UIFont systemFontOfSize:14];
        [footView addSubview:footTagView];
        
        headerImageView = [[UIImageView alloc] init];
        headerImageView.layer.cornerRadius = 4;
        headerImageView.userInteractionEnabled = YES;
        headerImageView.clipsToBounds = YES;
        headerImageView.image = [UIImage imageNamed:@"boss_default"];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.layer.cornerRadius = (_SCREEN_WIDTH/3)/2;
        headerImageView.clipsToBounds = YES;
        [headerView addSubview:headerImageView];
        
        UITapGestureRecognizer *zer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicl)];
        [headerImageView addGestureRecognizer:zer];
        
        UILabel *headerPromptLabel = [[UILabel alloc] init];
        headerPromptLabel.textColor = [UIColor grayColor];
        headerPromptLabel.font = [UIFont systemFontOfSize:14 weight:0.1];
        headerPromptLabel.text = @"点击上方按钮,上传图片";
        [headerView addSubview:headerPromptLabel];
        
        recordingView = [[TBBossRecordingView alloc] init];
        recordingView.backgroundColor = [UIColor whiteColor];
        recordingView.delegate = self;
        [footView addSubview:recordingView];
        
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(stopBossAudio) name:@"VoiceStopNotice" object:nil];
        
        TBWeakSelf
        
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contenView);
        }];
        
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.equalTo(scrollView);
            make.width.mas_equalTo(_SCREEN_WIDTH);
        }];
        
        [footView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(scrollView);
             make.width.mas_equalTo(_SCREEN_WIDTH);
             make.top.equalTo(headerView.mas_bottom).offset(10);
             make.bottom.equalTo(scrollView.mas_bottom).offset(-10);
             
         }];
        
        [topTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(headerView).offset(10);
            make.height.equalTo(@16);
        }];
        
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(40);
            make.centerX.equalTo(headerView.mas_centerX);
            make.width.height.equalTo(@(_SCREEN_WIDTH/3.0));
        }];
        [headerPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(headerImageView.mas_bottom).offset(20);
            make.centerX.equalTo(headerView.mas_centerX);
            make.bottom.equalTo(headerView.mas_bottom).offset(-30);
        }];
        
        [footTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(footView).offset(10);
            make.height.equalTo(@16);
        }];
        
        
        [prompView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_SCREEN_WIDTH);
            make.top.equalTo(footTagView.mas_bottom).offset(8);
            make.left.equalTo(footView.mas_left);
            
        }];
        
        [recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(footView);
            make.top.equalTo(prompView.mas_bottom).offset(0);
            make.bottom.equalTo(footView.mas_bottom).offset(-14);
        }];
        
    }
    
    return self;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
#pragma mark  --- 点击事件 ---
// 选择照片
- (void)headClicl
{
    
    if (self.bossHeadImage)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"重新选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
            [tool showHeadToChooseViewController:[ZKUtil getPresentedViewController]];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"预览大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [tool showPreviewPhotosArray:@[self.bossHeadImage] baseView:headerImageView selected:0];
        }]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"删除照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            headerImageView.image = [UIImage imageNamed:@"boss_default"];
            headerImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.bossHeadImage = nil;
        }]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
        }]];
        
        [[ZKUtil getPresentedViewController] presentViewController:alertView animated:YES completion:nil];
    }
    else
    {
        [tool showHeadToChooseViewController:[ZKUtil getPresentedViewController]];
    }
    
}

#pragma mark --TBBossRecordingViewDelegate--

/**
 录制完后
 
 @param voiceData 音频文件
 */
- (void)recorderOverData:(NSData *)voiceData;
{
    self.makingList.bossVoiceUrl = nil;
    self.audioData = voiceData;
}
/**
 删除完成
 */
- (void)deleteTheAudio;
{
    self.audioData = nil;
}
#pragma mark ---- TBChoosePhotosToolDelegate --

- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    self.makingList.bossHeaderImageUrl = nil;
    UIImage *photoImage = [images lastObject];
    self.bossHeadImage = photoImage;
    [headerImageView setImage:photoImage];
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
}
#pragma mark -------

//停止播放销毁
- (void)stopBossAudio;
{
    [recordingView stopAudio];
}
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    if (makingList.bossHeaderImageUrl.length >0)
    {
        [ZKUtil downloadImage:headerImageView imageUrl:makingList.bossHeaderImageUrl duImageName:@"boss_default"];
        self.bossHeadImage = makingList.bossHeaderImageUrl;
        
    }
    else if (makingList.bossHeaderData)
    {
        UIImage *_decodedImage  = [UIImage imageWithData:makingList.bossHeaderData];
        self.bossHeadImage = _decodedImage;
        headerImageView.image = self.bossHeadImage;
    }
    
    
    if (makingList.bossVoiceUrl.length>0)
    {
        
        self.audioData = makingList.bossVoiceUrl;
    }
    else if (makingList.bossVoiceData)
    {
        self.audioData = makingList.bossVoiceData;
    }
    [recordingView assignmentVoiceData:self.audioData];
    
     return @{@"name":@"老板头像",@"prompt":@""};
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    [recordingView stopAudio];
    
    if ([self.bossHeadImage isKindOfClass:[NSString class]])
    {
        self.makingList.bossHeaderImageUrl = self.bossHeadImage;
    }
    else if ([self.bossHeadImage isKindOfClass:[UIImage class]])
    {
        NSData *data = UIImageJPEGRepresentation(self.bossHeadImage, 1.0);
        self.makingList.bossHeaderData = data;
    }
    
    if ([self.audioData isKindOfClass:[NSString class]])
    {
        self.makingList.bossVoiceUrl = self.audioData;
    }
    else if ([self.audioData isKindOfClass:[NSData class]])
    {
        self.makingList.bossVoiceData = self.audioData;
    }
    return YES;
}
- (void)dealloc
{
    [recordingView stopAudio];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
