//
//  DJWebImageCacheManager.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJWebImageCacheManager : NSObject
@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (UIImage *)getImageFromMemoryCacheWithUrlString:(NSString *)urlString;
- (void)setMemoryCacheWithImage:(UIImage *)image urlString:(NSString *)urlString;


- (UIImage *)getImageFromDiskCacheWithUrlString:(NSString *)urlString;
- (void)setDiskCacheWithImage:(UIImage *)image urlString:(NSString *)urlString;



+ (DJWebImageCacheManager *)sharedManager;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)alloc NS_UNAVAILABLE;
- (void)dealloc NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

@end



NS_ASSUME_NONNULL_END
