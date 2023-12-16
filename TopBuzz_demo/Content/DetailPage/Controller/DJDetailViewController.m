//
//  DJDetailViewController.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJDetailViewController.h"
#import "DJDetailView.h"
#import "DJScreen.h"
#import <SafariServices/SafariServices.h>

@interface DJDetailViewController () <DJNavigationViewDelegate, DJDetailViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) DJCollectionItemInfo *itemInfo;
@property (nonatomic, strong) DJDetailView *detailView;
@property (nonatomic, strong) UIScrollView *fullPictureBrowser;
@property (nonatomic, strong) UIScrollView *currentSrollView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, assign) int currentPictureBrowserPage;

@end

@implementation DJDetailViewController

- (instancetype)initWithItemInfo:(DJCollectionItemInfo *)itemInfo {
    self = [self init];
    if (self) {
        _itemInfo = itemInfo;
        _currentPictureBrowserPage = 0;
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
    [_detailView.pictureBrowser setContentOffset:CGPointMake(VIEW_WIDTH(_detailView.pictureBrowser) * _currentPictureBrowserPage, 0) animated:NO];
    [_fullPictureBrowser removeFromSuperview];
}

- (void)popDetailViewController { 
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushWebViewControllerWithURL:(NSURL *)url {
    // 创建 SFSafariViewController 对象，并传入要打开的 URL
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:url];

    // 在当前视图控制器上以模态方式显示 SFSafariViewController
    [self presentViewController:safariViewController animated:YES completion:nil];
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    for (UIView *subview in scrollView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            return subview;
        }
    }
    return NULL;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _fullPictureBrowser) {
        CGPoint contentOffset = scrollView.contentOffset;
        _currentPictureBrowserPage = contentOffset.x / SCREEN_WIDTH;
    }
}


@end
