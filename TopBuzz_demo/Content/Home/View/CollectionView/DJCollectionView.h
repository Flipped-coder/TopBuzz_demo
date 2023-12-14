//
//  DJCollectionView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>
#import "DJHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DJCollectionViewDelegate <NSObject>
@required
- (void)notifacationHomeViewPushDetail;

@end

@interface DJCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) id<DJCollectionViewDelegate> djDelegate;

- (void)loadCollectionViewDataWithType:(RequestType)type;

@end

NS_ASSUME_NONNULL_END
