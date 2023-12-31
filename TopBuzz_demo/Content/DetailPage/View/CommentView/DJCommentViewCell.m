//
//  DJCommentViewCell.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCommentViewCell.h"
#import "DJWebImage.h"
#import "DJScreen.h"
#import "DJColor.h"


#define PROFILEIMAGEVIEW_RADIUS 20

@implementation DJCommentViewCell

- (void)loadCommentCellWithData:(DJCommentItemInfo *)info {
    
    
    // 头像展示
    [_profileImageView setFrame:CGRectMake(15, 10, PROFILEIMAGEVIEW_RADIUS * 2, PROFILEIMAGEVIEW_RADIUS * 2)];
    [DJWebImage djWebImageWithImageView:_profileImageView urlString:info.com_profile_image_url];
    [self addSubview:_profileImageView];
    
    // 用户名
    [_username setFrame:CGRectMake(VIEW_X(_profileImageView) + VIEW_WIDTH(_profileImageView) + 15, VIEW_Y(_profileImageView), 250, PROFILEIMAGEVIEW_RADIUS + 5)];
    [_username setText:info.com_screen_name];
    [_username setTextColor:LIGHT_ORANGE];
    [_username setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
    [_username setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_username];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(VIEW_X(_username), VIEW_Y(_username) + VIEW_HEIGHT(_username), 300, [info.text_height floatValue])];
    _textView.editable = NO;  // 使 UITextView 不可编辑
    _textView.dataDetectorTypes = UIDataDetectorTypeLink;  // 设置数据检测器类型为链接
    [_textView setText:info.com_text];
    [_textView setScrollEnabled:NO];
    [_textView setAdjustsFontForContentSizeCategory:YES];
    [_textView setContentSize:CGSizeMake(300, VIEW_HEIGHT(_textView))];
    [_textView setTextContainerInset:UIEdgeInsetsZero];
    // 将 NSAttributedString 设置到 UITextView
    [_textView setAttributedText:info.textAttributedString];
    [_textView setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_textView];
    
    
    
    
    
    [_created_at_region setFrame:CGRectMake(VIEW_X(_textView), VIEW_Y(_textView) + VIEW_HEIGHT(_textView) + 5, 300, 20)];
    [_created_at_region setText:[[info.com_created_at stringByAppendingString:@"    "] stringByAppendingString:info.com_location]];
    [_created_at_region setTextColor:DARK_GRAY];
    [_created_at_region setFont:[UIFont systemFontOfSize:11]];
    [_created_at_region setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_created_at_region];
    
    
}






- (void)prepareForReuse {
    [super prepareForReuse];
    _profileImageView.image = nil;
    _textView.text = nil;
    _username.text = nil;
    _created_at_region.text = nil;
    _textView.text = nil;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:({
            self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.profileImageView.clipsToBounds = YES;
            self.profileImageView.layer.masksToBounds = YES; //设置圆角
            self.profileImageView.layer.cornerRadius = PROFILEIMAGEVIEW_RADIUS;
            self.profileImageView;
        })];
        [self.contentView addSubview:({
            self.textView = [[UITextView alloc] init];
            self.textView;
        })];
        [self.contentView addSubview:({
            self.username = [[UILabel alloc] init];
            self.username;
        })];
        [self.contentView addSubview:({
            self.created_at_region = [[UILabel alloc] init];
            self.created_at_region;
        })];
    }
    return self;
}


@end
