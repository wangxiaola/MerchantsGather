//
//  HXTagsView.m
//  黄轩 https://github.com/huangxuan518
//
//  Created by 黄轩 on 16/1/13.
//  Copyright © 2015年 IT小子. All rights reserved.
//

#import "HXTagsView.h"
#import "HXTagCollectionViewCell.h"
#import "HXTagAttribute.h"

@interface HXTagsView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation HXTagsView

static NSString * const reuseIdentifier = @"HXTagCollectionViewCellId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    //初始化样式
    _tagAttribute = [HXTagAttribute new];
    
    self.layout = [[HXTagCollectionViewFlowLayout alloc] init];
    [self addSubview:self.collectionView];
    
    if (_layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //垂直
        self.collectionView.showsVerticalScrollIndicator = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    } else {
        self.collectionView.showsHorizontalScrollIndicator = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
    }
    self.selectMax = MAXFLOAT;
    
    self.collectionView.frame = self.bounds;
    
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXTagCollectionViewFlowLayout *layout = (HXTagCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [_tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_tagAttribute.titleSize]} context:nil];
    
    return CGSizeMake(frame.size.width + _tagAttribute.tagSpace, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = _tagAttribute.normalBackgroundColor;
    cell.layer.borderColor = BODER_COLOR.CGColor;
    cell.layer.borderWidth = 0.5;
    cell.layer.cornerRadius = cell.frame.size.height/2;
    cell.titleLabel.textColor = _tagAttribute.textColor;
    cell.titleLabel.font = [UIFont systemFontOfSize:_tagAttribute.titleSize];
    
    NSString *title = self.tags[indexPath.item];
    
    if (_key.length > 0) {
        cell.titleLabel.attributedText = [self searchTitle:title key:_key keyColor:_tagAttribute.selectedLabelBackgroundColor];
        
        if ([_key isEqualToString:title])
        {
            cell.layer.borderWidth = 0.5;
            cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
        }
    } else {
        cell.titleLabel.text = title;
    }
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
        cell.titleLabel.textColor = _tagAttribute.selectedLabelBackgroundColor;
        cell.layer.borderWidth = 0.0;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXTagCollectionViewCell *cell = (HXTagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = _tagAttribute.normalBackgroundColor;
        cell.titleLabel.textColor = _tagAttribute.textColor;
        cell.layer.borderWidth = 0.5;
        [self.selectedTags removeObject:self.tags[indexPath.item]];
        if (self.originalData.count >0)
        {
            NSString *key = self.originalData[indexPath.item];
            [self.originalTags removeObject:key];
        }
    }
    else {
        if (_isMultiSelect) {
            
            if (self.selectedTags.count == self.selectMax)
            {
                if (self.selectMaxNumber)
                {
                    self.selectMaxNumber();
                }
            }
            else
            {
                cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
                cell.titleLabel.textColor = _tagAttribute.selectedLabelBackgroundColor;
                cell.layer.borderWidth = 0.0;
                [self.selectedTags addObject:self.tags[indexPath.item]];
                if (self.originalData.count >0)
                {
                    NSString *keyID = self.originalData[indexPath.item];
                    [self.originalTags addObject:keyID];
                }
            }
            
        } else {
            [self.selectedTags removeAllObjects];
            [self.selectedTags addObject:self.tags[indexPath.item]];
            [self.originalTags removeAllObjects];
            if (self.originalData.count >0)
            {
                NSString *keyID = self.originalData[indexPath.item];
                [self.originalTags addObject:keyID];
            }
            
            [self reloadData];
        }
    }
    
    if (_completion) {
        _completion(self.selectedTags,indexPath.item);
    }
    
    if (_completionOriginal) {
        _completionOriginal(self.originalTags);
    }
}

// 设置文字中关键字高亮
- (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor {
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSString *copyStr = title;
    
    NSMutableString *xxstr = [NSMutableString new];
    for (int i = 0; i < key.length; i++) {
        [xxstr appendString:@"*"];
    }
    
    while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
        
        [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
        copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
    }
    return titleStr;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

#pragma mark - 懒加载
- (NSMutableArray *)originalTags
{
    if (_originalTags == nil)
    {
        _originalTags = [NSMutableArray array];
    }
    return _originalTags;
}
- (NSMutableArray *)selectedTags
{
    if (!_selectedTags) {
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[HXTagCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    _collectionView.collectionViewLayout = _layout;
    
    return _collectionView;
}

+ (CGFloat)getHeightWithTags:(NSArray *)tags layout:(HXTagCollectionViewFlowLayout *)layout tagAttribute:(HXTagAttribute *)tagAttribute width:(CGFloat)width
{
    CGFloat contentHeight;
    
    if (!layout) {
        layout = [[HXTagCollectionViewFlowLayout alloc] init];
    }
    
    if (tagAttribute.titleSize <= 0) {
        tagAttribute = [[HXTagAttribute alloc] init];
    }
    
    //cell的高度 = 顶部 + 高度
    contentHeight = layout.sectionInset.top + layout.itemSize.height;
    
    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    
    NSInteger itemCount = tags.count;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        
        CGRect frame = [tags[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:tagAttribute.titleSize]} context:nil];
        
        CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagSpace, layout.itemSize.height);
        
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            //垂直滚动
            if ((originX + itemSize.width + layout.sectionInset.right/2) > width) {
                originX = layout.sectionInset.left;
                originY += itemSize.height + layout.minimumLineSpacing;
                
                contentHeight += itemSize.height + layout.minimumLineSpacing;
            }
        }
        
        originX += itemSize.width + layout.minimumInteritemSpacing;
    }
    
    contentHeight += layout.sectionInset.bottom;
    return contentHeight;
}

@end
