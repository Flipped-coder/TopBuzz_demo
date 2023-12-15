//
//  DJCollectionView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>
#import "DJHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ViewState) {
    Refreshing                  = 0,  // 正在刷新
    Loading                     = 1,  // 正在加载
    NormalState                 = 2,  // 正常
};

@protocol DJCollectionViewDelegate <NSObject>
@required
- (void)notifacationHomeViewPushDetailWithItemInfo:(DJCollectionItemInfo *)itemInfo;

@end

@interface DJCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) id<DJCollectionViewDelegate> djDelegate;

- (void)loadCollectionViewDataWithType:(RequestType)type;

@end

NS_ASSUME_NONNULL_END
