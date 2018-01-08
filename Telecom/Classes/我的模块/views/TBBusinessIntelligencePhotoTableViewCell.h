//
//  TBBusinessIntelligencePhotoTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 选择照片的cell
 */
@interface TBBusinessIntelligencePhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *promptButton;

@property (strong, nonatomic) NSString *defaultName;

@property (strong, nonatomic) NSMutableArray *imageArray;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
// 默认无照片显示数量
@property (assign, nonatomic) NSInteger defaultRow;
/**
 更新TableView
 */
@property (nonatomic, copy) void(^updataTableView)(void);

- (void)updataCollectionView;

@end
