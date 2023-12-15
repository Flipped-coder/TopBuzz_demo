//
//  DJTabBar.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJTabBar.h"
#import "DJScreen.h"

@implementation DJTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - 设置子控件frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置选项卡按钮的frame
    [self setupBtnFrame];
}



/// 设置选项卡按钮的frame
- (void)setupBtnFrame
{
    
    // 遍历数组设置选项卡frame
    // 计算宽度, 获取高度, 获取按钮的个数只需要执行一次即可
    int count = (int)self.buttons.count;
    CGFloat btnWidth  = self.frame.size.width / count;
    CGFloat btnHeigth = self.frame.size.height - BOTTOMSAFA_HEIGHT;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.buttons[i];
        
        if (i == count / 2) {
            btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, btnHeigth * 1.6); continue;
        }
        
        btn.frame = CGRectMake( i * btnWidth, 0, btnWidth, btnHeigth);
    }
    
}


#pragma mark - 添加按钮方法
- (void)addTabBarButton:(UITabBarItem *)item
{
    // 1.创建按钮
    DJTabBarButton *btn = [[DJTabBarButton alloc] init];
    
    // 2.从UITabBarItem取出标题, 设置标题
    btn.item = item;
    
    [self addSubview:btn];
    
    // 设置按钮的tag
    btn.tag = self.buttons.count;
    
    // 3.每次添加完按钮后将按钮存储到数组中
    [self.buttons addObject:btn];
    
    // 4.监听按钮点击事件
    [btn addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchDown];
    
    // 5.设置默认选中的按钮
    if (self.buttons.count == 1) {
        // 选中某一个按钮就相当于点击某一个按钮
        [self buttonOnClick:btn];
    }
}


- (void)buttonOnClick:(UIButton *)btn
{
    // 通知代理按钮被点击了
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedButtonfrom:to:)]) {
        [self.delegate tabBar:self selectedButtonfrom:self.selectedButton.tag to:btn.tag];
    }
    
    // 取消上一次选中的按钮
    self.selectedButton.selected = NO;
    // 选中当前按钮
    btn.selected = YES;
    // 记录当前选中的按钮
    self.selectedButton = btn;
}



#pragma mark - 懒加载
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UIButton *)plusBtn
{
    if (_plusBtn == nil) {
        UIButton *plusBtn = [[UIButton alloc] init];
        // 1.2.设置背景图片
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"bg2"] forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"bg2"] forState:UIControlStateHighlighted];
        // 1.3.设置图标
        [plusBtn setImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
        [plusBtn setImage:[UIImage imageNamed:@"post_highlight"] forState:UIControlStateHighlighted];
        // 1.4.添加
        [self addSubview:plusBtn];
        _plusBtn = plusBtn;
        
    }
    return _plusBtn;
}




@end
