//
//  DJDetailNavigationBar.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/15.
//

#import <UIKit/UIKit.h>
#import "DJHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DJNavigationViewDelegate <NSObject>
@required
- (void)popDetailViewController;

@end


@interface DJDetailNavigationBar : UIView
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *created_at_region;
@property (nonatomic, weak) id <DJNavigationViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame itemInfo:(DJCollectionItemInfo *)info;

@end

NS_ASSUME_NONNULL_END
