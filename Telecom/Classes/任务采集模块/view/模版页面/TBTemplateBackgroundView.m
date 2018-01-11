//
//  TBTemplateBackgroundView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/14.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateBackgroundView.h"
#import "TBBackgroundImageTableViewCell.h"
#import "TBBackgroundMusicTableViewCell.h"
#import "AudioStreamer.h"

@interface TBTemplateBackgroundView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) id coverImage;

@property (strong, nonatomic) NSString *music;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,  strong) AudioStreamer *streamer;

@property (nonatomic, strong) NSMutableArray <TBTemplateBackgroundData *>*dataArray;

@property (nonatomic, strong) TBBackgroundImageTableViewCell *photoCell;

@property (nonatomic, assign) NSInteger indexState;

@end

@implementation TBTemplateBackgroundView

- (NSMutableArray<TBTemplateBackgroundData *> *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contenView addSubview:self.tableView];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"TBBackgroundImageTableViewCell" bundle:nil] forCellReuseIdentifier:TBBackgroundImageTableViewCellID];
        [self.tableView registerNib:[UINib nibWithNibName:@"TBBackgroundMusicTableViewCell" bundle:nil] forCellReuseIdentifier:TBBackgroundMusicTableViewCellID];
        
        self.photoCell = [self.tableView dequeueReusableCellWithIdentifier:TBBackgroundImageTableViewCellID];
        
        //获取通知中心单例对象
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(stopMusic) name:@"VoiceStopNotice" object:nil];
        TBWeakSelf
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contenView);
        }];
        
        [self.photoCell setCoverImage:^(UIImage *coverImage) {
            weakSelf.makingList.coverPhotoUrl = nil;
            weakSelf.coverImage = coverImage;
        }];
        self.music = @"";
        [self requestData];
    }
    
    return self;
}
#pragma mark ---数据请求---
- (void)requestData
{
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"interfaceId"] = @"182";
    dic[@"uid"] = [UserInfo account].userID;
    dic[@"shopcode"] = [UserInfo account].code;
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic cacheType:ZKCacheTypeReturnCacheDataThenLoad success:^(NSDictionary *obj) {
        [weakSelf dataProcessingData:obj];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  数据处理
 *
 *  @param responseObject 数据
 */
- (void)dataProcessingData:(NSDictionary*)responseObject
{
    NSArray *root = [[responseObject valueForKey:@"data"] valueForKey:@"root"];
    self.dataArray = [TBTemplateBackgroundData mj_objectArrayWithKeyValuesArray:root];
    [self.tableView reloadData];
    
    if (self.music.length == 0)
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        [self selectMusic];
    }
    
}
#pragma mark ---UITableViewDelegate---
#pragma mark ---UITableViewDataSource---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?1:self.dataArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        cell = self.photoCell;
    }
    else
    {
        TBBackgroundMusicTableViewCell *musicCell = [tableView dequeueReusableCellWithIdentifier:TBBackgroundMusicTableViewCellID];
        
        musicCell.data = indexPath.row == 0 ?nil:self.dataArray[indexPath.row-1];
        cell = musicCell;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return (_SCREEN_WIDTH-20)*0.8;
    }
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *ritButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ritButton setImage:[UIImage imageNamed:@"task_bt"] forState:UIControlStateNormal];
    NSString *name = section == 0?@" 封面图片":@" 背景音乐";
    [ritButton setTitle:name forState:UIControlStateNormal];
    ritButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [ritButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerView addSubview:ritButton];
    [ritButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            self.music = @"";
            [self stopMusic];
        }
        else if (self.dataArray.count>0)
        {
            TBTemplateBackgroundData *data = self.dataArray[indexPath.row - 1];
            self.music = data.ID;
            NSURL *playerUrl = [NSURL URLWithString:[data.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [self playerUrl:playerUrl indexState:self.indexState == indexPath.row];
            self.indexState = indexPath.row;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}
#pragma mark 播放音乐

/**
 播放音乐
 
 @param url URL
 @param state 是否开始新的播放 yes不开始
 */
- (void)playerUrl:(NSURL *)url indexState:(BOOL)state
{
    if (state == YES)
    {
        if (self.streamer.isPaused)
        {
            [self.streamer start];
        }
        else if (self.streamer.isPlaying)
        {
            [self.streamer pause];
        }
        else if (self.streamer.isWaiting)
        {
            
        }else if (self.streamer.isIdle)
        {
            [self.streamer start];
        }
    }
    else
    {
        [self.streamer stop];
        self.streamer = nil;
        self.streamer = [[AudioStreamer alloc] initWithURL:url];
        [self.streamer start];
    }
}
#pragma mark -- 数据获取和提取 ---
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    
    if (makingList.coverMusic.length>0)
    {
        self.music = makingList.coverMusic;
    }
    else
    {
        self.music = @"";
    }
    
    self.photoCell.isBackImage = NO;
    if (makingList.coverPhotoUrl.length >0)
    {
        self.coverImage = makingList.coverPhotoUrl;
        [ZKUtil downloadImage:self.photoCell.backImageView imageUrl:self.coverImage duImageName:@"productDefault.jpg"];
        self.photoCell.isBackImage = YES;
        
    }
    else if (makingList.coverPhotoData)
    {
        UIImage *_decodedImage      = [UIImage imageWithData:makingList.coverPhotoData];
        self.coverImage = _decodedImage;
        [self.photoCell.backImageView setImage:_decodedImage];
        self.photoCell.isBackImage = YES;
    }
     return @{@"name":@"封面图片",@"prompt":@""};
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    self.makingList.coverMusic = self.music;
    
    if ([self.coverImage isKindOfClass:[NSString class]])
    {
        self.makingList.coverPhotoUrl = self.coverImage;
    }
    else if ([self.coverImage isKindOfClass:[UIImage class]])
    {
        NSData *data = UIImageJPEGRepresentation(self.coverImage ,1.0);
        self.makingList.coverPhotoData = data;
    }
    
    [self stopMusic];
    return YES;
}

#pragma mark ----
- (void)selectMusic
{
    if (self.music.length >0)
    {
        TBWeakSelf
        [self.dataArray enumerateObjectsUsingBlock:^(TBTemplateBackgroundData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.ID.integerValue == weakSelf.music.integerValue)
            {
                [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx+1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }];
    }
}
- (void)stopMusic;
{
    [self.streamer stop];
}
- (void)dealloc
{
    [self.streamer stop];
    self.streamer = nil;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
