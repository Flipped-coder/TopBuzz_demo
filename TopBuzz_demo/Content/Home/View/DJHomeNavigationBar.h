//
//  DJHomeNavigationBar.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define LIVESTREAMING_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.liveStreamingBtn) + VIEW_WIDTH(videoNavBar.liveStreamingBtn) / 2)
#define LOCAL_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.localBtn) + VIEW_WIDTH(videoNavBar.localBtn) / 2)
#define ATTENTION_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.attentionBtn) + VIEW_WIDTH(videoNavBar.attentionBtn) / 2)
#define FRIEND_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.friendBtn) + VIEW_WIDTH(videoNavBar.friendBtn) / 2)
#define RECOMMEND_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.recommendBtn) + VIEW_WIDTH(videoNavBar.recommendBtn) / 2)

@interface DJHomeNavigationBar : UIView
@property (nonatomic, strong) UIButton *settingBtn;
// 直播按钮
@property (nonatomic, strong) UIButton *liveStreamingBtn;
// 同城按钮
@property (nonatomic, strong) UIButton *localBtn;
// 关注按钮
@property (nonatomic, strong) UIButton *attentionBtn;
// 朋友按钮
@property (nonatomic, strong) UIButton *friendBtn;
// 推荐按钮
@property (nonatomic, strong) UIButton *recommendBtn;
// 搜索按钮
@property (nonatomic, strong) UIButton *searchBtn;

// 滑动块
@property (nonatomic, strong) UIView *slider;

- (void)loadVideoNavBar;

@end

NS_ASSUME_NONNULL_END



