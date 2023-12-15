//
//  DJCollectionView.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJCollectionView.h"
#import "DJCollectionViewCell.h"
#import "DJCollectionLayout.h"
#import <MJRefresh/MJRefresh.h>


@interface DJCollectionView ()
@property (nonatomic, strong) DJCollectionViewCell *cell;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DJHomeViewModel *viewModel;
@property (nonatomic, strong) dispatch_semaphore_t arraySemaphore;
@property (nonatomic, assign) RequestType currentType;
@property (nonatomic, strong) DJCollectionLayout * layout;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL allowRequest;
@property (nonatomic, assign) ViewState currentState;

@end



@implementation DJCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[DJCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _layout = (DJCollectionLayout *)layout;
        _viewModel = [[DJHomeViewModel alloc] init];
        [self bindViewModel:_viewModel];
        _currentPage = 1;
        _allowRequest = YES;
        _arraySemaphore = dispatch_semaphore_create(1);
        
        // 添加下拉刷新控件
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCollectionViewData)];
        self.mj_header = header;
//        // 添加上拉加载控件
//        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//        self.mj_footer = footer;
    }
    return self;
}

- (void)loadCollectionViewDataWithType:(RequestType)type {
    NSLog(@"LoadingVIewData Page = %d", _currentPage);

    _currentType = type;
    [_viewModel loadCollectionItemInfoDataWithType:_currentType Page:_currentPage++];
}



#pragma mark Private
- (void)refreshCollectionViewData {
    [_layout refreshCollectionLayout];
    [_viewModel refreshCollectionItemInfoDataWith:_currentType];
    _currentState = Refreshing;
}

- (void)loadMoreData {
    [self loadCollectionViewDataWithType:_currentType];
    _currentState = Loading;
}




- (void)bindViewModel:(DJHomeViewModel *)viewModel {
    [viewModel addObserver:self forKeyPath:@"collectionItemInfoArray" options:NSKeyValueObservingOptionNew context:nil];
}

// 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"collectionItemInfoArray"]) {
        
        // 处理属性变化
        NSMutableArray <DJCollectionItemInfo *> *newValue = change[NSKeyValueChangeNewKey];
        [_layout appendCollectionItemInfoArray:newValue];
        _allowRequest = YES;
        if (_currentState == Refreshing) {
            _currentState = NormalState;
            [self.mj_header endRefreshing];
        }
        switch (_currentState) {
            case Refreshing: {
                _currentState = NormalState;
                [self.mj_header endRefreshing];
            }
                break;
            case Loading: {
                _currentState = NormalState;
                [self.mj_footer endRefreshing];
            }
                break;
            default:break;
        }
        
        // 主队列中更新View
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf reloadData];
        });
    }
}

- (void)dealloc {
    [_viewModel removeObserver:self forKeyPath:@"collectionItemInfoArray"];
}






#pragma mark - UICollectionViewDelegate
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    _cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    DJCollectionItemInfo *itemInfo = _viewModel.collectionItemInfoArrays[indexPath.item];
    
    [_cell layoutCollectionViewCellWithData:itemInfo];
 
    if (indexPath.item > _viewModel.collectionItemInfoArrays.count * 4 / 5 && _allowRequest) {
        [_viewModel loadCollectionItemInfoDataWithType:HotType Page:_currentPage++];
        _allowRequest = NO;
    }
    
    return _cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return _viewModel.collectionItemInfoArrays.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.djDelegate respondsToSelector:@selector(notifacationHomeViewPushDetailWithItemInfo:)]) {
        [self.djDelegate notifacationHomeViewPushDetailWithItemInfo:_viewModel.collectionItemInfoArrays[indexPath.item]];
    }
}



@end
