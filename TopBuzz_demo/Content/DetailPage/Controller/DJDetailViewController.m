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
@property (nonatomic, strong) UIScrollView *currentSrollView;
@property (nonatomic, strong) UIImageView *currentImageView;

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
    for (UIScrollView *subview in _fullPictureBrowser.subviews) {
        // 判断子视图的类类型
        if ([subview isKindOfClass:[UIScrollView class]]) {
            subview.delegate = self;
            subview.maximumZoomScale = 3.0;
            subview.minimumZoomScale = 1.0;
        }
    }
    [self.view addSubview:_fullPictureBrowser];
}

- (void)exitFullPictureBrowser {
    [_fullPictureBrowser removeFromSuperview];
}

- (void)popDetailViewController { 
    [self.navigationController popViewControllerAnimated:YES];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    for (UIView *subview in scrollView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            return subview;
        }
    }
    return NULL;
}


@end
