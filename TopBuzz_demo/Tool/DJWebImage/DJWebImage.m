//
//  DJWebImage.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJWebImage.h"
#import "DJWebImageCacheManager.h"

@interface DJWebImage ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DJWebImage

+ (void)djWebImageWithImageView:(UIImageView *)imageView urlString:(NSString *)urlString {

    UIImage *image = [DJWebImage getMemoryCacheImageWithUrlString:urlString];
    if (image) {
        imageView.image = image;
        NSLog(@"getMemoryCacheImageWithUrlString");
        return;
    }
    [DJWebImage loadNetworkImageDataWithImageView:imageView urlString:urlString];
}


+ (UIImage *)getMemoryCacheImageWithUrlString:(NSString *)urlString {
    DJWebImageCacheManager *cacheManager = [DJWebImageCacheManager sharedManager];
    // 从内存中读取
    UIImage *image = [cacheManager getImageFromMemoryCacheWithUrlString:urlString];
    if (image) {
        // 如果内存中有直接读取返回
        return image;
    }
    // 从磁盘读取
    image = [cacheManager getImageFromDiskCacheWithUrlString:urlString];
    if (image) {
        // 写进内存缓存中
        [cacheManager setMemoryCacheWithImage:image urlString:urlString];
        return image;
    }
    return image;
}


+ (UIImage *)getDiskCacheImageWithUrlString:(NSString *)urlString {
    DJWebImageCacheManager *cacheManager = [DJWebImageCacheManager sharedManager];
    return [cacheManager getImageFromDiskCacheWithUrlString:urlString];
}




+ (void)loadNetworkImageDataWithImageView:(UIImageView *)imageView urlString:(NSString *)urlString {
    NSLog(@"loadNetworkImageDataWithImageView");

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"https://weibo.com/" forHTTPHeaderField:@"Referer"];
    [request setHTTPMethod:@"GET"];
    // 创建NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建NSURLSessionDataTask对象
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            // 处理响应数据
            dispatch_async(dispatch_get_main_queue(), ^{
                DJWebImageCacheManager *cacheManager = [DJWebImageCacheManager sharedManager];
                imageView.image = [UIImage imageWithData:data];
                [cacheManager setMemoryCacheWithImage:imageView.image urlString:urlString];
                [cacheManager setDiskCacheWithImage:imageView.image urlString:urlString];
            });
        }
    }];
    // 启动任务
    [dataTask resume];
}






@end
