//
//  DJTabBarController.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJTabBarController.h"
#import "HomeViewController.h"
#import "DJTabBar.h"
#import "DJScreen.h"

#define TABBARITE_NUMBER 5

@interface DJTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *postButton;

@property (nonatomic, weak) DJTabBar *customTabBar;


@end

@implementation DJTabBarController

// 调用init方法的时候, 系统内部会默认调用initWithNibName
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 初始化设置所有UITabBarItems属性
        NSArray *classNameArray = @[@"HomeViewController",
                                    @"UIViewController",
                                    @"UIViewController",
                                    @"UIViewController",
                                    @"UIViewController"];
        
        NSArray *titleArray = @[@"首页", @"消息", @"", @"商城", @"我的"];
        
        NSArray *imageNameArray = @[@"home_normal",
                                    @"message_normal",
                                    @"post_normal",
                                    @"fishpond_normal",
                                    @"account_normal",];
        
        NSArray *hightImageNameArray = @[@"home_highlight",
                                         @"message_highlight",
                                         @"post_highlight",
                                         @"fishpond_highlight",
                                         @"account_highlight"];
        
        for(int i = 0; i < TABBARITE_NUMBER; i++) {
            UIViewController *viewController = [[NSClassFromString(classNameArray[i]) alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
            [self addOneChildVc:navController
                          title:titleArray[i]
                      imageName:imageNameArray[i]
              selectedImageName:hightImageNameArray[i]];
        }
    }
    return self;
}


/**
 *  添加一个子控制器
 *
 *  @param childVc           需要添加的子控制器
 *  @param title             需要调节自控制器的标题
 *  @param imageName         需要调节自控制器的默认状态的图片
 *  @param selectedImageName 需要调节自控制器的选中状态的图片
 */
- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置子控制器的属性
    childVc.view.backgroundColor = [UIColor whiteColor];
    childVc.title = title;

    UIImage *norImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [ UIImage imageNamed:selectedImageName];
    
    childVc.tabBarItem.image = norImage;
    
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // 2.将自控制器添加到tabbar控制器中
    [self addChildViewController:childVc];
    
    // 3.调用自定义tabBar的添加按钮方法, 创建一个与当前控制器对应的按钮
    [self.customTabBar addTabBarButton: childVc.tabBarItem];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建自定义tabBar
    DJTabBar *customTabBar = [[DJTabBar alloc] init];
    // 设置frame
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.frame = CGRectMake(self.tabBar.bounds.origin.x,
                                    self.tabBar.bounds.origin.y,
                                    self.tabBar.bounds.size.width,
                                    TABBARFULL_HEIGHT);
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
    // 设置代理
    customTabBar.delegate = (id)self;
    self.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 遍历系统的tabbar移除不需要的控件
    for (UIView *subView in self.tabBar.subviews) {
        // UITabBarButton私有API, 普通开发者不能使用
        if ([subView isKindOfClass:[UIControl class]]) {
            // 判断如果子控件时UITabBarButton, 就删除
            [subView removeFromSuperview];
        }
    }
}


#pragma mark - TabBarD·elegate
- (void)tabBar:(DJTabBar *)tabBar selectedButtonfrom:(NSInteger)from to:(NSInteger)to
{
    NSLog(@"从第%ld控制器切换到第%ld控制器",(long)from,(long)to);
    
    if (from != to) {
        UIImageView *imageView = [tabBar.buttons[to] imageView];
        [self addRotateAnimationOnView:imageView];
    }

    self.selectedIndex = to;
}


/// 旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
   [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
       animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
   } completion:nil];
   
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
           animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
       } completion:nil];
   });
}



@end
