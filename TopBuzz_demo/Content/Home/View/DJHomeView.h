//
//  DJHomeView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>
#import "DJHomeNavigationBar.h"
#import "DJCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJHomeView : UIView
@property (nonatomic, strong) DJHomeNavigationBar *videoNavBar;
@property (nonatomic, strong) UIScrollView *homeScrollView;
@property (nonatomic, strong) NSMutableArray<DJCollectionView *> *videoCollectionViewArray;


@end

NS_ASSUME_NONNULL_END
