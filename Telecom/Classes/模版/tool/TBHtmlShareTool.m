//
//  TBHtmlShareTool.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/16.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBHtmlShareTool.h"
#import "UIButton+ImageTitleStyle.h"
#import "WXApi.h"
#import "UIImage+Thumbnail.h"
#import "SDWebImageManager.h"

@implementation TBHtmlShareTool

{
    UIView *contentView;
    
    UIActivityIndicatorView *activityView;
    
    CGFloat contentHeight;
    
    NSString *_title;
    NSString *_info;
    NSString *_webUrl;
    UIImage *_image;
}

- (instancetype)init;
{
    
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self) {
        
        contentHeight = 164;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];;
        
        
        UIButton *hideButton = [[UIButton alloc] initWithFrame:self.bounds];
        hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [hideButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hideButton];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _SCREEN_HEIGHT+contentHeight, _SCREEN_WIDTH, contentHeight)];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor whiteColor];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.2];
        [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.cornerRadius = 8;
        [contentView addSubview:cancelButton];
        
        
        UIView *shareView = [[UIView alloc] init];
        shareView.layer.cornerRadius = 8;
        shareView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:shareView];
        
        UIButton *spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [spaceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        spaceButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [spaceButton setTitle:@"朋友圈" forState:UIControlStateNormal];
        [spaceButton setImage:[UIImage imageNamed:@"spaceClick"] forState:UIControlStateNormal];
        spaceButton.tag = 1000;
        [spaceButton addTarget:self action:@selector(shareType:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:spaceButton];
        
        
        UIButton *friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [friendsButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [friendsButton setImage:[UIImage imageNamed:@"friendsClick"] forState:UIControlStateNormal];
        friendsButton.tag = 1001;
        friendsButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [friendsButton setTitle:@"微信" forState:UIControlStateNormal];
        [friendsButton addTarget:self action:@selector(shareType:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:friendsButton];
        
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activityView.color = [UIColor whiteColor];
        [self addSubview:activityView];
        
        [activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.left.equalTo(contentView.mas_left).offset(10);
            make.bottom.equalTo(contentView.mas_bottom).offset(-10);
            make.height.mas_equalTo(44);
        }];
        
        [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(contentView.mas_right).offset(-10);
            make.left.equalTo(contentView.mas_left).offset(10);
            make.bottom.equalTo(cancelButton.mas_top).offset(-10);
            make.top.equalTo(contentView.mas_top);
        }];
        
        CGFloat off = (_SCREEN_WIDTH-20)/6;
        [spaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(shareView.mas_centerX).offset(-off);
            make.centerY.equalTo(shareView.mas_centerY);
        }];
        
        [friendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(shareView.mas_centerX).offset(off);
            make.centerY.equalTo(shareView.mas_centerY);
            
        }];
        
        [spaceButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
        [friendsButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:0];
    }
    
    return self;
}


#pragma mark  点击事件啊
//分享到朋友圈  分享到空间
- (void)shareType:(UIButton *)sende
{
    if (!_image) {
        
        [UIView addMJNotifierWithText:@"图片处理中,请稍等！" dismissAutomatically:YES];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _title;
    message.description = _info;
    [message setThumbImage:_image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = _webUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = sende.tag == 1000?WXSceneTimeline:WXSceneSession;
    [WXApi sendReq:req];
    
}

- (void)cancelClick
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)showWXTitle:(NSString *)title deacription:(NSString *)info image:(id)image webpageUrl:(NSString *)webUrl;
{
    _title = [NSString stringWithFormat:@"%@",title];
    _info = info;
    _webUrl = webUrl;
    
    if ([image isKindOfClass:[UIImage class]])
    {
       _image = [image imageByScalingAndCroppingForSize:CGSizeMake(80, 80)];
    }
    else
    {
        [activityView startAnimating];
        //1.获取网络资源路径(URL)
        NSString *url = image;
        if (![url containsString:IMAGE_URL]) {
            url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
        }
        NSURL *pURL = [NSURL URLWithString:url];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:pURL options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [activityView stopAnimating];
            if (finished)
            {
                _image = [image imageByScalingAndCroppingForSize:CGSizeMake(100, 100)];
            }else
            {
                hudShowError(@"图片下载失败!");
            }

        }];

    }
    self.alpha = 1;
    [[APPDELEGATE window] addSubview:self];
    
    contentView.frame = CGRectMake(0, _SCREEN_HEIGHT+contentHeight,_SCREEN_WIDTH, contentHeight);
    [UIView animateWithDuration:0.3 animations:^{
        
        contentView.frame = CGRectMake(0, _SCREEN_HEIGHT-contentHeight,_SCREEN_WIDTH, contentHeight);
    }];
    
}
@end
