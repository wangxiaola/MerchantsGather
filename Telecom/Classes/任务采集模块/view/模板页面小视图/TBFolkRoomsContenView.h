//
//  TBFolkRoomsContenView.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBFolkRoomsContenViewDelegate <NSObject>

@optional

/**
 增加房型

 @param data 房型数据
 */
- (void)increaseTheGuestRoomData:(NSDictionary *)data;

/**
 查看所有房型
 */
- (void)lookAtAllTheRoom;

@end

@interface TBFolkRoomsContenView : UIView

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (nonatomic) CGRect contenFrame;

@property (assign, nonatomic) CGFloat  cellWidth;

// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
// 默认无照片显示数量
@property (assign, nonatomic) NSInteger defaultRow;

@property (strong, nonatomic) NSString *defaultName;

/**
 加载view
 
 @param frame frame
 @return self
 */
+ (TBFolkRoomsContenView *)loadingNibConetenViewWithFrame:(CGRect)frame;

- (void)updataCollectionView;

@property (nonatomic, weak)id<TBFolkRoomsContenViewDelegate>delegate;

@end
