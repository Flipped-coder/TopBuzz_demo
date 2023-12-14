//
//  DJHomeNavigationBar.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define HOT_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.hotBtn) + VIEW_WIDTH(videoNavBar.hotBtn) / 2)
#define LOCAL_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.localBtn) + VIEW_WIDTH(videoNavBar.localBtn) / 2)
#define INTERNATION_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.internationBtn) + VIEW_WIDTH(videoNavBar.internationBtn) / 2)
#define FINANCE_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.financeBtn) + VIEW_WIDTH(videoNavBar.financeBtn) / 2)
#define SCIENCE_CENTER_X(videoNavBar) (VIEW_X(videoNavBar.scienceBtn) + VIEW_WIDTH(videoNavBar.scienceBtn) / 2)

@interface DJHomeNavigationBar : UIView
@property (nonatomic, strong) UIButton *settingBtn;
// 热门按钮
@property (nonatomic, strong) UIButton *hotBtn;
// 同城按钮
@property (nonatomic, strong) UIButton *localBtn;
// 国际按钮
@property (nonatomic, strong) UIButton *internationBtn;
// 财经按钮
@property (nonatomic, strong) UIButton *financeBtn;
// 科普按钮
@property (nonatomic, strong) UIButton *scienceBtn;
// 搜索按钮
@property (nonatomic, strong) UIButton *searchBtn;

// 滑动块
@property (nonatomic, strong) UIView *slider;

- (void)loadVideoNavBar;

@end

//HotType                  = 0,  // 热门
//LocalType                = 1,  // 同城
//InternationType          = 2,  // 国际
//FinanceType              = 3,  // 财经
//ScienceType              = 4,  // 科普

NS_ASSUME_NONNULL_END



