//
//  DJCacheLRUManager.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LRUNode : NSObject
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong, nullable) LRUNode *LastNode;
@property (nonatomic, strong, nullable) LRUNode *NextNode;

@end


@interface  CacheLRU: NSObject
@property (nonatomic, strong) NSMutableDictionary *hashMap;
@property (nonatomic, strong) LRUNode *headNode;
@property (nonatomic, strong) LRUNode *tailNode;
@property (nonatomic, strong) NSNumber *capacity;
@property (nonatomic, strong) NSNumber *size;

+ (CacheLRU *)newLRUWithCapacity:(int)capacity;

- (NSArray <LRUNode *> *)putLRUWithUrlString:(NSString *)urlString;

- (void)updateLRUWithUrlString:(NSString *)urlString;

@end


NS_ASSUME_NONNULL_END
