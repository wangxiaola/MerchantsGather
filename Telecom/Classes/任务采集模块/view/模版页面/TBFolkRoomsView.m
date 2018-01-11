//
//  TBFolkRoomsView.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBFolkRoomsView.h"
#import "TBFolkRoomsContenView.h"
#import "TBRoomListTableViewController.h"

@interface TBFolkRoomsView ()<TBFolkRoomsContenViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
@implementation TBFolkRoomsView
{
    TBFolkRoomsContenView *_contenView;
    
}
- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        [self initContenView];
    }
    return self;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initContenView
{
    _contenView = [TBFolkRoomsContenView loadingNibConetenViewWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT)];
    _contenView.delegate = self;
    [self addSubview:_contenView];
    TBWeakSelf
    [_contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}
#pragma mark ----

/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int k = 0; k<makingList.roomDatas.count; k++) {
            NSDictionary *dic = makingList.roomDatas[k];
            
            id ims = [dic valueForKey:@"img"];
            NSMutableArray *images;
            
            if ([ims isKindOfClass:[NSString class]])
            {
                images = [(NSString *)ims componentsSeparatedByString:@","].mutableCopy;
            }
            else
            {
                images = [ims mutableCopy];
                for (int i = 0; i<images.count; i++)
                {
                    id image = images[i];
                    
                    if ([image isKindOfClass:[NSString class]])
                    {
                        NSString *data = image;
                        if (data.length >200)
                        {
                            NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
                            UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
                            if (_decodedImage)
                            {
                                [images replaceObjectAtIndex:i withObject:_decodedImage];
                            }
                            else
                            {
                                [images removeObjectAtIndex:i];
                            }
                        }
                    }
                }
            }
           
            NSDictionary *dictionary = @{@"img":images.copy,
                                         @"type":[dic valueForKey:@"type"],
                                         @"price":[dic valueForKey:@"price"],
                                         @"number":[dic valueForKey:@"number"]};
            [self.makingList.roomDatas replaceObjectAtIndex:k withObject:dictionary];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
         [self.dataArray addObjectsFromArray:makingList.roomDatas];
        });
    });
    
     return @{@"name":@"客房信息",@"prompt":@"(必填)"};
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    self.makingList.roomDatas = self.dataArray;
    
    self.makingList.preferentialDic = @{@"money":@"5",
                                        @"selfmoney":@"0",
                                        @"num":@"99999",
                                        @"ucondit":@"0",
                                        @"sdate":@"",
                                        @"edate":@"",
                                        @"id":@"",
                                        @"stype":@"hong",
                                        };
    self.makingList.discountCardDic = @{@"money":@"9.5",
                                        @"selfmoney":@"0",
                                        @"num":@"99999",
                                        @"ucondit":@"0",
                                        @"sdate":@"",
                                        @"edate":@"",
                                        @"id":@"",
                                        @"stype":@"ka",
                                        };
    
    self.makingList.povertyInfoDic = @{@"totalNum":@"0",
                                       @"below20Num":@"0",
                                       @"below35Num":@"0",
                                       @"below50Num":@"0",
                                       @"below65Num":@"0",
                                       @"above65Num":@"0",
                                       @"menNum":@"0",
                                       @"womanNum":@"0",
                                       @"lowSalary":@"0",
                                       @"highSalary":@"0",};
    
    if (self.makingList.roomDatas.count == 0) {
        prompt == NO ? :[UIView addMJNotifierWithText:@"客房至少添加一个" dismissAutomatically:YES];
        return NO;
    }
    return YES;
    
}

#pragma mark  ----TBFolkRoomsContenViewDelegate----
/**
 增加房型
 
 @param data 房型数据
 */
- (void)increaseTheGuestRoomData:(NSDictionary *)data;
{
    [self.dataArray addObject:data];
    [UIView addMJNotifierWithText:@"客房信息添加成功" dismissAutomatically:YES];
}
/**
 查看所有房型
 */
- (void)lookAtAllTheRoom;
{
    TBRoomListTableViewController *vc = [[TBRoomListTableViewController alloc] init];
    vc.roomData = self.dataArray;

    [[[ZKUtil getCurrentVC] navigationController] pushViewController:vc animated:YES];
}
@end
