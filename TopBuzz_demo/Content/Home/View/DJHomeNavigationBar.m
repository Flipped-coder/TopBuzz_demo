//
//  DJHomeNavigationBar.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeNavigationBar.h"
#import "DJScreen.h"
#import "DJColor.h"

@implementation DJHomeNavigationBar

- (void)loadVideoNavBar {
    self.backgroundColor = LIGHT_GRAY;
    
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
    
    
    // 热门按钮
    self.hotBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.hotBtn setFrame:CGRectMake(60, 5, (SCREEN_WIDTH - 120) / 5, 34)];
    [self.hotBtn setTitle:@"热门" forState:UIControlStateNormal];
    [self.hotBtn setTintColor:[UIColor blackColor]];
    [self.hotBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.hotBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.hotBtn];
   
    // 同城按钮
    self.localBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.localBtn setFrame:CGRectMake(VIEW_X(self.hotBtn) + VIEW_WIDTH(self.hotBtn),
                                       VIEW_Y(self.hotBtn),
                                       VIEW_WIDTH(self.hotBtn),
                                       VIEW_HEIGHT(self.hotBtn))];
    [self.localBtn setTitle:@"同城" forState:UIControlStateNormal];
    [self.localBtn setTintColor:[UIColor blackColor]];
    [self.localBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.localBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.localBtn];
    
    
    // 国际按钮
    self.internationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.internationBtn setFrame:CGRectMake(VIEW_X(self.localBtn) + VIEW_WIDTH(self.localBtn),
                                           VIEW_Y(self.localBtn),
                                           VIEW_WIDTH(self.localBtn),
                                           VIEW_HEIGHT(self.localBtn))];
    [self.internationBtn setTitle:@"国际" forState:UIControlStateNormal];
    [self.internationBtn setTintColor:[UIColor blackColor]];
    [self.internationBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.internationBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.internationBtn];
    
    
    // 财经按钮
    self.financeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.financeBtn setFrame:CGRectMake(VIEW_X(self.internationBtn) + VIEW_WIDTH(self.internationBtn),
                                           VIEW_Y(self.internationBtn),
                                           VIEW_WIDTH(self.internationBtn),
                                           VIEW_HEIGHT(self.internationBtn))];
    [self.financeBtn setTitle:@"财经" forState:UIControlStateNormal];
    [self.financeBtn setTintColor:[UIColor blackColor]];
    [self.financeBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.financeBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.financeBtn];
    
    
    // 科普按钮
    self.scienceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.scienceBtn setFrame:CGRectMake(VIEW_X(self.financeBtn) + VIEW_WIDTH(self.financeBtn),
                                           VIEW_Y(self.financeBtn),
                                           VIEW_WIDTH(self.financeBtn),
                                           VIEW_HEIGHT(self.financeBtn))];
    [self.scienceBtn setTitle:@"科普" forState:UIControlStateNormal];
    [self.scienceBtn setTintColor:[UIColor blackColor]];
    [self.scienceBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.scienceBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self addSubview:self.scienceBtn];
    
    
    // 滑块
    self.slider = [[UIView alloc] init];
    [self.slider setFrame:CGRectMake(HOT_CENTER_X(self) - 17.5, VIEW_Y(self.hotBtn) + VIEW_HEIGHT(self.hotBtn) - 5, 35, 3)];
    [self.slider setBackgroundColor:[UIColor blackColor]];
    [self.slider.layer setCornerRadius:2];
    [self addSubview:self.slider];
    
}



@end
