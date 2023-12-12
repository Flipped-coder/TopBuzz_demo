//
//  DJHomeView.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeView.h"
#import "DJScreen.h"

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
        
        
        _homeScrollView.backgroundColor = [UIColor greenColor];
        
        // 加载 videoScrollView
        _videoCollectionViewArray = [NSMutableArray arrayWithCapacity:VIDEOTYPE_COUNT];
        for (int i = 0; i < VIDEOTYPE_COUNT; i++) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            _videoCollectionViewArray[i] = [[DJCollectionView alloc] initWithFrame:CGRectMake(
                                                       VIEW_WIDTH(_homeScrollView) * i,
                                                       -TOPSTATUSBAR_HEIGHT,
                                                       VIEW_WIDTH(_homeScrollView),
                                                       VIEW_HEIGHT(_homeScrollView)) collectionViewLayout:layout];
            [_videoCollectionViewArray[i] setAlwaysBounceVertical:YES];
            [_videoCollectionViewArray[i] setBounces:NO];
            [_videoCollectionViewArray[i] setPagingEnabled:YES];
            [_videoCollectionViewArray[i] setShowsVerticalScrollIndicator:NO];
            [_videoCollectionViewArray[i] setShowsHorizontalScrollIndicator:NO];
            [_homeScrollView addSubview:_videoCollectionViewArray[i]];
            
        }
        
        _videoCollectionViewArray[4].backgroundColor = [UIColor orangeColor];
        _videoCollectionViewArray[0].backgroundColor = [UIColor orangeColor];

        [self addSubview:_homeScrollView];
        
        // 加载自定义navigationBar
        _videoNavBar = [[DJHomeNavigationBar alloc] initWithFrame:CGRectMake(0, TOPSTATUSBAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_HEIGHT)];
        [_videoNavBar loadVideoNavBar];
        [self addSubview:_videoNavBar];
    }
    return self;
}





@end
