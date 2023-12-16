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
        // 加载rootScrollView 作为不同详情页的容器
        _homeScrollView = [[UIScrollView alloc] init];
        _homeScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARFULL_HEIGHT);
        _homeScrollView.contentSize = CGSizeMake(VIEW_WIDTH(self) * VIDEOTYPE_COUNT, 0);
        _homeScrollView.alwaysBounceHorizontal = YES;
        _homeScrollView.bounces = NO;
        _homeScrollView.pagingEnabled = YES;
        _homeScrollView.showsVerticalScrollIndicator = NO;
        _homeScrollView.showsHorizontalScrollIndicator = NO;
        _homeScrollView.backgroundColor = WECHAT_BACKGROUND_GREY;
        _homeScrollView.delegate = self;
        
        // 加载 videoScrollView
        _videoCollectionViewArray = [NSMutableArray arrayWithCapacity:VIDEOTYPE_COUNT];
        // 循环生成 5 个 CollectionView 展示五个类型的咨询瀑布流
        for (int i = 0; i < VIDEOTYPE_COUNT ; i++) {
            _layout = [[DJCollectionLayout alloc] init];
            _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            _layout.minimumLineSpacing = 10;
            _layout.minimumInteritemSpacing = 10;
            _videoCollectionViewArray[i] = [[DJCollectionView alloc] initWithFrame:CGRectMake(
                                                       VIEW_WIDTH(_homeScrollView) * i,
                                                       -TOPSTATUSBAR_HEIGHT + NAVIGATIONFULL_HEIGHT,
                                                       VIEW_WIDTH(_homeScrollView),
                                                       VIEW_HEIGHT(_homeScrollView) - NAVIGATIONFULL_HEIGHT) collectionViewLayout:_layout];
            _videoCollectionViewArray[i].djDelegate = self;
            [_videoCollectionViewArray[i] setAlwaysBounceVertical:YES];
            [_videoCollectionViewArray[i] setBounces:YES];
            [_videoCollectionViewArray[i] setShowsVerticalScrollIndicator:YES];
            [_videoCollectionViewArray[i] setShowsHorizontalScrollIndicator:NO];
            _videoCollectionViewArray[i].backgroundColor = WECHAT_BACKGROUND_GREY;
            [_homeScrollView addSubview:_videoCollectionViewArray[i]];
        }
        // 初始化的时候只加载 Hot 第一页的数据 （其他类型的数据懒加载）
        [self loadCollectionViewDataWithType:HotType];
        
        [self addSubview:_homeScrollView];
        
        // 加载自定义navigationBar
        _videoNavBar = [[DJHomeNavigationBar alloc] initWithFrame:CGRectMake(0, TOPSTATUSBAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_HEIGHT)];
        [_videoNavBar loadVideoNavBar];
        
        /**TabBar上有5个按钮，可以通过点击跳转到不同CollectionView中**/
        [_videoNavBar.hotBtn addTarget:self action:@selector(clickNavBarHotBtn) forControlEvents:UIControlEventTouchUpInside];
        [_videoNavBar.localBtn addTarget:self action:@selector(clickNavBarLocalBtn) forControlEvents:UIControlEventTouchUpInside];
        [_videoNavBar.internationBtn addTarget:self action:@selector(clickNavBarInternationBtn) forControlEvents:UIControlEventTouchUpInside];
        [_videoNavBar.financeBtn addTarget:self action:@selector(clickNavBarFinanceBtn) forControlEvents:UIControlEventTouchUpInside];
        [_videoNavBar.scienceBtn addTarget:self action:@selector(clickNavBarScienceBtn) forControlEvents:UIControlEventTouchUpInside];

        
        [self addSubview:_videoNavBar];
    }
    return self;
}


/// 每页初始化第一次加载时调用，只会调用一次
- (void)loadCollectionViewDataWithType:(RequestType)type {
    switch (type) {
        case HotType: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [_videoCollectionViewArray[0] loadCollectionViewDataWithType:HotType];
            });
            break;
        }
        case LocalType: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [_videoCollectionViewArray[1] loadCollectionViewDataWithType:LocalType];
            });
            break;
        }
        case InternationType: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [_videoCollectionViewArray[2] loadCollectionViewDataWithType:InternationType];
            });
            break;
        }
        case FinanceType: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [_videoCollectionViewArray[3] loadCollectionViewDataWithType:FinanceType];
            });
            break;
        }
        case ScienceType: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [_videoCollectionViewArray[4] loadCollectionViewDataWithType:ScienceType];
            });
            break;
        }
    }
    
}


#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 监听滑动条移动
    _videoNavBar.slider.center = CGPointMake(HOT_CENTER_X(_videoNavBar) + (scrollView.bounds.origin.x / (SCREEN_WIDTH * 4)) * (SCIENCE_CENTER_X(_videoNavBar) - HOT_CENTER_X(_videoNavBar)), VIEW_Y(_videoNavBar.slider) + 1.5);
    
    // 当滑到某一页时，加载当前页数据（但是仅会加载一次）
    CGPoint contentOffset = scrollView.contentOffset;
    NSInteger type = ceil(contentOffset.x / SCREEN_WIDTH);
    [self loadCollectionViewDataWithType:type];
}
    

#pragma mark --DJCollectionViewDelegate
/// 委托给 ControllView 跳转进入详情页
- (void)notifacationHomeViewPushDetailWithItemInfo:(DJCollectionItemInfo *)itemInfo {
    if ([self.delegate respondsToSelector:@selector(pushDetailViewControllerWithInfo:)]) {
        [self.delegate pushDetailViewControllerWithInfo:itemInfo];
    }
}


#pragma mark - NavigationBar Button Method
- (void)clickNavBarHotBtn {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.videoNavBar.slider.frame = CGRectMake(HOT_CENTER_X(strongSelf.videoNavBar) - VIEW_WIDTH(strongSelf.videoNavBar.slider) / 2,
                                                            VIEW_Y(strongSelf.videoNavBar.slider),
                                                            VIEW_WIDTH(strongSelf.videoNavBar.slider),
                                                            VIEW_HEIGHT(strongSelf.videoNavBar.slider));
        [strongSelf.homeScrollView setContentOffset:CGPointMake(0, -TOPSTATUSBAR_HEIGHT)];
    }];
}

- (void)clickNavBarLocalBtn {
    [self loadCollectionViewDataWithType:LocalType];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.videoNavBar.slider.frame = CGRectMake(LOCAL_CENTER_X(strongSelf.videoNavBar) - VIEW_WIDTH(strongSelf.videoNavBar.slider) / 2,
                                                            VIEW_Y(strongSelf.videoNavBar.slider),
                                                            VIEW_WIDTH(strongSelf.videoNavBar.slider),
                                                            VIEW_HEIGHT(strongSelf.videoNavBar.slider));
        [strongSelf.homeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, -TOPSTATUSBAR_HEIGHT)];
    }];
}

- (void)clickNavBarInternationBtn {
    [self loadCollectionViewDataWithType:InternationType];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.videoNavBar.slider.frame = CGRectMake(INTERNATION_CENTER_X(strongSelf.videoNavBar) - VIEW_WIDTH(strongSelf.videoNavBar.slider) / 2,
                                                            VIEW_Y(strongSelf.videoNavBar.slider),
                                                            VIEW_WIDTH(strongSelf.videoNavBar.slider),
                                                            VIEW_HEIGHT(strongSelf.videoNavBar.slider));
        [strongSelf.homeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 2, -TOPSTATUSBAR_HEIGHT)];
    }];
}

- (void)clickNavBarFinanceBtn {
    [self loadCollectionViewDataWithType:FinanceType];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.videoNavBar.slider.frame = CGRectMake(FINANCE_CENTER_X(strongSelf.videoNavBar) - VIEW_WIDTH(strongSelf.videoNavBar.slider) / 2,
                                                            VIEW_Y(strongSelf.videoNavBar.slider),
                                                            VIEW_WIDTH(strongSelf.videoNavBar.slider),
                                                            VIEW_HEIGHT(strongSelf.videoNavBar.slider));
        [strongSelf.homeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 3, -TOPSTATUSBAR_HEIGHT)];
    }];
}

- (void)clickNavBarScienceBtn {
    [self loadCollectionViewDataWithType:ScienceType];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.videoNavBar.slider.frame = CGRectMake(SCIENCE_CENTER_X(strongSelf.videoNavBar) - VIEW_WIDTH(strongSelf.videoNavBar.slider) / 2,
                                                            VIEW_Y(strongSelf.videoNavBar.slider),
                                                            VIEW_WIDTH(strongSelf.videoNavBar.slider),
                                                            VIEW_HEIGHT(strongSelf.videoNavBar.slider));
        [strongSelf.homeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * 4, -TOPSTATUSBAR_HEIGHT)];
    }];
}


@end
