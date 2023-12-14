//
//  DJDiskCacheManager.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface LRUNode : NSObject
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) LRUNode *LastNode;
@property (nonatomic, strong) LRUNode *NextNode;

@end


@interface DiskCacheLRU : NSObject
@property (nonatomic, strong) NSMutableDictionary *hashMap;
@property (nonatomic, strong) LRUNode *headNode;
@property (nonatomic, strong) LRUNode *tailNode;
@property (nonatomic, strong) NSNumber *capacity;
@property (nonatomic, strong) NSNumber *size;

+ (DiskCacheLRU *)newLRUWithCapacity:(int)capacity;

- (LRUNode *)putLRUWithUrlString:(NSString *)urlString;

- (void)updateLRUWithUrlString:(NSString *)urlString;




- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)alloc NS_UNAVAILABLE;
- (void)dealloc NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
