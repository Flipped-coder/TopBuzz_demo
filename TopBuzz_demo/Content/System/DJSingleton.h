//
//  DJSingleton.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJSingleton : NSObject







///单例方法，只创建一个对象
+ (DJSingleton *)sharedManager;


- (id)init NS_UNAVAILABLE;
- (id)new NS_UNAVAILABLE;
+ (id)alloc NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;



@end

NS_ASSUME_NONNULL_END
