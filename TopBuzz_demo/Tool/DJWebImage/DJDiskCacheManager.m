//
//  DJDiskCacheManager.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJDiskCacheManager.h"

@implementation DiskCacheLRU

+ (DiskCacheLRU *)newLRUWithCapacity:(int)capacity {
    DiskCacheLRU *lru = [[DiskCacheLRU alloc] init];
    lru.size = [NSNumber numberWithInt:0];
    lru.capacity = [NSNumber numberWithInt:capacity];
    lru.hashMap = @{}.mutableCopy;
    lru.headNode = [[LRUNode alloc] init];
    lru.tailNode = [[LRUNode alloc] init];
    
    lru.headNode.NextNode = lru.tailNode;
    lru.tailNode.LastNode = lru.headNode;
    return lru;
}



- (LRUNode *)putLRUWithUrlString:(NSString *)urlString {
    LRUNode *deleteNode;
    if ([self.size intValue] == [self.capacity intValue]) {
        deleteNode = self.tailNode.LastNode;
        deleteNode.LastNode.NextNode = self.tailNode;
        self.tailNode.LastNode = deleteNode.LastNode;
        [self.hashMap removeObjectForKey:deleteNode.urlString];
    }
    LRUNode *newNode = [[LRUNode alloc] init];
    newNode.urlString = urlString;
    newNode.NextNode = self.headNode.NextNode;
    self.headNode.NextNode.LastNode = newNode;
    newNode.LastNode = self.headNode;
    self.headNode.NextNode = newNode;
    
    [self.hashMap setObject:newNode forKey:urlString];
    self.size = [NSNumber numberWithInt:[self.size intValue] + 1];
    
    return deleteNode;
}

- (void)updateLRUWithUrlString:(NSString *)urlString {
    LRUNode *node = self.hashMap[urlString];
    if (node == NULL)
        return;
    node.LastNode.NextNode = node.NextNode;
    node.NextNode.LastNode = node.LastNode;
    
    node.NextNode = self.headNode.NextNode;
    self.headNode.NextNode.LastNode = node;
    self.headNode.NextNode = node;
    node.LastNode = self.headNode;
}

@end


@implementation LRUNode

@end
