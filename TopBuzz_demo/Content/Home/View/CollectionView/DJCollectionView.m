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
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> *collectionItemInfoArray;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL allowRequest;
@property (nonatomic, strong) dispatch_semaphore_t arraySemaphore;
@property (nonatomic, assign) RequestType currentType;
@property (nonatomic, strong) DJCollectionLayout * layout;

@end



@implementation DJCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout collectionType:(RequestType)type {
    self = [self initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[DJCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _layout = layout;
        _viewModel = [[DJHomeViewModel alloc] init];
        [self bindViewModel:_viewModel];
        _currentType = type;
        _currentPage = 1;
        _collectionItemInfoArray = @[].mutableCopy;
        _allowRequest = YES;
        _arraySemaphore = dispatch_semaphore_create(1);
        [_viewModel loadCollectionItemInfoDataWithType:_currentType Page:_currentPage++];

        
    }
    return self;
}


- (void)bindViewModel:(DJHomeViewModel *)viewModel {
    [viewModel addObserver:self forKeyPath:@"collectionItemInfoArray" options:NSKeyValueObservingOptionNew context:nil];
}

// 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"collectionItemInfoArray"]) {
        // 处理属性变化
        NSMutableArray <DJCollectionItemInfo *> *newValue = change[NSKeyValueChangeNewKey];
        dispatch_semaphore_wait(_arraySemaphore, DISPATCH_TIME_FOREVER);
        [_collectionItemInfoArray addObjectsFromArray:newValue];
        dispatch_semaphore_signal(_arraySemaphore);

        [_layout appendCollectionItemInfoArray:newValue];
        _allowRequest = YES;
        
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
    DJCollectionItemInfo *itemInfo = _collectionItemInfoArray[indexPath.item];
    dispatch_semaphore_signal(_arraySemaphore);

    
    [_cell layoutCollectionViewCellWithData:itemInfo];
 
    if (indexPath.item > _collectionItemInfoArray.count * 4 / 5 && _allowRequest) {
        [_viewModel loadCollectionItemInfoDataWithType:HotType Page:_currentPage++];
        _allowRequest = NO;
    }
    
    return _cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return _collectionItemInfoArray.count;
}

@end
