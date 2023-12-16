//
//  DJCollectionLayout.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>

@class DJCollectionItemInfo;

NS_ASSUME_NONNULL_BEGIN

@interface DJCollectionLayout : UICollectionViewFlowLayout
@property (nonatomic, strong) NSMutableArray *attributeAttay;   // collectionView的布局数组

/// 追加信息到CollectionView的布局中
/// - Parameter array: ViewModel数组
- (void)appendCollectionItemInfoArray:(NSArray <DJCollectionItemInfo *> *)array;

/// 刷新CollectionView布局信息
- (void)refreshCollectionLayout;

@end

NS_ASSUME_NONNULL_END
