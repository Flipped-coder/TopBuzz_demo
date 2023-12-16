//
//  DJColor.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ColorWhiteAlpha20 RGBA(255.0, 255.0, 255.0, 0.2)

// 浅灰
#define LIGHT_GRAY [UIColor colorWithRed:(202/255.0) green:(203/255.0) blue:(201/255.0) alpha:1.0]
// 极淡蓝
#define BABY_BLUE [UIColor colorWithRed:(238/255.0) green:(252/255.0) blue:(254/255.0) alpha:1.0]
// 天蓝
#define SKY_BLUE [UIColor colorWithRed:(32/255.0) green:(165/255.0) blue:(236/255.0) alpha:1.0]
// 极淡黄
#define SKY_YELLOW [UIColor colorWithRed:(253/255.0) green:(254/255.0) blue:(236/255.0) alpha:1.0]
// 深灰色
#define DARK_GRAY [UIColor colorWithRed:(119/255.0) green:(119/255.0) blue:(117/255.0) alpha:1.0]
// 微信背景灰
#define WECHAT_BACKGROUND_GREY [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]
// 微信绿
#define WECHAT_GREEN [UIColor colorWithRed:29.0/255 green:192.0/255 blue:99.0/255 alpha:1]
// 亮橘
#define LIGHT_ORANGE [UIColor colorWithRed:(252/255.0) green:(96/255.0) blue:(63/255.0) alpha:1.0]

// 引用超链接蓝色
#define LINK_BLUE [UIColor colorWithRed:(6/255.0) green:(125/255.0) blue:(202/255.0) alpha:1.0]



@interface DJColor : UIView

@end


NS_ASSUME_NONNULL_END
