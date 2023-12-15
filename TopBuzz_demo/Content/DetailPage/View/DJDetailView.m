//
//  DJDetailView.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/15.
//

#import "DJDetailView.h"
#import "DJScreen.h"

@implementation DJDetailView

- (instancetype)initWithFrame:(CGRect)frame itemInfo:(DJCollectionItemInfo *)itemInfo {
    self = [self initWithFrame:frame];
    if (self) {
        _pictureBrowser = [[UIScrollView alloc] init];
        [_pictureBrowser setFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, [itemInfo.imageBrowserFormatHeight floatValue])];
        [_pictureBrowser setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_pictureBrowser];
        
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
        [self setContentSize:CGSizeMake(0, VIEW_HEIGHT(_pictureBrowser) + VIEW_HEIGHT(_text) + 100)];
        
    
        

    }
    return self;
}




@end
