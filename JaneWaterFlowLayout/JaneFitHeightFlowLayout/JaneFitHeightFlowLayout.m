//
//  JaneFitHeightFlowLayout.m
//  JaneWaterFlowLayout
//
//  Created by Jane on 2018/1/31.
//  Copyright © 2018 jane. All rights reserved.
//

#import "JaneFitHeightFlowLayout.h"

/** 默认的列数 */
static const NSInteger JaneDefaultColumCount = 3;

/** 每一列之间的间距 */
static const CGFloat JaneDefaultColumMargin = 10;

/** 每一行之间的间距 */
static const CGFloat JaneDefaultRowMargin = 10;

/** 边缘间距 */
static const UIEdgeInsets JaneDefaultEdgeInsets = {10, 10, 10, 10};

@interface JaneFitHeightFlowLayout()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong)NSMutableArray *attributesArr;
/** 存放所有列的当前高度 */
@property (nonatomic, strong)NSMutableArray *columHeightArr;

/// 布局内容累计高度
@property (nonatomic, assign)CGFloat contentHeight;

/// 记录之前布局组的索引
@property (nonatomic, assign)NSInteger preSection;

/// 记录当前组头底部位置
@property (nonatomic, assign)CGFloat sectionHeaderMaxY;

/// 组头组尾累计高度
@property (nonatomic, assign)CGFloat supplementaryViewHeight;


- (NSInteger)columnCount;
- (CGFloat)columnMarigin;
- (CGFloat)rowMarigin;
- (UIEdgeInsets)edgeInsets;

- (NSInteger)columnCountAt:(NSInteger)section;

@end

@implementation JaneFitHeightFlowLayout

- (NSInteger)columnCount
{
    if (_delegate && [_delegate respondsToSelector:@selector(columnCountIn:)]) {
        return [_delegate columnCountIn:self];
    }else{
        return JaneDefaultColumCount;
    }
}

- (CGFloat)columnMarigin
{
    if (_delegate && [_delegate respondsToSelector:@selector(columnMariginIn:)]) {
        return [_delegate columnMariginIn:self];
    }else{
        return JaneDefaultColumMargin;
    }
}

- (CGFloat)rowMarigin
{
    if (_delegate && [_delegate respondsToSelector:@selector(rowMariginIn:)]) {
        return [_delegate rowMariginIn:self];
    }else{
        return JaneDefaultRowMargin;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if (_delegate && [_delegate respondsToSelector:@selector(edgeInsetsIn:)]) {
        return [_delegate edgeInsetsIn:self];
    }else{
        return JaneDefaultEdgeInsets;
    }
}

- (NSInteger)columnCountAt:(NSInteger)section {
    if (_delegate && [_delegate respondsToSelector:@selector(flowLayout:columnCountAt:)]) {
        return [_delegate flowLayout:self columnCountAt:section];
    } else {
        return JaneDefaultColumCount;
    }
}



// 分组头部高度
- (CGFloat)heightForHeaderAt:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(flowLayout:headerHeightAt:)]) {
        return [_delegate flowLayout:self headerHeightAt:section];
    }
    return 0; // 默认无头部
}

// 分组尾部高度
- (CGFloat)heightForFooterAt:(NSInteger)section {
    if ([_delegate respondsToSelector:@selector(flowLayout:footerHeightAt:)]) {
        return [_delegate flowLayout:self footerHeightAt:section];
    }
    return 0; // 默认无尾部
}



#pragma - 懒加载
- (NSMutableArray *)attributesArr
{
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    return _attributesArr;
}

- (NSMutableArray *)columHeightArr
{
    if (!_columHeightArr) {
        _columHeightArr = [NSMutableArray array];
    }
    return _columHeightArr;
}

#pragma - collectionLayout
- (void)prepareLayout
{
    [super prepareLayout];
    
    self.preSection = 0;
    self.supplementaryViewHeight = 0;
    self.sectionHeaderMaxY = [self heightForHeaderAt:0] + self.edgeInsets.top;
    
    self.contentHeight = 0;
    
    //清除之前计算的所有每列的高度
    [self.columHeightArr removeAllObjects];
    NSInteger columnCount = [self columnCountAt:0];
    for (NSInteger i = 0; i < columnCount; i++) {
        //self.columHeightArr[i] = @(self.edgeInsets.top);
        self.columHeightArr[i] = @(self.sectionHeaderMaxY);
    }
    
    
    @autoreleasepool {
        NSMutableArray *newAttributes = [NSMutableArray array];
        
        NSInteger sectionCount = [self.collectionView numberOfSections];

        for (NSInteger section = 0; section < sectionCount; section++) {
            
            CGFloat headerH = [self heightForHeaderAt:section];
            if (headerH > 0) {
                UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                [newAttributes addObject:attribute];
            }
            
            NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
            for (NSInteger item = 0; item < itemCount; item++) {
                //创建位置
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                //获取indexpath相对应的布局属性
                UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
                [newAttributes addObject:attrs];
            }
            
            CGFloat footerH = [self heightForFooterAt:section];
            if (footerH > 0) {
                UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                [newAttributes addObject:attribute];
            }
        }
        
        self.attributesArr = newAttributes;
        
    }
    
    
    //清除之前所有的布局属性
//    [self.attributesArr removeAllObjects];
//    NSInteger count = [self.collectionView numberOfItemsInSection:0];
//    for (NSInteger i = 0; i < count; i++) {
//        //创建位置
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        //获取indexpath相对应的布局属性
//        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
//        [self.attributesArr addObject:attrs];
//    }
    
}


/**
 决定所有cell的排布布局数组
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.attributesArr filteredArrayUsingPredicate:
            [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *attrs, NSDictionary *bindings) {
                return CGRectIntersectsRect(attrs.frame, rect); // 只返回与 rect 相交的属性
            }]];
    //return self.attributesArr;
}


/**
  返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建布局
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectViewW = self.collectionView.frame.size.width;
    
    //设置布局frame
    //CGFloat w = (collectViewW - self.columnMarigin * (self.columnCount - 1) - self.edgeInsets.left - self.edgeInsets.right) / self.columnCount;
    CGFloat w = (collectViewW - self.columnMarigin * ([self columnCountAt:indexPath.section] - 1) - self.edgeInsets.left - self.edgeInsets.right) / [self columnCountAt:indexPath.section];
    CGFloat h = [self.delegate flowLayout:self heightForItemAt:indexPath with:w];
    
    NSInteger shortColum = 0;
    CGFloat minColumHeight = CGFLOAT_MAX;
    NSInteger columnCount = [self columnCountAt:indexPath.section];
    for (NSInteger i = 0; i < columnCount; i++) {
        CGFloat columHeight = [self.columHeightArr[i] doubleValue];
        if (minColumHeight > columHeight) {
            shortColum = i;
            minColumHeight = columHeight;
        }
    }
    CGFloat x = self.edgeInsets.left + (w + self.columnMarigin) * shortColum;
    //第一行的时候minColumHeight就是JaneDefaultEdgeInsets.top
    //JaneDefaultEdgeInsets.top算在了minColumHeight里面
    
    CGFloat y = minColumHeight;
    if (_preSection == indexPath.section) {
        if (y == _sectionHeaderMaxY + self.edgeInsets.top) {
            y = minColumHeight;
        }else {
            y += self.rowMarigin;
        }
    }else {
        x = self.edgeInsets.left;
        y = _contentHeight + self.edgeInsets.top;
        for (NSInteger i = 0; i < columnCount; i++) {
            self.columHeightArr[i] = @(y);
        }
        shortColum = 0;
        _preSection = indexPath.section;
    }
    
//    CGFloat y = minColumHeight;
//    if (y == self.edgeInsets.top) {
//        y = minColumHeight;
//    }else{
//        y += self.rowMarigin;
//    }
    
    attribute.frame = CGRectMake(x, y, w, h);
    
    //更新最短那列(高度,列数)
    self.columHeightArr[shortColum] = @(CGRectGetMaxY(attribute.frame));
    
    CGFloat columHeight = [self.columHeightArr[shortColum] doubleValue];
    if (columHeight > self.contentHeight) {
        self.contentHeight = columHeight;
    }
    
    return attribute;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //创建布局
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    CGFloat collectViewW = self.collectionView.frame.size.width;
    
    CGFloat y = self.contentHeight;
    CGFloat h = [self heightForHeaderAt:indexPath.section];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        y += self.edgeInsets.bottom;
        h = [self heightForFooterAt:indexPath.section];
    }else {
        // 记录组头底部位置
        _sectionHeaderMaxY = y + h;
        // 布局组头时先重置赋值列的高度数组
        [self.columHeightArr removeAllObjects];
        NSInteger columnCount = [self columnCountAt:indexPath.section];
        for (NSInteger i = 0; i < columnCount; i++) {
            self.columHeightArr[i] = @(y + h + self.edgeInsets.top);
        }
    }
    
    _supplementaryViewHeight += h;
    
    self.contentHeight = y + h;
    attribute.frame = CGRectMake(0, y, collectViewW, h);

    return  attribute;
}


- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight + self.edgeInsets.bottom);
}


@end
