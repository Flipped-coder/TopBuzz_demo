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


@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) DJHomeView *homeView;
@property (nonatomic, strong) DJCollectionViewCell *cell;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DJHomeViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> *collectionItemInfoArray;
@property (nonatomic, assign) int currentPage;

@end

@implementation HomeViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        DJHomeViewModel *viewModel = [[DJHomeViewModel alloc] init];
        [self bindViewModel:viewModel];
        [_viewModel loadCollectionItemInfoDataWithType:HotType Page:1];
        _currentPage = 1;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    
    self.homeView = [[DJHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARFULL_HEIGHT)];
    [self.view addSubview:self.homeView];
    
    self.homeView.videoCollectionViewArray[0].delegate = self;
    self.homeView.videoCollectionViewArray[0].dataSource = self;
    [self.homeView.videoCollectionViewArray[0] registerClass:[DJCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}

- (void)bindViewModel:(DJHomeViewModel *)viewModel {
    _viewModel = viewModel;
    [viewModel addObserver:self forKeyPath:@"collectionItemInfoArray" options:NSKeyValueObservingOptionNew context:nil];
}

// 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"collectionItemInfoArray"]) {
        // 处理属性变化
        id newValue = change[NSKeyValueChangeNewKey];
        NSLog(@"Property Value Changed: %@", newValue);
    }
}

- (void)dealloc {
    [self.viewModel removeObserver:self forKeyPath:@"collectionItemInfoArray"];
}



#pragma mark UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    static NSString *CellIdentifier = @"cell";
    DJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
 
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return 100;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.item % 3 == 0) {
//        return CGSizeMake((SCREEN_WIDTH - 10) / 2, 100);
//    } else {
//        return CGSizeMake((SCREEN_WIDTH - 10) / 2, 300);
//    }
//}
//





@end
