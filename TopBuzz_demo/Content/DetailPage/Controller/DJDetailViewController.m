//
//  DJDetailViewController.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJDetailViewController.h"
#import "DJDetailView.h"
#import "DJScreen.h"

@interface DJDetailViewController () <DJNavigationViewDelegate, DJDetailViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) DJCollectionItemInfo *itemInfo;
@property (nonatomic, strong) DJDetailView *detailView;
@property (nonatomic, strong) UIScrollView *fullPictureBrowser;

@end

@implementation DJDetailViewController

- (instancetype)initWithItemInfo:(DJCollectionItemInfo *)itemInfo {
    self = [self init];
    if (self) {
        _itemInfo = itemInfo;
        DJDetailNavigationBar *navBar = [[DJDetailNavigationBar alloc] initWithFrame:CGRectMake(0, TOPSTATUSBAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_HEIGHT) itemInfo:itemInfo];
        _detailView = [[DJDetailView alloc] initWithFrame:CGRectMake(0, VIEW_Y(navBar) + VIEW_HEIGHT(navBar), SCREEN_WIDTH, SCREEN_HEIGHT) itemInfo:itemInfo];
        
        navBar.delegate = self;
        _detailView.dj_delegate = self;

        [self.view addSubview:navBar];
        [self.view addSubview:_detailView];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_detailView loadMorePicture];
}






- (void)loadFullPictureBrowser:(UIScrollView *)fullPictureBrowser {
    _fullPictureBrowser = fullPictureBrowser;
    _fullPictureBrowser.delegate = self;
    _fullPictureBrowser.maximumZoomScale = 3.0; // 设置最大缩放比例
    _fullPictureBrowser.minimumZoomScale = 1.0; // 设置最小缩放比例
    [self.view addSubview:_fullPictureBrowser];
}

- (void)exitFullPictureBrowser {
    [_fullPictureBrowser removeFromSuperview];
}

- (void)popDetailViewController { 
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIScrollViewDelegate


@end
