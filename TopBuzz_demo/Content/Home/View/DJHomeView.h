//
//  DJHomeView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>
#import "DJHomeNavigationBar.h"
#import "DJCollectionView.h"
#import "DJCollectionLayout.h"


NS_ASSUME_NONNULL_BEGIN

@protocol DJHomeWiewDelegate <NSObject>
@required
/// 代理方需要跳转控制器
/// - Parameter itemInfo: 当前Cell的信息
- (void)pushDetailViewControllerWithInfo:(DJCollectionItemInfo *)itemInfo;

@end


@interface DJHomeView : UIView <UIScrollViewDelegate, DJCollectionViewDelegate>
@property (nonatomic, strong) DJHomeNavigationBar *videoNavBar;
@property (nonatomic, strong) UIScrollView *homeScrollView;
@property (nonatomic, strong) NSMutableArray<DJCollectionView *> *videoCollectionViewArray;
@property (nonatomic, strong) DJCollectionLayout * layout;
@property (nonatomic, weak) id <DJHomeWiewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
