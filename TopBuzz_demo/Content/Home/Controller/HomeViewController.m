//
//  HomeViewController.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "HomeViewController.h"
#import "DJHomeView.h"
#import "DJScreen.h"
#import "DJCollectionViewCell.h"
#import "DJHomeViewModel.h"
#import "DJDetailViewController.h"


@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, strong) DJHomeView *homeView;
@property (nonatomic, strong) DJCollectionViewCell *cell;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DJHomeViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> *collectionItemInfoArray;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) BOOL allowRequest;
@property (nonatomic, strong) dispatch_semaphore_t arraySemaphore;

@end

@implementation HomeViewController {
    CGPoint lastOffset;
    NSTimeInterval lastTime;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        DJHomeViewModel *viewModel = [[DJHomeViewModel alloc] init];
        [self bindViewModel:viewModel];
        _currentPage = 1;
        [_viewModel loadCollectionItemInfoDataWithType:HotType Page:_currentPage++];
        _collectionItemInfoArray = @[].mutableCopy;
        _allowRequest = YES;
        _arraySemaphore = dispatch_semaphore_create(1);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];

    
    _homeView = [[DJHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARFULL_HEIGHT)];
    [self.view addSubview:_homeView];
    
//    _homeView.videoCollectionViewArray[0].delegate = self;
//    _homeView.videoCollectionViewArray[0].dataSource = self;
//    [_homeView.videoCollectionViewArray[0] registerClass:[DJCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}

- (void)bindViewModel:(DJHomeViewModel *)viewModel {
    _viewModel = viewModel;
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

        [_homeView.layout appendCollectionItemInfoArray:newValue];
        _allowRequest = YES;
        
        __weak __typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __typeof(&*weakSelf) strongSelf = weakSelf;
            [strongSelf.homeView.videoCollectionViewArray[0] reloadData];
        });
    }
}

- (void)dealloc {
    [_viewModel removeObserver:self forKeyPath:@"collectionItemInfoArray"];
}



#pragma mark UICollectionViewDelegate

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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DJDetailViewController *detailVC = [[DJDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}





@end
