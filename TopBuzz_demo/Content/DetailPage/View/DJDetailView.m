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
        
        [self setAlwaysBounceVertical:YES];
        [self setBounces:YES];
        [self setShowsVerticalScrollIndicator:YES];
        [self setShowsHorizontalScrollIndicator:NO];
        self.backgroundColor = [UIColor whiteColor];
        [self setContentSize:CGSizeMake(0, VIEW_HEIGHT(_pictureBrowser) + 300)];
        
    
        

    }
    return self;
}




@end
