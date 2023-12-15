//
//  DJDetailView.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/15.
//

#import "DJDetailView.h"
#import "DJScreen.h"
#import "DJWebImage.h"
#import <objc/runtime.h>


@interface DJDetailView ()
@property (nonatomic, strong) DJCollectionItemInfo *itemInfo;
@property (nonatomic, strong) UIScrollView *pictureBrowser;
@property (nonatomic, strong) UIScrollView *fullPictureBrowser;
@property (nonatomic, strong) UIButton *detailBrowserBtn;

@end

@implementation DJDetailView

- (instancetype)initWithFrame:(CGRect)frame itemInfo:(DJCollectionItemInfo *)itemInfo {
    self = [self initWithFrame:frame];
    if (self) {
        _itemInfo = itemInfo;
        
        _pictureBrowser = [[UIScrollView alloc] init];
        [_pictureBrowser setFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, [itemInfo.imageBrowserFormatHeight floatValue])];
        [_pictureBrowser setBackgroundColor:[UIColor whiteColor]];
        [_pictureBrowser setContentSize:CGSizeMake(VIEW_WIDTH(_pictureBrowser) * itemInfo.picInfos.count, 0)];
        [_pictureBrowser setShowsVerticalScrollIndicator:NO];
        [_pictureBrowser setShowsHorizontalScrollIndicator:NO];
        [_pictureBrowser setBounces:YES];
        [_pictureBrowser setPagingEnabled:YES];
        [_pictureBrowser setAlwaysBounceHorizontal:YES];
        
        // 先只加载第一张图片
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(5, 0, VIEW_WIDTH(_pictureBrowser) - 10, VIEW_HEIGHT(_pictureBrowser))];
        [DJWebImage djWebImageWithImageView:imageView urlString:itemInfo.picInfos[0].largePicString];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_pictureBrowser addSubview:imageView];
        [self addSubview:_pictureBrowser];
        
        // 详情图片按钮
        _detailBrowserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBrowserBtn setFrame:imageView.frame];
        [_detailBrowserBtn addTarget:self action:@selector(detailBrowserBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_pictureBrowser addSubview:_detailBrowserBtn];
        

        
        _text = [[UILabel alloc] init];
        [_text setFrame:CGRectMake(20, VIEW_Y(_pictureBrowser) + VIEW_HEIGHT(_pictureBrowser) + 10, SCREEN_WIDTH - 40, [itemInfo.textBrowserFormatHeight floatValue])];
        [_text setText:itemInfo.text];
        [_text setAttributedText:itemInfo.textAttributedString];
        [_text setFont:[UIFont systemFontOfSize:16.5]];
        [_text setTextAlignment:NSTextAlignmentLeft];
        [_text setNumberOfLines:0];
        [self addSubview:_text];

        [self setAlwaysBounceVertical:YES];
        [self setBounces:YES];
        [self setShowsVerticalScrollIndicator:YES];
        [self setShowsHorizontalScrollIndicator:NO];
        self.backgroundColor = [UIColor whiteColor];
        [self setContentSize:CGSizeMake(0, VIEW_HEIGHT(_pictureBrowser) + VIEW_HEIGHT(_text) + 200)];

    }
    return self;
}

- (void)detailBrowserBtnClick {
    if ([_dj_delegate respondsToSelector:@selector(loadFullPictureBrowser:)]) {
        [_dj_delegate loadFullPictureBrowser:_fullPictureBrowser];
    }}

- (void)exitFullPictureBrowserBtnClick {
    if ([_dj_delegate respondsToSelector:@selector(exitFullPictureBrowser)]) {
        [_dj_delegate exitFullPictureBrowser];
    }
}


- (void)loadMorePicture {
    for (int i = 1; i < _itemInfo.picInfos.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(VIEW_WIDTH(_pictureBrowser) * i + 5, 0, VIEW_WIDTH(_pictureBrowser) - 10, VIEW_HEIGHT(_pictureBrowser))];
        [imageView setContentMode:UIViewContentModeCenter];
        [imageView setImage:[UIImage imageNamed:@"loading_s"]];
        [DJWebImage djWebImageWithImageView:imageView urlString:_itemInfo.picInfos[i].largePicString];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        // 详情图片按钮
        _detailBrowserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailBrowserBtn setFrame:imageView.frame];
        [_detailBrowserBtn addTarget:self action:@selector(detailBrowserBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_pictureBrowser addSubview:_detailBrowserBtn];
        
        [_pictureBrowser addSubview:imageView];
    }
    
    
    _fullPictureBrowser = [[UIScrollView alloc] initWithFrame:self.bounds];
    _fullPictureBrowser.pagingEnabled = YES;
    _fullPictureBrowser.showsHorizontalScrollIndicator = NO;
    _fullPictureBrowser.showsVerticalScrollIndicator = NO;
    [_fullPictureBrowser setBackgroundColor:[UIColor blackColor]];
    

    for (int i = 0; i < _itemInfo.picInfos.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [DJWebImage djWebImageWithImageView:imageView urlString:_itemInfo.picInfos[i].originalPicString];
        // 详情图片按钮
        UIButton *exitFullPictureBrowserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitFullPictureBrowserBtn setFrame:imageView.frame];
        [exitFullPictureBrowserBtn addTarget:self action:@selector(exitFullPictureBrowserBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_fullPictureBrowser addSubview:exitFullPictureBrowserBtn];
        
        [_fullPictureBrowser addSubview:imageView];
    }
    _fullPictureBrowser.contentSize = CGSizeMake(SCREEN_WIDTH * _itemInfo.picInfos.count, SCREEN_HEIGHT);
    
}




@end
