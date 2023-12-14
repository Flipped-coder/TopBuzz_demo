//
//  DJCollectionView.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJCollectionView.h"
#import "DJCollectionViewCell.h"
#import "DJCollectionLayout.h"


@interface DJCollectionView ()
@property (nonatomic, strong) DJCollectionViewCell *cell;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DJHomeViewModel *viewModel;
@property (nonatomic, strong) dispatch_semaphore_t arraySemaphore;
@property (nonatomic, assign) RequestType currentType;
@property (nonatomic, strong) DJCollectionLayout * layout;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL allowRequest;

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
    }
    return self;
}

- (void)loadCollectionViewDataWithType:(RequestType)type {
    _currentType = type;
    [_viewModel loadCollectionItemInfoDataWithType:_currentType Page:_currentPage++];
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
    
    dispatch_semaphore_wait(_arraySemaphore, DISPATCH_TIME_FOREVER);
    DJCollectionItemInfo *itemInfo = _viewModel.collectionItemInfoArrays[indexPath.item];
    dispatch_semaphore_signal(_arraySemaphore);

    
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
    if ([self.djDelegate respondsToSelector:@selector(notifacationHomeViewPushDetail)]) {
        [self.djDelegate notifacationHomeViewPushDetail];
    }
}



@end
