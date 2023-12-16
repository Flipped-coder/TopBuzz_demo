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
@property (nonatomic, strong) NSMutableArray *attributeAttay;


- (void)appendCollectionItemInfoArray:(NSArray <DJCollectionItemInfo *> *)array;

- (void)refreshCollectionLayout;

@end

NS_ASSUME_NONNULL_END
