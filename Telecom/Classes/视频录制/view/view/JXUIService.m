//
//  JXUIService.m
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXUIService.h"
#import "JXVideoImagePickerCell.h"
#import "JXVideoImageGenerator.h"


@interface JXUIService ()

@property(nonatomic, strong) NSArray <JXVideoImage *>*displayKeyframeImages;

@property (nonatomic, assign) NSInteger scrollHDTag;
@end
@implementation JXUIService



- (void)loadData:(AVAsset *)asset callBlock:(void(^)())callBlock{
    
    [JXVideoImageGenerator generateDefaultSequenceOfImagesFromAsset:asset closure:^(NSArray<JXVideoImage *> *images) {
        
        self.displayKeyframeImages = images;
        JXVideoImage *img = images.firstObject;
        self.mrImage = img.image;
        callBlock();
    }];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.displayKeyframeImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JXVideoImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoCellIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor redColor];
    cell.videoImage = self.displayKeyframeImages[indexPath.row];
    
    return cell;
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.asset == nil) {
        return;
    }
    if (self.scrollHDTag == 2) {
    }
    else
    {
        self.scrollHDTag += 1;
        return;
    }
    // 视频图片总长度
    CGFloat videoTrackLength = KeyframePickerViewCellWidth *self.displayKeyframeImages.count;
    
    // 当前点
    CGFloat position = scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width * 0.5;
    
    // 越值处理
    if (position < 0) {
        position = 0;
    }else if (position > videoTrackLength){
        position = videoTrackLength;
    }
    
    position = MAX(position, 0);
    position = MIN(position, videoTrackLength);
    

    CGFloat percent = position / videoTrackLength;
    
    CGFloat totalSecond = self.asset.duration.value / self.asset.duration.timescale;
    
    CGFloat currentSecond = totalSecond * percent;

    
    currentSecond = MAX(currentSecond, 0);
    currentSecond = MIN(currentSecond,totalSecond);
    
    // 时间
    
    CMTime currentTime = CMTimeMakeWithSeconds(currentSecond, self.asset.duration.timescale);
    
    
    // 回调
    if (self.scrollDidBlock) {
        self.scrollDidBlock(currentTime);
    }
    
}



@end
