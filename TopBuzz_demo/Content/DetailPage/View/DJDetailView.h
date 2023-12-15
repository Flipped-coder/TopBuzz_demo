//
//  DJDetailView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/15.
//

#import <UIKit/UIKit.h>
#import "DJDetailNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DJDetailViewDelegate <NSObject>
@required
- (void)loadFullPictureBrowser:(UIScrollView *)fullPictureBrowser;

- (void)exitFullPictureBrowser;

@end


@interface DJDetailView : UIScrollView
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, weak) id <DJDetailViewDelegate> dj_delegate;



- (instancetype)initWithFrame:(CGRect)frame itemInfo:(DJCollectionItemInfo *)itemInfo;

- (void)loadMorePicture;


@end

NS_ASSUME_NONNULL_END
