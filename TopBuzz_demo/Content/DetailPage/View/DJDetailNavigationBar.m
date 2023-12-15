//
//  DJDetailNavigationBar.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/15.
//

#import "DJDetailNavigationBar.h"
#import "DJScreen.h"
#import "DJColor.h"
#import "DJWebImage.h"

#define BACKBTN_RADIUS 12
#define PROFILEIMAGEVIEW_RADIUS 20

@implementation DJDetailNavigationBar

- (instancetype)initWithFrame:(CGRect)frame itemInfo:(DJCollectionItemInfo *)info {
    self = [self initWithFrame:frame];
    if (self) {
        // 设置按钮
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setFrame:CGRectMake(20, VIEW_HEIGHT(self) / 2 - BACKBTN_RADIUS - 2, BACKBTN_RADIUS * 2, BACKBTN_RADIUS * 2)];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBtn setShowsTouchWhenHighlighted:YES];
        [self addSubview:_backBtn];
        
        // 头像展示
        _profileImageView = [[UIImageView alloc] init];
        [_profileImageView setFrame:CGRectMake(VIEW_X(_backBtn) + VIEW_Y(_backBtn) + 30, VIEW_HEIGHT(self) / 2 - PROFILEIMAGEVIEW_RADIUS - 2, PROFILEIMAGEVIEW_RADIUS * 2, PROFILEIMAGEVIEW_RADIUS * 2)];
        [_profileImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_profileImageView setClipsToBounds:YES];
        [_profileImageView.layer setMasksToBounds:YES];
        [_profileImageView.layer setCornerRadius:PROFILEIMAGEVIEW_RADIUS];
        [DJWebImage djWebImageWithImageView:_profileImageView urlString:info.profileImageString];
        [self addSubview:_profileImageView];
        
        // 用户名
        _username = [[UILabel alloc] init];
        [_username setFrame:CGRectMake(VIEW_X(_profileImageView) + VIEW_WIDTH(_profileImageView) + 15, VIEW_Y(_profileImageView), 250, PROFILEIMAGEVIEW_RADIUS + 5)];
        [_username setText:info.username];
        [_username setTextColor:LIGHT_ORANGE];
        [_username setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        [_username setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_username];
        
        // 发布时间和发布地
        _created_at_region = [[UILabel alloc] init];
        [_created_at_region setFrame:CGRectMake(VIEW_X(_username), VIEW_Y(_username) + VIEW_HEIGHT(_username) - 5, 250, PROFILEIMAGEVIEW_RADIUS)];
        [_created_at_region setText:[[info.created_at stringByAppendingString:@"    "] stringByAppendingString:info.region_name]];
        [_created_at_region setTextColor:DARK_GRAY];
        [_created_at_region setFont:[UIFont systemFontOfSize:11]];
        [_created_at_region setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_created_at_region];
        
    }
    return self;
}




@end
