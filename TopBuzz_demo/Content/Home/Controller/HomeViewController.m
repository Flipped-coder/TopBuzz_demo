//
//  HomeViewController.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "HomeViewController.h"
#import "DJHomeView.h"
#import "DJScreen.h"
#import "DJDetailViewController.h"


@interface HomeViewController () <DJHomeWiewDelegate>

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];

    DJHomeView *homeView = [[DJHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARFULL_HEIGHT)];
    [self.view addSubview:homeView];
    homeView.delegate = self;
}





- (void)pushDetailViewController { 
    DJDetailViewController *detailVC = [[DJDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
