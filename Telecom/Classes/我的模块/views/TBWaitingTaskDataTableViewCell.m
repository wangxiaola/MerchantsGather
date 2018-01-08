//
//  TBWaitingTaskDataTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

NSString *const TBWaitingTaskDataTableViewCellID = @"TBWaitingTaskDataTableViewCellID";

#import "TBWaitingTaskDataTableViewCell.h"
#import "TBMakingListMode.h"
#import "TBBasicDataTool.h"

@interface TBWaitingTaskDataTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *labeBackView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *adderssLabel;


@end
@implementation TBWaitingTaskDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImage *taskImage = [UIImage imageNamed:@"tast_bsh"];
    [taskImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.5, 0.5, 0, 0)];
    [self.labeBackView setImage:taskImage];
    self.headerImageView.layer.cornerRadius = 3;
    self.headerImageView.layer.masksToBounds = YES;
}
- (void)updataCell:(TBMakingListMode *)list packageArray:(NSArray <TBPackageData *>*)types;
{
    NSDictionary *dic = list.infoDic;
    self.nameLabel.text = [self cellText:[dic valueForKey:@"name"]];
    
    self.labeBackView.hidden = YES;
    self.typeLabel.hidden = YES;
    TBWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block  NSString *strName = @"";
        [types enumerateObjectsUsingBlock:^(TBPackageData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (list.modelsID == obj.ID)
            {
                strName = [weakSelf cellText:[NSString stringWithFormat:@"%@元套餐",obj.price]];
                
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (strName.length >0)
            {
                weakSelf.typeLabel.text = strName;
                weakSelf.labeBackView.hidden = NO;
                weakSelf.typeLabel.hidden = NO;
            }

        });
    });

    
    if ([list.type isEqualToString:@"service"])
    {
        self.taskTypeLabel.text = @"服务场所";
        [self updateloadImage:list.images.firstObject];
    }
    else
    {

        self.taskTypeLabel.text = [self cellText:[dic valueForKey:@"taskType"]];
        
        id imageData;
        if ( list.coverPhotoUrl.length>0)
        {
            imageData = list.coverPhotoUrl;
        }
        else if ([list.coverPhotoData isKindOfClass:[NSData class]])
        {
            imageData = list.coverPhotoData;
        }
        else if (list.appearancePhotos.count>0)
        {
            imageData =  list.appearancePhotos.firstObject;
        }
        else
        {
            imageData = [UIImage imageNamed:@"homeDefault"];
        }
        [self updateloadImage:imageData];
    }
    
    self.telLabel.text = [self cellText:[dic valueForKey:@"tel"]];
    self.adderssLabel.text = [self cellText:[dic valueForKey:@"address"]];
    
    [self layoutIfNeeded];
}
- (void)updateloadImage:(id )data
{
    if ([data isKindOfClass:[NSString class]])
    {
        NSString *url = data;
        
        if (url.length == 0)
        {
            self.headerImageView.image = [UIImage imageNamed:@"homeDefault"];
        }
        else if (url.length < 100)
        {
            
            [ZKUtil downloadImage:self.headerImageView imageUrl:[self cellText:url] duImageName:@"homeDefault"];
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
  
                NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:url options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.headerImageView.image = _decodedImage;
                });
            });

        }
    }
    else if ([data isKindOfClass:[NSData class]])
    {
        UIImage *image = [UIImage imageWithData:data];
        self.headerImageView.image = image;
    }
    else
    {
        self.headerImageView.image = [UIImage imageNamed:@"homeDefault"];
    }
}
- (NSString *)cellText:(NSString *)name
{
    if (name.length == 0 ||[name isKindOfClass:[NSNull class]])
    {
        return @"--";
    }
    return name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
