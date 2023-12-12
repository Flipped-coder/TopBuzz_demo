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

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) DJHomeView *homeView;
@property (nonatomic, strong) DJCollectionViewCell *cell;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    
    self.homeView = [[DJHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARFULL_HEIGHT)];
    [self.view addSubview:self.homeView];
    
    self.homeView.videoCollectionViewArray[0].delegate = self;
    self.homeView.videoCollectionViewArray[0].dataSource = self;
    [self.homeView.videoCollectionViewArray[0] registerClass:[DJCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    
    
    
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
//- (void)encodeWithCoder:(nonnull NSCoder *)coder { 
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection { 
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize { 
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator { 
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate { 
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context { 
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded { 
//    <#code#>
//}







//self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//[self.view addSubview:self.imageView];



//NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://tvax2.sinaimg.cn/crop.0.0.1080.1080.50/005YEhFZly8hhmc4ltc3kj30u00u040c.jpg?KID=imgbed,tva&Expires=1702398663&ssig=B0hxGnLh%2F4"]];
//[request setValue:@"https://weibo.com/" forHTTPHeaderField:@"Referer"];
//[request setHTTPMethod:@"GET"];
//// 创建NSURLSession对象
//NSURLSession *session = [NSURLSession sharedSession];
//
//// 创建NSURLSessionDataTask对象
//NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//    if (error) {
//        NSLog(@"Error: %@", error);
//    } else {
//        // 处理响应数据
//        UIImage *image = [UIImage imageWithData:data];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageView.image = image;
//        });
//
//    }
//}];
//
//// 启动任务
//[dataTask resume];


@end
