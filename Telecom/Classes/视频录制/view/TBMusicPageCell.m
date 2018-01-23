//
//  TBMusicPageCell.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/22.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBMusicPageCell.h"

@implementation TBMusicPageCell
{
    UIImageView *_backImageView;
    UILabel     *_musicNameLabel;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.isShoose = NO;
        self.backgroundColor = RGB(19, 19, 19);
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"musicUncheck"]];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.userInteractionEnabled = YES;
        [self addSubview:_backImageView];
        
        _musicNameLabel = [[UILabel alloc] init];
        _musicNameLabel.textColor = [UIColor whiteColor];
        _musicNameLabel.font      = [UIFont systemFontOfSize:14];
        [self addSubview:_musicNameLabel];
        
        
        TBWeakSelf
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.centerY.equalTo(weakSelf.mas_centerY).offset(-10);
            make.width.height.mas_equalTo(frame.size.width/4);
        }];
        
        [_musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.top.equalTo(_backImageView.mas_bottom).offset(10);
        }];
        
    }
    return self;
}

- (void)setParams:(NSDictionary *)params
{
    _params = params;
    /*
     @"name":name,
     @"path":path,
     @"row":row
     */
    _musicNameLabel.text = params[@"name"];
}
/**
 修改边框
 */
- (void)modifyViewBezel;
{
    self.layer.masksToBounds = YES;
    self.layer.borderColor   = NAVIGATION_COLOR.CGColor;
    self.layer.borderWidth   = 0.5f;
    self.isShoose = YES;
}
/**
 删除边框
 */
- (void)deleteViewBezel;
{
    self.isShoose = NO;
    self.layer.borderColor   = RGB(19, 19, 19).CGColor;
    self.layer.borderWidth   = 0.0f;
}
@end
