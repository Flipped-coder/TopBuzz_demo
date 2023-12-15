//
//  DJDetailNavigationBar.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/15.
//

#import <UIKit/UIKit.h>
#import "DJHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJDetailNavigationBar : UIView
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *created_at_region;

- (instancetype)initWithFrame:(CGRect)frame itemInfo:(DJCollectionItemInfo *)info;

@end

NS_ASSUME_NONNULL_END
