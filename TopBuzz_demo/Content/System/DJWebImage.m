//
//  DJWebImage.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJWebImage.h"

@interface DJWebImage ()
@property (nonatomic, strong) UIImage *image;

@end

@implementation DJWebImage

- (void)djWebImageWithImageView:(UIImageView *)imageView urlString:(NSString *)urlString {
    _image = [self getMemoryCacheImageWithUrlString:urlString];
    if (_image) {
        imageView.image = _image;
        return;
    }
    
    
    
    
    
}

- (void)loadImageDataWithUrlString:(NSString *)urlString {
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

            
        }
    }];
    // 启动任务
    [dataTask resume];
}



- (UIImage *)getMemoryCacheImageWithUrlString:(NSString *)urlString {
    
    
    
    
    
    
    return NULL;
}


- (UIImage *)getDiskCacheImageWithUrlString:(NSString *)urlString {
    
    
    
    
    
    return NULL;
}









@end
