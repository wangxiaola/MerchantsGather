//
//  TBIdentityInformationTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBIdentityInformationTableViewCell.h"
#import "UIButton+WebCache.h"
#import "TBChoosePhotosTool.h"
#import "TBMoreReminderView.h"


NSString *const TBIdentityInformationTableViewCellID = @"TBIdentityInformationTableViewCellID";

@interface TBIdentityInformationTableViewCell ()<UITextFieldDelegate,TBChoosePhotosToolDelegate>
@property (nonatomic, strong) TBChoosePhotosTool *photosTool;
@property (nonatomic, strong) NSMutableDictionary *data;

@end
@implementation TBIdentityInformationTableViewCell
{
    
    __weak IBOutlet UIButton *onePhotoButton;
    __weak IBOutlet UIButton *twoPhotoButton;
    __weak IBOutlet UIButton *twoDeleteButton;
    __weak IBOutlet UIButton *oneDeleteButton;
    __weak IBOutlet UITextField *nameTextField;
    NSInteger _index;
    
}

- (NSMutableDictionary *)data
{
    if (!_data)
    {
        _data = [NSMutableDictionary dictionary];
    }
    return _data;
}
- (TBChoosePhotosTool *)photosTool
{
    if (!_photosTool) {
        _photosTool = [[TBChoosePhotosTool alloc] init];
        _photosTool.delegate = self;
    }
    return _photosTool;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    nameTextField.delegate = self;
    twoDeleteButton.hidden = YES;
    oneDeleteButton.hidden = YES;
    
    onePhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    onePhotoButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
    [onePhotoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    twoPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    twoPhotoButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
    [twoPhotoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)assignmentPhotos:(NSDictionary *)dictionary;
{
    self.data = dictionary.mutableCopy;
    nameTextField.text = [dictionary valueForKey:yg_name];
    [self updataPhotos];
    
}
- (void)updataPhotos
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        twoDeleteButton.hidden = YES;
        oneDeleteButton.hidden = YES;
        [self setButtonImage:onePhotoButton data:[self.data valueForKey:yg_positive] showAddButton:oneDeleteButton];
        [self setButtonImage:twoPhotoButton data:[self.data valueForKey:yg_reverse] showAddButton:twoDeleteButton];
    }];
}
- (void)setButtonImage:(UIButton *)send data:(id)data showAddButton:(UIButton *)button;
{
    if ([data isKindOfClass:[UIImage class]])
    {
        [send setImage:data forState:UIControlStateNormal];
        
        button.hidden = NO;
    }
    else if ([data isKindOfClass:[NSString class]])
    {
        NSString *url = data;
        if (url.length >200)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:url options:NSDataBase64DecodingIgnoreUnknownCharacters];
             UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
         
                [send setImage:_decodedImage forState:UIControlStateNormal];
                });
            });
            button.hidden = NO;
        }
        else if (url.length>0)
        {
            if (![url containsString:IMAGE_URL]) {
                url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
            }
            [send sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addIdentity"]];
            button.hidden = NO;
        }
        else
        {
         [send setImage:[UIImage imageNamed:@"addIdentity"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [send setImage:[UIImage imageNamed:@"addIdentity"] forState:UIControlStateNormal];
    }
    
}
#pragma mark --- 点击事件 --

- (IBAction)deletePhotos:(UIButton *)sender
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"确定要删除当前贫困员工信息"];
    TBWeakSelf
    [more showHandler:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(deleteEmployeeInformationIndex:)]) {
            [weakSelf.delegate deleteEmployeeInformationIndex:self.indexRow];
        }
    }];
}
- (IBAction)addPhotoClick:(UIButton *)sender
{
    _index = sender.tag - 1000;
    BOOL isShowDelete = NO;
    
    if (_index == 0)
    {
        isShowDelete = !oneDeleteButton.hidden;
    }
    else
    {
        isShowDelete = !twoDeleteButton.hidden;
    }
    if (isShowDelete == YES)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        TBWeakSelf
        [alertView addAction:[UIAlertAction actionWithTitle:@"重新选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.photosTool showPhotosIndex:1];
        }]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"预览大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            id photos = [self.data valueForKey:_index == 0?yg_positive:yg_reverse];
            if (photos !=nil)
            {
                [weakSelf.photosTool showPreviewPhotosArray:@[photos] baseView:sender.imageView selected:0];
            }
            else
            {
                [UIView addMJNotifierWithText:@"图片异常" dismissAutomatically:YES];
            }
            
        }]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //按钮触发的方法
        }]];
        
        [[ZKUtil getPresentedViewController] presentViewController:alertView animated:YES completion:nil];
    }
    else
    {
        [self.photosTool showPhotosIndex:2];
    }
    
}
- (IBAction)deleteAPhoto:(UIButton *)sender
{
    NSInteger tag = sender.tag - 2000;
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"是否删除当前身份证照片"];
    TBWeakSelf
    [more showHandler:^{
        
        [weakSelf.data setValue:@"" forKey:tag == 0?yg_positive:yg_reverse];
        [weakSelf updataPhotos];
        [weakSelf notifyTheDataUpdate];
    }];
    
}
- (void)notifyTheDataUpdate
{
    if ([self.delegate respondsToSelector:@selector(modifiedData:indexRow:)]) {
        [self.delegate modifiedData:self.data indexRow:self.indexRow];
    }
}
#pragma mark --UITextFieldDelegate--
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSString *name = textField.text.length == 0?@"":textField.text;
    [self.data setValue:name forKey:yg_name];
    [self notifyTheDataUpdate];
}
#pragma mark --TBChoosePhotosToolDelegate--
- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    if (images.count == 1)
    {
        [self.data setValue:images.firstObject forKey:_index == 0?yg_positive:yg_reverse];
        [self updataPhotos];
        [self notifyTheDataUpdate];
    }
    else if (images.count == 2)
    {
        [self.data setValue:images.firstObject forKey:yg_positive];
        [self.data setValue:images.lastObject forKey:yg_reverse];
        [self updataPhotos];
        [self notifyTheDataUpdate];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
