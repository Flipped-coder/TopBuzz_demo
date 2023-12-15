//
//  DJDetailView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/15.
//

#import <UIKit/UIKit.h>
#import "DJDetailNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJDetailView : UIScrollView
@property (nonatomic, strong) UIScrollView *pictureBrowser;
@property (nonatomic, strong) UILabel *text;



- (instancetype)initWithFrame:(CGRect)frame itemInfo:(DJCollectionItemInfo *)itemInfo;



@end

NS_ASSUME_NONNULL_END
