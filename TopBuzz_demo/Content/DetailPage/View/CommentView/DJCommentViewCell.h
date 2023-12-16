//
//  DJCommentViewCell.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import <UIKit/UIKit.h>
#import "DJHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJCommentViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *created_at_region;

@property (nonatomic, assign) CGFloat *cellHeight;


- (void)loadCommentCellWithData:(DJCommentItemInfo *)info;

@end

NS_ASSUME_NONNULL_END
