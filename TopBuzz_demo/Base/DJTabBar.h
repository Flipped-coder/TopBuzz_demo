//
//  DJTabBar.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>
#import "DJTabBarButton.h"

NS_ASSUME_NONNULL_BEGIN

@class DJTabBar;

@protocol MyTabBarDelegate <NSObject>

/**
 *  当自定义tabBar的按钮被点击之后的监听方法
 *
 *  @param tabBar 触发事件的控件
 *  @param from   上一次选中的按钮的tag
 *  @param to     当前选中按钮的tag
 */
- (void)tabBar:(DJTabBar *)tabBar selectedButtonfrom:(NSInteger)from to:(NSInteger)to;

@end


@interface DJTabBar : UIView
/**
 *  发布按钮
 */
@property (nonatomic, weak) UIButton *plusBtn;
/**
 *  所有选项卡按钮
 */
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
/**
 *  当前选中的按钮
 */
@property (nonatomic, weak) UIButton  *selectedButton;

@property (nonatomic, weak) id<MyTabBarDelegate>  delegate;

/**
 *  根据模型创建对应控制器的对应按钮
 *
 *  @param item 数据模型(图片/选中图片/标题)
 */
- (void)addTabBarButton:(UITabBarItem *)item;

@end

NS_ASSUME_NONNULL_END
