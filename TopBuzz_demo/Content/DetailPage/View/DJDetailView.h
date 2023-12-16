//
//  DJDetailView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/15.
//

#import <UIKit/UIKit.h>
#import "DJDetailNavigationBar.h"
#import "DJCommentView.h"
#import "DJCommentViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DJDetailViewDelegate <NSObject>
@required
- (void)loadFullPictureBrowser:(UIScrollView *)fullPictureBrowser;

- (void)exitFullPictureBrowser;

- (void)pushWebViewControllerWithURL:(NSURL *)url;

@end


@interface DJDetailView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, weak) id <DJDetailViewDelegate> dj_delegate;
@property (nonatomic, strong) UIScrollView *pictureBrowser;



- (instancetype)initWithFrame:(CGRect)frame itemInfo:(DJCollectionItemInfo *)itemInfo;

- (void)loadMorePicture;


@end

NS_ASSUME_NONNULL_END
