//
//  TBBackMusicChooseView.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/22.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBackMusicChooseView.h"
#import "TBMusicPageCell.h"
#import "TBMusicPlayTool.h"

@interface TBBackMusicChooseView () <UIScrollViewDelegate> {
    
    CGFloat itemWidth;
    CGFloat itemHeight;
    
    CGFloat  _contenViewHeight;
    UIView   *_contenView;// 中心view
    UILabel  *_stateLabel;// 状态显示
    UIButton *_completeButton;
    UIView   *_pageCollectionView;
    
    NSArray  *_titleArray;
    
    TBMusicPlayTool *_musicTool;
    
    NSURL    *_url;
}
// 一行中 cell 的个数，根据每行的个数来决定宽度
@property (nonatomic,assign) NSUInteger itemCountPerRow;
/*
 * 一页显示多少行，根据每行数来决定高度
 *  当设置为NSNotFound时，只显示一页
 */
@property (nonatomic,assign) NSUInteger rowCount;

@property (nonatomic, strong) NSMutableArray <NSDictionary *> *dataSource;
@property (nonatomic, strong) NSMutableArray <TBMusicPageCell *>*viewData;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end
@implementation TBBackMusicChooseView


- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT)];
    if (self) {
        [self createData];
        [self createViews];
        [self reloadData];
    }
    return self;
}
- (void)createData
{
    _musicTool = [TBMusicPlayTool sharedAVAudioPlayer];
    
    self.itemCountPerRow = 3;
    self.rowCount        = 2;
    _titleArray          = @[@"动感",@"欢快",@"舒缓"];
    for (int i = 0; i<18; i++) {
        
        NSString *name_qz = @"";
        NSString *path_qz = @"";
        int  row          = 0;
        if (i < 6) {
            name_qz = @"动感";
            path_qz = @"dg";
            row     = i+1;
        }
        else if (i<12)
        {
            name_qz = @"欢快";
            path_qz = @"hk";
            row = i - 5;
        }
        else
        {
            name_qz = @"舒缓";
            path_qz = @"sh";
            row = i - 11;
        }
        NSString *name = [NSString stringWithFormat:@"%@-%d",name_qz,row];
        NSString *path = [NSString stringWithFormat:@"%@_%d",path_qz,row - 1];
        
        NSDictionary *dic = @{@"name":name,
                              @"path":path};
        [self.dataSource addObject:dic];
    }
}
#pragma mark  ----视图创建----
- (void)createViews
{
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    
    _contenViewHeight = (_SCREEN_HEIGHT - 64) / 2 ;
    
    _contenView = [[UIView alloc] initWithFrame:CGRectMake(0, _SCREEN_HEIGHT, _SCREEN_WIDTH, _contenViewHeight)];
    _contenView.backgroundColor = RGB(14, 14, 14);
    [self addSubview:_contenView];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, _SCREEN_WIDTH, 0.5)];
    viewLine.backgroundColor = RGB(101, 101, 101);
    [_contenView addSubview:viewLine];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_contenView addSubview:cancelButton];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.text = _titleArray.firstObject;
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.textColor = RGB(111, 111, 111);
    _stateLabel.font = [UIFont systemFontOfSize:14];
    [_contenView addSubview:_stateLabel];
    
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _completeButton.alpha = 0.0;
    _completeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_completeButton addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    [_contenView addSubview:_completeButton];
    
    _pageCollectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, _SCREEN_WIDTH, _contenViewHeight - 50)];
    [_contenView addSubview:_pageCollectionView];
    
    [_pageCollectionView addSubview:self.mainScrollView];
    [_pageCollectionView addSubview:self.pageControl];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_contenView);
        make.bottom.equalTo(viewLine.mas_top);
        make.width.equalTo(@60);
    }];
    
    
    [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_contenView);
        make.bottom.equalTo(viewLine.mas_top);
        make.width.equalTo(@60);
    }];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelButton.mas_right);
        make.right.equalTo(_completeButton.mas_left);
        make.top.equalTo(_contenView.mas_top);
        make.bottom.equalTo(viewLine.mas_top);
    }];
}
- (void)reloadData {
    
    if (!self.dataSource) {
        return;
    }
    [self.mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat margin = 14;
    
    // 实际总宽度 ＝ 总宽度－（每行个数 ＋ 1）为总宽度－（每个item的间距＋行首的缩进），实际总宽度／每行个数＝》每个item宽度
    itemWidth = (CGRectGetWidth(self.mainScrollView.frame) - (self.itemCountPerRow * margin + margin)) / self.itemCountPerRow;
    itemHeight = (CGRectGetHeight(self.mainScrollView.frame) - margin*(self.rowCount+1))/self.rowCount;
    
    /* 废弃
     * 过程：
     * 1.计算所需总页数； 2.创建每页的单独视图（single page）； 3.创建单页数据； 4.在单页中进行自左向右的排序；
     * 5.添加单页到scroll上， 6.在单页上点击cell时，根据page和cell在单页中的位置转换cell到scroll中的位置；
     */
    
    /* 优化
     * 1.计算所需总页数； 2.确定每页应该包涵的条数，除最后一页其他均应该满铺，最后一页条数由‘总条数’－‘已使用总和’； 3.在单页中进行操作； 4.在单页中进行自左向右的排序； 5.在单页上； 6.在单页上点击cell时，根据page和cell在单页中的位置转换cell到scroll中的位置；
     */
    
    if (self.rowCount == NSNotFound) {
        self.rowCount = self.dataSource.count / self.itemCountPerRow;
        self.pageControl.hidden = YES;
    }
    
    NSInteger itemTotalCount = self.dataSource.count;
    NSInteger itemCountPerPage = self.rowCount * self.itemCountPerRow;
    // '/'计算可铺满的页数，'％'计算是否还有未能铺满页。％结果为0，说明正好全部铺满，有余数说明未铺满，且余数即为未能铺满页的item条数
    NSInteger pageCount = (itemTotalCount / itemCountPerPage) + (itemTotalCount % itemCountPerPage == 0 ? 0 : 1);
    
    
    // 分页计算
    for (int page = 0; page < pageCount; page++) {
        NSInteger itemCountOfCurrentPage = page < pageCount - 1 ? itemCountPerPage : (itemTotalCount - (pageCount - 1) * itemCountPerPage);
        // 计算每页中的item
        for (int i = 0; i < itemCountOfCurrentPage; i++) {
            
            NSInteger index = i + page * itemCountPerPage;
            NSDictionary *params = self.dataSource[index];
            // 分页的位置 + 在单页中的位置，即单前item的位置
            // X、Y最后 + 1，目的是第一列第一行距顶部左边为1，itemWidth、itemHeight + 1目的是为行每列增加间距
            CGFloat cellX = page * self.mainScrollView.frame.size.width + (i % self.itemCountPerRow) * (itemWidth + margin) + margin;
            CGFloat cellY =                                               (i / self.itemCountPerRow) * (itemHeight + margin) + margin;
            
            TBMusicPageCell *cell = [[TBMusicPageCell alloc] initWithFrame:CGRectMake(cellX, cellY, itemWidth, itemHeight)];
            cell.params = params;
            
            [self.mainScrollView addSubview:cell];
            [self.viewData addObject:cell];
            
            UIButton *bty = [UIButton buttonWithType:UIButtonTypeCustom];
            [bty addTarget:self action:@selector(pageCellClick:) forControlEvents:UIControlEventTouchUpInside];
            bty.tag = index + 1000;
            bty.backgroundColor = [UIColor clearColor];
            bty.frame = CGRectMake(0, 0, itemWidth, itemHeight);
            [cell addSubview:bty];
            
        }
        
    }
    
    
    // 设置滚动方向
    CGSize contentSize = self.mainScrollView.contentSize;
    contentSize.width = pageCount * self.mainScrollView.frame.size.width;
    contentSize.height = itemHeight * self.rowCount;
    self.mainScrollView.contentSize = contentSize;
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
}

- (void)pageCellClick:(UIButton *)sender {
    
    NSInteger itemIndex = sender.tag - 1000;
    
    [self.viewData enumerateObjectsUsingBlock:^(TBMusicPageCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == itemIndex) {
            
            if (obj.isShoose)
            {
                [obj deleteViewBezel];
                _completeButton.alpha = 0.0;
                _url = nil;
                [_musicTool destruction];
            }
            else
            {
                [obj modifyViewBezel];
                [self playMusicData:obj.params];
                _completeButton.alpha = 1.0;
            }
        }
        else
        {
            [obj deleteViewBezel];
        }
    }];
}
- (void)playMusicData:(NSDictionary *)dic
{
    NSString *path = dic[@"path"];
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:path withExtension:@"mp3"];
    _url = fileUrl;
    [_musicTool playMusicWithMusicUrl:fileUrl];
    
}
#pragma mark  ----UIScrollViewDelegate----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = self.mainScrollView.contentOffset.x;
    NSInteger pageIndex = offsetX / CGRectGetWidth(self.mainScrollView.frame);
    self.pageControl.currentPage = pageIndex;
    _stateLabel.text = _titleArray[pageIndex];
}

#pragma mark  ----点击事件----
// 取消
- (void)cancelClick
{
    if (self.musicSuccess) {
        self.musicSuccess(nil);
    }
    [self disappear];
}
// 完成
- (void)completeClick
{
    if (_url && self.musicSuccess ) {
        
        self.musicSuccess(_url);
    }
    [self disappear];
    
}
#pragma mark  ----show----

- (void)showViewChooseSuccess:(ChooseMuSicSuccess)success
{
    self.musicSuccess = success;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _contenView.frame = CGRectMake(0, _SCREEN_HEIGHT - _contenViewHeight, _SCREEN_WIDTH, _contenViewHeight);
        
    }];
}
/**
 消失
 */
- (void)disappear
{
    [_musicTool destruction];
    _musicTool = nil;
    [UIView animateWithDuration:0.2 animations:^{
        _contenView.frame = CGRectMake(0, _SCREEN_HEIGHT, _SCREEN_WIDTH, _contenViewHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
#pragma mark  ----懒加载----
- (NSMutableArray<TBMusicPageCell *> *)viewData
{
    if (_viewData == nil) {
        _viewData = [NSMutableArray arrayWithCapacity:1];
    }
    return _viewData;
}
- (NSMutableArray<NSDictionary *> *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSource;
}
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _pageCollectionView.frame.size.width, _pageCollectionView.frame.size.height - 30)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageCollectionView.frame.size.height - 40, CGRectGetWidth(_pageCollectionView.bounds), 40)];
    }
    return _pageControl;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
