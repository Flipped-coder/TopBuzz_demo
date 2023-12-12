//
//  DJHomeNavigationBar.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeNavigationBar.h"
#import "DJScreen.h"

@implementation DJHomeNavigationBar

- (void)loadVideoNavBar {
    // 设置按钮
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.settingBtn setFrame:CGRectMake(20, 5, 30, 30)];
    [self.settingBtn setBackgroundImage:[UIImage imageNamed:@"home_bar_settings_black"] forState:UIControlStateNormal];
    [self.settingBtn setShowsTouchWhenHighlighted:YES];
    [self addSubview:self.settingBtn];
    // 搜索按钮
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchBtn setFrame:CGRectMake(SCREEN_WIDTH - 50, 5, 30, 30)];
    [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"home_bar_search"] forState:UIControlStateNormal];
    [self.searchBtn setShowsTouchWhenHighlighted:YES];
    [self.searchBtn.layer setCornerRadius:6];
    [self addSubview:self.searchBtn];
    
    
    // 直播按钮
    self.liveStreamingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.liveStreamingBtn setFrame:CGRectMake(60, 5, (SCREEN_WIDTH - 120) / 5, 34)];
    [self.liveStreamingBtn setTitle:@"直播" forState:UIControlStateNormal];
    [self.liveStreamingBtn setTintColor:[UIColor blackColor]];
    [self.liveStreamingBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.liveStreamingBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.liveStreamingBtn];
   
    // 同城按钮
    self.localBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.localBtn setFrame:CGRectMake(VIEW_X(self.liveStreamingBtn) + VIEW_WIDTH(self.liveStreamingBtn),
                                       VIEW_Y(self.liveStreamingBtn),
                                       VIEW_WIDTH(self.liveStreamingBtn),
                                       VIEW_HEIGHT(self.liveStreamingBtn))];
    [self.localBtn setTitle:@"同城" forState:UIControlStateNormal];
    [self.localBtn setTintColor:[UIColor blackColor]];
    [self.localBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.localBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.localBtn];
    
    
    // 关注按钮
    self.attentionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.attentionBtn setFrame:CGRectMake(VIEW_X(self.localBtn) + VIEW_WIDTH(self.localBtn),
                                           VIEW_Y(self.localBtn),
                                           VIEW_WIDTH(self.localBtn),
                                           VIEW_HEIGHT(self.localBtn))];
    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionBtn setTintColor:[UIColor blackColor]];
    [self.attentionBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.attentionBtn];
    
    
    // 朋友按钮
    self.friendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.friendBtn setFrame:CGRectMake(VIEW_X(self.attentionBtn) + VIEW_WIDTH(self.attentionBtn),
                                           VIEW_Y(self.attentionBtn),
                                           VIEW_WIDTH(self.attentionBtn),
                                           VIEW_HEIGHT(self.attentionBtn))];
    [self.friendBtn setTitle:@"朋友" forState:UIControlStateNormal];
    [self.friendBtn setTintColor:[UIColor blackColor]];
    [self.friendBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.friendBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.friendBtn];
    
    
    // 推荐按钮
    self.recommendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.recommendBtn setFrame:CGRectMake(VIEW_X(self.friendBtn) + VIEW_WIDTH(self.friendBtn),
                                           VIEW_Y(self.friendBtn),
                                           VIEW_WIDTH(self.friendBtn),
                                           VIEW_HEIGHT(self.friendBtn))];
    [self.recommendBtn setTitle:@"推荐" forState:UIControlStateNormal];
    [self.recommendBtn setTintColor:[UIColor blackColor]];
    [self.recommendBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.recommendBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.recommendBtn];
    
    
    // 滑块
    self.slider = [[UIView alloc] init];
    [self.slider setFrame:CGRectMake(RECOMMEND_CENTER_X(self) - 17.5, VIEW_Y(self.liveStreamingBtn) + VIEW_HEIGHT(self.liveStreamingBtn) - 5, 35, 3)];
    [self.slider setBackgroundColor:[UIColor blackColor]];
    [self.slider.layer setCornerRadius:2];
    [self addSubview:self.slider];
    
}



@end
