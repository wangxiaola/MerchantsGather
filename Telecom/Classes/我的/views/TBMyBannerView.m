//
//  TBMyBannerView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//
#import "TBMyBannerView.h"
#import "TBChoosePhotosTool.h"

@interface TBMyBannerView ()<TBChoosePhotosToolDelegate>

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) TBChoosePhotosTool *choosePhotosTool;

@property (nonatomic, strong) UIImage *images;

@property (nonatomic, assign) CGFloat MIN_HEIGHT;

@end

@implementation TBMyBannerView
@synthesize  MIN_HEIGHT;

- (TBChoosePhotosTool *)choosePhotosTool
{
    if (_choosePhotosTool == nil)
    {
        _choosePhotosTool = [[TBChoosePhotosTool alloc] init];
        _choosePhotosTool.delegate = self;
    }
    return _choosePhotosTool;
}
- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine-avatar-icon"]];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.cornerRadius = 50;
        _headerImageView.layer.borderColor = RGB(115, 202, 210).CGColor;
        _headerImageView.layer.borderWidth = 4;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *zer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicl)];
        [_headerImageView addGestureRecognizer:zer];
        
    }
    return _headerImageView;
}
- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_bannerImage"]];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.userInteractionEnabled = YES;
        
    }
    return _backImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
    }
    return _nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        [self headBounce];
        
    }
    return self;
}
- (void)headBounce
{
    
    [self addSubview:self.backImageView];
    [self addSubview:self.headerImageView];
    [self addSubview:self.nameLabel];
    
    CGFloat cellWidth = 960;
    CGFloat cellHeight = 586;
    MIN_HEIGHT = _SCREEN_WIDTH*cellHeight/cellWidth;
    TBWeakSelf
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.width.height.equalTo(@100);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(_SCREEN_WIDTH*0.6);
        make.top.equalTo(weakSelf.headerImageView.mas_bottom).offset(16);
    }];
    
    UserInfo *info = [UserInfo account];
    NSString *url = info.headimg;
    
    if (url)
    {
        [ZKUtil downloadImage:self.headerImageView imageUrl:url duImageName:@"mine-avatar-icon"];
        self.nameLabel.text = info.name;
    }

    
}

#pragma mark ------头像点击----
- (void)headClicl
{
    [self.choosePhotosTool showHeadToChooseViewController:self.contenController];
}
// 选择相册的代理方法
#pragma mark ---- <TBChoosePhotosToolDelegate>

- (void)choosePhotosArray:(NSArray<UIImage *> *)images
{
    [self goNetData:images.firstObject];
}
#pragma mark --UICollisionBehavior--
-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier {
    

    NSString *identifierStr = [NSString stringWithFormat:@"%@", identifier];
    NSLog(@" ======  %@", identifierStr);
    
}
#pragma mark  --- post --
- (void)goNetData:(UIImage *)image;
{
    if (image == nil||![image isKindOfClass:[UIImage class]])
    {
        hudShowError(@"图片格式错误!");
        return;
    }
    self.images = image;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    //请求参数
    NSMutableDictionary *params = [NSMutableDictionary params];
    [params setValue:@"184" forKey: @"interfaceId"];
    MJWeakSelf
    hudShowLoading(@"图片上传中");
    [ZKPostHttp uploadImage:@"" params:params Data:imageData success:^(id responseObj) {
        NSDictionary * jsonsDICTIONARY = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        if (jsonsDICTIONARY && [[jsonsDICTIONARY valueForKey:@"errcode"] isEqual:@"00000"])
        {
            [weakSelf loadNetUrl:jsonsDICTIONARY[@"url"]];
        } else {
            hudShowError(@"图片上传失败");
        }
    } failure:^(NSError *error) {
        hudShowFailure();
    }];
}
- (void)loadNetUrl:(NSString *)url;
{
    NSMutableDictionary *params = [NSMutableDictionary params];
    [params setValue:@"186" forKey:@"interfaceId"];
    [params setValue:[UserInfo account].phone forKey:@"phone"];
    [params setValue:url forKey:@"url"];
    TBWeakSelf
    [ZKPostHttp post:@"" params:params success:^(id responseObj) {
        
        if ([[responseObj valueForKey:@"errcode"] isEqual:@"00000"]) {
            hudShowSuccess(@"图片上传成功");
            dispatch_async(dispatch_get_main_queue(), ^{
            
              [weakSelf.headerImageView setImage:weakSelf.images];
            });

            UserInfo *info = [UserInfo account];
            info.headimg = url;
            [UserInfo saveAccount:info];
            
        } else
        {
            hudShowError(@"图片上传失败");
        }
        
    } failure:^(NSError *error) {
        hudShowError(@"图片上传失败");
    }];
}


@end
