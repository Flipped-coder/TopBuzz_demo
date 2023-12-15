//
//  DJDetailViewController.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJDetailViewController.h"
#import "DJDetailView.h"
#import "DJScreen.h"

@interface DJDetailViewController ()
@property (nonatomic, strong) DJCollectionItemInfo *itemInfo;
@property (nonatomic, strong) DJDetailView *detailView;

@end

@implementation DJDetailViewController

- (instancetype)initWithItemInfo:(DJCollectionItemInfo *)itemInfo {
    self = [self init];
    if (self) {
        _itemInfo = itemInfo;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        DJDetailNavigationBar *navBar = [[DJDetailNavigationBar alloc] initWithFrame:CGRectMake(0, TOPSTATUSBAR_HEIGHT, SCREEN_WIDTH, NAVIGATION_HEIGHT) itemInfo:itemInfo];
        [self.view addSubview:navBar];
        _detailView = [[DJDetailView alloc] initWithFrame:CGRectMake(0, VIEW_Y(navBar) + VIEW_HEIGHT(navBar), SCREEN_WIDTH, SCREEN_HEIGHT) itemInfo:itemInfo];
        [self.view addSubview:_detailView];

    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}






@end
