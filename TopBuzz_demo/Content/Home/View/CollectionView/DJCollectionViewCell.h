//
//  DJCollectionViewCell.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>
#import "DJHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIImageView *likeIcon;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *likeNumber;

@property (nonatomic, assign) float cellHeight;

- (void)layoutCollectionViewCellWithData:(DJCollectionItemInfo *)itemInfo;

@end

NS_ASSUME_NONNULL_END
