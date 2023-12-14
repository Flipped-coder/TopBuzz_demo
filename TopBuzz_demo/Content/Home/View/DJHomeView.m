//
//  DJHomeView.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeView.h"
#import "DJScreen.h"
#import "DJColor.h"

#define VIDEOTYPE_COUNT 5

@implementation DJHomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 加载rootScrollView
        _homeScrollView = [[UIScrollView alloc] init];
        _homeScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARFULL_HEIGHT);
        _homeScrollView.contentSize = CGSizeMake(VIEW_WIDTH(self) * VIDEOTYPE_COUNT, 0);
        _homeScrollView.alwaysBounceHorizontal = YES;
        _homeScrollView.bounces = NO;
        _homeScrollView.pagingEnabled = YES;
        _homeScrollView.showsVerticalScrollIndicator = NO;
        _homeScrollView.showsHorizontalScrollIndicator = NO;
        
        _homeScrollView.backgroundColor = LIGHT_GRAY;

        
        // 加载 videoScrollView
        _videoCollectionViewArray = [NSMutableArray arrayWithCapacity:VIDEOTYPE_COUNT];
        for (int i = 0; i < 1; i++) {
            _layout = [[DJCollectionLayout alloc]init];
            _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            _layout.minimumLineSpacing = 10;
            _layout.minimumInteritemSpacing = 10;

            _videoCollectionViewArray[i] = [[DJCollectionView alloc] initWithFrame:CGRectMake(
                                                       VIEW_WIDTH(_homeScrollView) * i,
                                                       -TOPSTATUSBAR_HEIGHT + NAVIGATIONFULL_HEIGHT,
                                                       VIEW_WIDTH(_homeScrollView),
                                                       VIEW_HEIGHT(_homeScrollView) - NAVIGATIONFULL_HEIGHT) collectionViewLayout:_layout];
            [_videoCollectionViewArray[i] setAlwaysBounceVertical:YES];
            [_videoCollectionViewArray[i] setBounces:YES];
            [_videoCollectionViewArray[i] setShowsVerticalScrollIndicator:YES];
            [_videoCollectionViewArray[i] setShowsHorizontalScrollIndicator:NO];
            
            [_homeScrollView addSubview:_videoCollectionViewArray[i]];
            
        }
        
        _videoCollectionViewArray[0].backgroundColor = WECHAT_BACKGROUND_GREY;

        [self addSubview:_homeScrollView];
        
        // 加载自定义navigationBar
        _videoNavBar = [[DJHomeNavigationBar alloc] initWithFrame:CGRectMake(0, TOPSTATUSBAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_HEIGHT)];
        [_videoNavBar loadVideoNavBar];
        [self addSubview:_videoNavBar];
    }
    return self;
}





@end
