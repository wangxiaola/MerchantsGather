//
//  ProcessBar.m
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-13.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

#import "ProgressBar.h"
#import "TBTBProgressButton.h"
#import "SBCaptureToolKit.h"

#define BAR_BLUE_COLOR      NAVIGATION_COLOR// 进度
#define BAR_RED_COLOR       UIColorFromRGB(0xfa5a5a, 1)// 要删除的进度色
#define BAR_BG_COLOR        UIColorFromRGB(0x808080, 1)// 进度背景色
#define BAR_SELECT_COLOR    UIColorFromRGB(0xFF0000, 1)// 进度头

#define NODES_W             2
#define BAR_H               10
#define BAR_MIN_W           75
#define TIMER_INTERVAL      1.0f

@interface ProgressBar ()

@property (strong, nonatomic) UIView *barView;


@property (strong, nonatomic) NSMutableArray *nodesViews;
@end

@implementation ProgressBar
- (NSMutableArray *)nodesViews
{
    if (!_nodesViews) {
        _nodesViews = [NSMutableArray arrayWithCapacity:1];
    }
    return _nodesViews;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initalize];
    }
    return self;
}

- (void)initalize
{
    self.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = BAR_BG_COLOR;
    self.progressViewArray = [[NSMutableArray alloc] init];
    
    //barView
    self.barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, BAR_H)];
    _barView.backgroundColor = BAR_BG_COLOR;
    [self addSubview:_barView];
    
}
/**
 更新节点数量
 
 @param number 数量
 */
- (void)updateViewNodesNumber:(NSInteger)number;
{
    [_nodesViews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (number > 1) {
        
        CGFloat nodesWidth    = NODES_W;
        CGFloat nodesinterval = (_SCREEN_WIDTH - number*nodesWidth)/number;
        for (int i = 1; i<number; i++) {
            
            UIView *nodesView = [self getNodesView];
            nodesView.frame = CGRectMake(nodesinterval * i + nodesWidth*(i-1), -1, nodesWidth, BAR_H + 2);
            [_barView insertSubview:nodesView atIndex:1];
            [self.nodesViews addObject:nodesView];
        }
        
    }
    
}
- (UIView *)getNodesView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}
- (UIView *)getProgressView
{
    TBTBProgressButton *progressView = [[TBTBProgressButton alloc] initWithFrame:CGRectMake(0, 0, 1, BAR_H) addTarget:self buttonAction:@selector(progressViewClick:)];
    progressView.backgroundColor = BAR_BLUE_COLOR;
    progressView.autoresizesSubviews = YES;
    progressView.tag = _progressViewArray.count;
    
    return progressView;
}

- (void)refreshCurrentView:(NSInteger)idx andWidth:(CGFloat)width {
    
    if (self.progressViewArray.count == 0) {
        return;
    }
    
    for (int i = 0; i < self.progressViewArray.count; i++) {
        
        if (i > idx) {
            
            UIView * foreProgressView = self.progressViewArray[i-1];
            CGRect foreViewFrame = foreProgressView.frame;
            
            UIView *currentProgressView = self.progressViewArray[i];
            CGRect frame = currentProgressView.frame;
            frame.origin.x = foreViewFrame.origin.x+foreViewFrame.size.width+NODES_W;
            
            if (i == idx) {
                frame.size.width = width - NODES_W;
            }
            
            currentProgressView.frame = frame;
        }
        else {
            UIView *currentProgressView = self.progressViewArray[idx];
            CGRect frame = currentProgressView.frame;
            frame.size.width = width - NODES_W;
            currentProgressView.frame = frame;
        }
    }
}

#pragma mark  ----touch----
- (void)progressViewClick:(UIButton *)bty
{
    UIView *view = bty.superview;
    NSInteger index = view.tag;
    [self progressViewResetAll];
    [self setCurrentProgressToStyle:ProgressBarProgressStyleSelect andIndex:index];
    if ([self.delegate respondsToSelector:@selector(progressViewSelected:)]) {
        [self.delegate progressViewSelected:index];
    }
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    TBWeakSelf
    [alertView addAction:[UIAlertAction actionWithTitle:@"重新录制本段视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setCurrentProgressToStyle:ProgressBarProgressStyleNormal andIndex:index];
        if ([weakSelf.delegate respondsToSelector:@selector(reRecordingInsertTheSegment:)] ) {
            [weakSelf.delegate reRecordingInsertTheSegment:index];
        }
        
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"替换为本地视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setCurrentProgressToStyle:ProgressBarProgressStyleNormal andIndex:index];
        if ([weakSelf.delegate respondsToSelector:@selector(replacePhotoVideoInsertTheSegment:)] ) {
            [weakSelf.delegate replacePhotoVideoInsertTheSegment:index];
        }
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"删除本段视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self setCurrentProgressToStyle:ProgressBarProgressStyleNormal andIndex:index];
        if ([weakSelf.delegate respondsToSelector:@selector(deleteTheSegment:)] ) {
            [weakSelf.delegate deleteTheSegment:index];
        }
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //按钮触发的方法
        [self setCurrentProgressToStyle:ProgressBarProgressStyleNormal andIndex:index];
    }]];
    
    [[ZKUtil getPresentedViewController] presentViewController:alertView animated:YES completion:nil];
    
}

#pragma mark - method

- (void)addProgressView
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    CGFloat newProgressX = 0.0f;
    
    if (lastProgressView) {
        CGRect frame = lastProgressView.frame;
        lastProgressView.frame = frame;
        
        newProgressX = frame.origin.x + frame.size.width + NODES_W;
    }
    
    UIView *newProgressView = [self getProgressView];
    
    [SBCaptureToolKit setView:newProgressView toOriginX:newProgressX];
    [_barView insertSubview:newProgressView atIndex:0];
    [_progressViewArray addObject:newProgressView];
}

- (void)setLastProgressToWidth:(CGFloat)width
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [SBCaptureToolKit setView:lastProgressView toSizeWidth:width];
}

- (void)setCurrentProgressToWidth:(CGFloat)width {
    
    UIView *lastProgressView = [_progressViewArray lastObject];
    CGFloat newProgressX = 0.0f;
    if (!lastProgressView) {
        UIView *newProgressView = [self getProgressView];
        [SBCaptureToolKit setView:newProgressView toOriginX:newProgressX];
        [SBCaptureToolKit setView:newProgressView toSizeWidth:width - NODES_W];
        [_barView addSubview:newProgressView];
        [_progressViewArray addObject:newProgressView];
    }
    else {
        CGRect frame = lastProgressView.frame;
        frame.size.width -= NODES_W;
        lastProgressView.frame = frame;
        
        newProgressX = frame.origin.x + frame.size.width + NODES_W;
        
        UIView *newProgressView = [self getProgressView];
        [SBCaptureToolKit setView:newProgressView toOriginX:newProgressX];
        [SBCaptureToolKit setView:newProgressView toSizeWidth:width];
        [_barView addSubview:newProgressView];
        [_progressViewArray addObject:newProgressView];
    }
    
}
- (void)progressViewResetAll
{
    [_progressViewArray enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger index, BOOL * _Nonnull stop) {
        
        obj.backgroundColor = BAR_BLUE_COLOR;
    }];
}
- (void)setCurrentProgressToStyle:(ProgressBarProgressStyle)style andIndex:(NSInteger)idx {
    
    UIView * currentProgressView = [_progressViewArray objectAtIndex:idx];
    if (!currentProgressView) {
        return;
    }
    
    switch (style) {
        case ProgressBarProgressStyleSelect:
        {
            currentProgressView.backgroundColor = BAR_SELECT_COLOR;
        }
            break;
        case ProgressBarProgressStyleDelete:
        {
            currentProgressView.backgroundColor = BAR_SELECT_COLOR;
        }
            break;
        case ProgressBarProgressStyleNormal:
        {
            currentProgressView.backgroundColor = BAR_BLUE_COLOR;
        }
            break;
        default:
            break;
    }
    
}

- (void)setLastProgressToStyle:(ProgressBarProgressStyle)style
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (lastProgressView) {
        
        switch (style) {
            case ProgressBarProgressStyleDelete:
            {
                lastProgressView.backgroundColor = BAR_RED_COLOR;
                
            }
                break;
            case ProgressBarProgressStyleNormal:
            {
                lastProgressView.backgroundColor = BAR_BLUE_COLOR;
                
            }
                break;
            default:
                break;
        }
    }
    
}

- (void)deleteLastProgress
{
    UIView *lastProgressView = [_progressViewArray lastObject];
    if (!lastProgressView) {
        return;
    }
    
    [lastProgressView removeFromSuperview];
    [_progressViewArray removeLastObject];
    
}
- (void)deleteTheSegmentProgress:(NSInteger)index;
{
    UIView *progressView = _progressViewArray[index];
    if (!progressView) {
        return;
    }
    [progressView removeFromSuperview];
    [_progressViewArray removeObjectAtIndex:index];
    
    CGFloat newProgressX = 0.0f;
    for (int i = 0; i<_progressViewArray.count; i++) {
        UIView *view = _progressViewArray[i];
        view.tag = i;
        view.frame = CGRectMake(newProgressX, 0, view.frame.size.width, BAR_H);
        newProgressX = newProgressX + view.frame.size.width + NODES_W;
    }
    
}
- (void)removeAllSubViews {
    for (UIView * v in self.progressViewArray) {
        [v removeFromSuperview];
    }
    [self.progressViewArray removeAllObjects];
}

+ (ProgressBar *)getInstance
{
    ProgressBar *progressBar = [[ProgressBar alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, BAR_H)];
    return progressBar;
}

@end

