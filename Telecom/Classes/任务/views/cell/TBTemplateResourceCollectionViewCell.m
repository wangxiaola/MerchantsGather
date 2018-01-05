//
//  TBTemplateResourceCollectionViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/13.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateResourceCollectionViewCell.h"
NSString *const  TBTemplateResourceCollectionViewCellID = @"TBTemplateResourceCollectionViewCellID";

@implementation TBTemplateResourceCollectionViewCell
{
    UIButton *ritButton;
    
    NSInteger row;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView = [[UIImageView alloc] init];
        self.backImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.backImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.backImageView];
        self.backImageView.layer.masksToBounds = YES;
        self.backImageView.layer.cornerRadius = 4;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        ritButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ritButton setImage:[UIImage imageNamed:@"task-shanchu"] forState:UIControlStateNormal];
        [ritButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ritButton];
        TBWeakSelf
        [ritButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerX.equalTo(weakSelf.backImageView.mas_right).offset(-5);
             make.centerY.equalTo(weakSelf.backImageView.mas_top).offset(5);
             make.width.height.mas_equalTo(30);
         }];
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.contentView);
            
        }];
    }
    return self;
}

- (void)valueCellImage:(id )image showDelete:(BOOL)show index:(NSInteger)rows;
{
    if ([image isKindOfClass:[UIImage class]])
    {
        self.backImageView.image = image;
    }
    else if ([image isKindOfClass:[NSString class]])
    {
        [ZKUtil downloadImage:self.backImageView imageUrl:image duImageName:@"imageDefault.jpg"];
    }
    else
    {
        self.backImageView.image = [UIImage imageNamed:@"productDefault.jpg"];
    }
    
    ritButton.hidden = !show;
    ritButton.userInteractionEnabled = show;
    row = rows;
}
- (void)deleteClick
{
    
    if (self.deleteCell)
    {
        self.deleteCell(row);
    }
}
@end
