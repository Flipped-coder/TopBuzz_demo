//
//  DJCollectionViewCell.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJCollectionViewCell.h"
#import "DJScreen.h"
#import "DJColor.h"
#import "DJWebImage.h"

@implementation DJCollectionViewCell

- (void)layoutCollectionViewCellWithData:(DJCollectionItemInfo *)itemInfo {

    [self.imageView setFrame:CGRectMake(5, 5, 180, [itemInfo.imageCollectionFormatHeight floatValue])];
    [DJWebImage djWebImageWithImageView:self.imageView urlString:itemInfo.picInfos[0].thumbnailPicString];

    
    [self.content setText:itemInfo.text];
    [self.content setFont:[UIFont systemFontOfSize:12.0]];
    [self.content setAttributedText:itemInfo.textAttributedString];
    [self.content setNumberOfLines:0];
    [self.content setFrame:CGRectMake(10, self.imageView.frame.size.height + 10, VIEW_WIDTH(self) - 20, [itemInfo.textCollectionFormatHeight floatValue])];
    
    
    [self.profileImageView setFrame:CGRectMake(10, VIEW_Y(self.content) + VIEW_HEIGHT(self.content) + 8, 20, 20)];
    [DJWebImage djWebImageWithImageView:self.profileImageView urlString:itemInfo.profileImageString];
    
    
    [self.username setText:itemInfo.username];
    [self.username setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]];
    [self.username setFrame:CGRectMake(VIEW_X(self.profileImageView) + VIEW_WIDTH(self.profileImageView) + 10, VIEW_Y(self.profileImageView), 100, 20)];
    
    
    [self.likeIcon setFrame:CGRectMake(VIEW_WIDTH(self) - 55, VIEW_Y(self.username) + 5, 15, 15)];
    
    
    [self.likeNumber setText:itemInfo.likeNumber];
    [self.likeNumber setFont:[UIFont systemFontOfSize:10]];
    [self.likeNumber setTextAlignment:NSTextAlignmentRight];
    [self.likeNumber setFrame:CGRectMake(VIEW_X(self.likeIcon) + VIEW_WIDTH(self.likeIcon), VIEW_Y(self.likeIcon), 35, 15)];
    
    
    
}


/// 回收当前 Cell 的系统调用
- (void)prepareForReuse {
    [super prepareForReuse];
    // 清除视图数据
    if (self.imageView.image) {
        self.imageView.image = nil;
    }
    if (self.profileImageView.image) {
        self.profileImageView.image = nil;
    }
    if (self.content.text) {
        self.content.text = nil;
    }
    if (self.username.text) {
        self.username.text = nil;
    }
    if (self.likeNumber.text) {
        self.likeNumber.text = nil;
    }

}




- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:({
            self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
            self.imageView;
        })];
        [self.contentView addSubview:({
            self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.profileImageView.clipsToBounds = YES;
            self.profileImageView.layer.masksToBounds = YES; //设置圆角
            self.profileImageView.layer.cornerRadius = 10;
            self.profileImageView;
        })];
        [self.contentView addSubview:({
            self.likeIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.likeIcon.contentMode = UIViewContentModeScaleAspectFill;
            self.likeIcon.image = [UIImage imageNamed:@"like_icon"];
            self.likeIcon;
        })];
        [self.contentView addSubview:({
            self.content = [[UILabel alloc] init];
            self.content;
        })];
        [self.contentView addSubview:({
            self.username = [[UILabel alloc] init];
            self.username;
        })];
        [self.contentView addSubview:({
            self.likeNumber = [[UILabel alloc] init];
            self.likeNumber;
        })];
    }
    return self;
}



@end
