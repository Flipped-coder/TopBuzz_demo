//
//  DJScreen.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DJDevice.h"
 
#ifndef DJScreen_h
#define DJScreen_h

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define VIEW_X(View)            (View.frame.origin.x)
#define VIEW_Y(View)            (View.frame.origin.y)
#define VIEW_WIDTH(View)        (View.frame.size.width)
#define VIEW_HEIGHT(View)       (View.frame.size.height)
#define VIEW_CENTER_Y(view) (VIEW_Y(view) + VIEW_HEIGHT(view)) / 2
#define VIEW_CENTER_X(view) (VIEW_X(view) + VIEW_WIDTH(view)) / 2


// 顶部高度
#define TOPSAFA_HEIGHT [DJDevice safeDistanceTop] // 顶部安全区高度
#define TOPSTATUSBAR_HEIGHT [DJDevice statusBarHeight]  // 顶部状态栏高度（包括安全区）
#define NAVIGATION_HEIGHT [DJDevice navigationBarHeight]    // 导航栏高度
#define NAVIGATIONFULL_HEIGHT [DJDevice navigationFullHeight] // 顶部整体高度（导航栏+状态栏）


// 底部高度
#define BOTTOMSAFA_HEIGHT [DJDevice safeDistanceBottom]     // 顶部安全区高度
#define TABBAR_HEIGHT [DJDevice tabBarHeight]               // 底部导航栏高度
#define TABBARFULL_HEIGHT [DJDevice tabBarFullHeight]       // 下面的整体高度(底部导航栏+底部安全区)



// Mine 组件中
#define TOPVIEW_HEIGHT (400 + NAVIGATIONFULL_HEIGHT)
#define BACKGROUND_ONE_HEIGHT 450
#define BACKGROUND_TWO_HEIGHT (TOPVIEW_HEIGHT - 75 - BACKGROUND_TWO_Y + NAVIGATIONFULL_HEIGHT)
#define BACKGROUND_TWO_Y (BACKGROUND_ONE_HEIGHT - 42)



#endif /* DJScreen_h */


