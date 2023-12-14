//
//  DJDevice.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJDevice : NSObject

/// 顶部安全区高度
+ (CGFloat)safeDistanceTop;

/// 底部安全区高度
+ (CGFloat)safeDistanceBottom;

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)statusBarHeight;

/// 导航栏高度
+ (CGFloat)navigationBarHeight;

/// 状态栏+导航栏的高度
+ (CGFloat)navigationFullHeight;

/// 底部导航栏高度
+ (CGFloat)tabBarHeight;

/// 底部导航栏高度（包括安全区）
+ (CGFloat)tabBarFullHeight;



@end

NS_ASSUME_NONNULL_END
