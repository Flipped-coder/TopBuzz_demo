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
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSLog(@"getMemoryCacheImageWithUrlString");
        return;
    }
    image = [DJWebImage getDiskCacheImageWithUrlString:urlString];
    if (image) {
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSLog(@"getMemoryCacheImageWithUrlString");
        return;
    }
    
    DJWebImageCacheManager *cacheManager = [DJWebImageCacheManager sharedManager];
    //创建操作
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [DJWebImage loadNetworkImageDataWithImageView:imageView urlString:urlString];
    }];
    //将操作添加到队列中
    [cacheManager.operationQueue addOperation:op];
}


+ (UIImage *)getMemoryCacheImageWithUrlString:(NSString *)urlString {
    DJWebImageCacheManager *cacheManager = [DJWebImageCacheManager sharedManager];
    return [cacheManager getImageFromMemoryCacheWithUrlString:urlString];
}


+ (UIImage *)getDiskCacheImageWithUrlString:(NSString *)urlString {
    DJWebImageCacheManager *cacheManager = [DJWebImageCacheManager sharedManager];
    return [cacheManager getImageFromDiskCacheWithUrlString:urlString];
}


+ (void)loadNetworkImageDataWithImageView:(UIImageView *)imageView urlString:(NSString *)urlString {
    NSLog(@"loadNetworkImageDataWithImageView");
    DJWebImageCacheManager *cacheManager = [DJWebImageCacheManager sharedManager];

    
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //创建操作
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setValue:@"https://weibo.com/" forHTTPHeaderField:@"Referer"];
        [request setHTTPMethod:@"GET"];
        // 创建NSURLSession对象
        NSURLSession *session = [NSURLSession sharedSession];
        
        
        __weak typeof(imageView) weakSelf = imageView;



        // 创建NSURLSessionDataTask对象
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                
                __strong typeof(weakSelf) strongSelf = weakSelf;

                // 处理响应数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    DJWebImageCacheManager *cacheManager = [DJWebImageCacheManager sharedManager];
                    UIImage *image = [UIImage imageWithData:data];
                    strongSelf.image = image;
                    strongSelf.contentMode = UIViewContentModeScaleAspectFill;
                    [cacheManager setMemoryCacheWithImage:image urlString:urlString];
                    [cacheManager setDiskCacheWithImage:image urlString:urlString];
                });
            }
        }];
        // 启动任务
        [dataTask resume];


    }];
    //将操作添加到队列中
    [cacheManager.operationQueue addOperation:op];

}

@end
