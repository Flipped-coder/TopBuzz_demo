//
//  DJWebImageCacheManager.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJWebImageCacheManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "DJCacheLRUManager.h"

@interface DJWebImageCacheManager ()
@property (nonatomic, strong) NSMutableDictionary *memoryCache;
@property (nonatomic, strong) CacheLRU *memoryLRU;
@property (nonatomic, strong) CacheLRU *diskLRU;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end


@implementation DJWebImageCacheManager

static DJWebImageCacheManager *sharedManager = nil;


+ (DJWebImageCacheManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[DJWebImageCacheManager alloc] init];
        sharedManager.memoryCache = [NSMutableDictionary dictionary];
        CacheLRU *diskLRU = [CacheLRU readFromDiskLRU];
        if (diskLRU == nil) {
            diskLRU = [CacheLRU newLRUWithCapacity:100];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [diskLRU writeToDiskLRU];
            });
        }
        sharedManager.diskLRU = diskLRU;
        sharedManager.memoryLRU = [CacheLRU newLRUWithCapacity:50];
        sharedManager.semaphore = dispatch_semaphore_create(1);
        sharedManager.operationQueue = [[NSOperationQueue alloc] init];
        sharedManager.operationQueue.maxConcurrentOperationCount = 15;
    });
    return sharedManager;
}


- (UIImage *)getImageFromMemoryCacheWithUrlString:(NSString *)urlString {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    UIImage *cachedObject = [_memoryCache objectForKey:[self sha256:urlString]];
    dispatch_semaphore_signal(_semaphore);

    if (cachedObject) {
        [_diskLRU updateLRUWithUrlString:urlString];
        [_memoryLRU updateLRUWithUrlString:urlString];
    }
    return cachedObject;
}

- (void)setMemoryCacheWithImage:(UIImage *)image urlString:(NSString *)urlString {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    [_memoryCache setObject:image forKey:[self sha256:urlString]];

    NSArray <LRUNode *> *deleteArray = [_memoryLRU putLRUWithUrlString:urlString];
    if (deleteArray.count != 0) {
        for (LRUNode *deleteNode in deleteArray) {
            [_memoryCache removeObjectForKey:[self sha256:deleteNode.urlString]];
        }
    }
    dispatch_semaphore_signal(_semaphore);
}


- (UIImage *)getImageFromDiskCacheWithUrlString:(nonnull NSString *)urlString {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    // 使用URL的 sha256 值作为文件名
    NSString *fileName = [self sha256:urlString];
    // 构建完整的图片文件路径
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:fileName];
    
    // 从文件中读取图像数据
    NSData *loadedImageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *loadedImage;
    if (loadedImageData) {
        // 成功加载图像数据，将其转换为 UIImage
        loadedImage = [UIImage imageWithData:loadedImageData];
        [_diskLRU updateLRUWithUrlString:urlString];
        [_memoryLRU updateLRUWithUrlString:urlString];
        [self setMemoryCacheWithImage:loadedImage urlString:urlString];
    } else {
        NSLog(@"Failed to load image data from file");
    }
    return loadedImage;
}



- (void)setDiskCacheWithImage:(nonnull UIImage *)image urlString:(nonnull NSString *)urlString {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];

    // 使用URL的 sha256 值作为文件名
    NSString *fileName = [self sha256:urlString];

    // 构建完整的图片文件路径
    NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:fileName];
    
    // 将图片数据写入文件
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if ([imageData writeToFile:imagePath atomically:YES]) {
        NSLog(@"Image saved successfully at path: %@", imagePath);
        NSArray <LRUNode *> *deleteArray = [_diskLRU putLRUWithUrlString:urlString];
        if (deleteArray.count != 0) {
            for (LRUNode *deleteNode in deleteArray) {
                NSString *directoryNameToRemove = [self sha256:deleteNode.urlString];
                NSString *directoryPathToRemove = [cachesDirectory stringByAppendingPathComponent:directoryNameToRemove];
                // 删除目录
                NSError *error;
                if ([[NSFileManager defaultManager] removeItemAtPath:directoryPathToRemove error:&error]) {
                    NSLog(@"Directory removed successfully");
                } else {
                    NSLog(@"Failed to remove directory with error: %@", error);
                }
            }
        }
    } else {
        NSLog(@"Failed to save image");
    }
}

- (NSString *)sha256:(NSString *)input {
    const char *cString = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];

    CC_SHA256(cString, (CC_LONG)strlen(cString), result);

    NSMutableString *sha256String = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [sha256String appendFormat:@"%02x", result[i]];
    }

    return sha256String;
}


@end




