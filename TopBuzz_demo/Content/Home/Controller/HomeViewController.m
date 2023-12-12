//
//  HomeViewController.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "HomeViewController.h"
#import "DJHomeView.h"
#import "DJScreen.h"

@interface HomeViewController ()
@property (nonatomic, strong) DJHomeView *homeView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.homeView = [[DJHomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBARFULL_HEIGHT)];
    [self.view addSubview:self.homeView];
    
    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
