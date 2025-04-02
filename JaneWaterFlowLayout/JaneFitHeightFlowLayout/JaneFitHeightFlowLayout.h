//
//  JaneFitHeightFlowLayout.h
//  JaneWaterFlowLayout
//
//  Created by Jane on 2018/1/31.
//  Copyright © 2018 jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JaneFitHeightFlowLayout;

@protocol JaneFitHeightFlowLayoutDelegate <NSObject>

@required
- (CGFloat)flowLayout:(JaneFitHeightFlowLayout *)layout heightForItemAt:(NSIndexPath *)indexPath with: (CGFloat)itemWidth;

@optional
- (NSInteger)columnCountIn:(JaneFitHeightFlowLayout *)flowLayout;

- (CGFloat)columnMariginIn:(JaneFitHeightFlowLayout *)flowLayout;
- (CGFloat)rowMariginIn:(JaneFitHeightFlowLayout *)flowLayout;
- (UIEdgeInsets)edgeInsetsIn:(JaneFitHeightFlowLayout *)flowLayout;


- (CGFloat)flowLayout:(JaneFitHeightFlowLayout *)layout columnCountAt:(NSInteger)section;

- (CGFloat)flowLayout:(JaneFitHeightFlowLayout *)layout headerHeightAt:(NSInteger)section;
- (CGFloat)flowLayout:(JaneFitHeightFlowLayout *)layout footerHeightAt:(NSInteger)section;


@end


@interface JaneFitHeightFlowLayout : UICollectionViewLayout

@property (nonatomic, weak)id<JaneFitHeightFlowLayoutDelegate> delegate;

@end

