//
//  TBUploadPromptHUD.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/26.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBUploadPromptHUD : UIView

@property (strong, nonatomic) NSString *prompStr;

- (void)showViewCancelUpload:(void(^)(void))cancel;

- (void)progress:(CGFloat)offset;

- (void)hideHUD;

- (void)uploadSuccessful:(NSString*)str;

- (void)uploadErr;

@end
