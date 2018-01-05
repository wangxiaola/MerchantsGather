//
//  TBBackgroundImageTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/14.
//  Copyright © 2016年 王小腊. All rights reserved.
//

NSString *const TBBackgroundImageTableViewCellID = @"TBBackgroundImageTableViewCellID";
#import "TBBackgroundImageTableViewCell.h"
#import "TBChoosePhotosTool.h"

@interface TBBackgroundImageTableViewCell ()<TBChoosePhotosToolDelegate>

@end
@implementation TBBackgroundImageTableViewCell
{
    TBChoosePhotosTool * tool;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backImageView.layer.cornerRadius = 5;
    [self.backImageView setImage:[UIImage imageNamed:@"task-shangchuan-small"]];
    self.backImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *zer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicl)];
    [self.backImageView addGestureRecognizer:zer];
    
    tool = [[TBChoosePhotosTool alloc] init];
    tool.delegate = self;

}

#pragma mark  --- 点击事件 ---
// 选择照片
- (void)headClicl
{
    
    if (self.isBackImage == YES)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"重新选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
            [tool showPhotosIndex:1];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"预览大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [tool showPreviewPhotosArray:@[self.backImageView.image] baseView:self.backImageView selected:0];
        }]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
        }]];
        
        [[ZKUtil getPresentedViewController] presentViewController:alertView animated:YES completion:nil];
    }
    else
    {
        [tool showPhotosIndex:1];
    }
    
}

#pragma mark ---- TBChoosePhotosToolDelegate --

- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    [self.backImageView setImage:[images lastObject]];
    self.isBackImage = YES;
    if (self.coverImage) {
        self.coverImage([images lastObject]);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
