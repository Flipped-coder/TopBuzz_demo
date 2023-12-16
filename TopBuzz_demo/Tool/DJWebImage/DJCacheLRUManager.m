//
//  DJCacheLRUManager.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCacheLRUManager.h"

@implementation CacheLRU

+ (CacheLRU *)newLRUWithCapacity:(int)capacity {
    CacheLRU *lru = [[CacheLRU alloc] init];
    lru.size = [NSNumber numberWithInt:0];
    lru.capacity = [NSNumber numberWithInt:capacity];
    lru.hashMap = @{}.mutableCopy;
    lru.headNode = [[LRUNode alloc] init];
    lru.tailNode = [[LRUNode alloc] init];
    
    lru.headNode.NextNode = lru.tailNode;
    lru.tailNode.LastNode = lru.headNode;
    return lru;
}



- (NSArray <LRUNode *> *)putLRUWithUrlString:(NSString *)urlString {
    NSMutableArray *deleteArray = @[].mutableCopy;
    if ([self.size intValue] >= [self.capacity intValue]) {
        for (int i = 0; i < [self.capacity intValue] / 10; i++) {
            LRUNode *deleteNode = self.tailNode.LastNode;
            deleteNode.LastNode.NextNode = deleteNode.NextNode;
            deleteNode.NextNode.LastNode = deleteNode.LastNode;
            deleteNode.LastNode = nil;
            deleteNode.NextNode = nil;
            
            [self.hashMap removeObjectForKey:deleteNode.urlString];
            _size = [NSNumber numberWithInt:[self.size intValue] - 1];

            [deleteArray addObject:deleteNode];
        }
    }
    if ([_hashMap objectForKey:urlString]) {
        [self updateLRUWithUrlString:urlString];
    } else {
        LRUNode *newNode = [[LRUNode alloc] init];
        newNode.urlString = urlString;
        
        _headNode.NextNode.LastNode = newNode;
        newNode.NextNode = _headNode.NextNode;
        _headNode.NextNode = newNode;
        newNode.LastNode = _headNode;
        [_hashMap setObject:newNode forKey:urlString];
        _size = [NSNumber numberWithInt:[self.size intValue] + 1];
    }
    return deleteArray;
}

- (void)updateLRUWithUrlString:(NSString *)urlString {
    LRUNode *node = self.hashMap[urlString];
    if (node == NULL)
        return;
    node.LastNode.NextNode = node.NextNode;
    node.NextNode.LastNode = node.LastNode;
    _headNode.NextNode.LastNode = node;
    node.NextNode = _headNode.NextNode;
    _headNode.NextNode = node;
    node.LastNode = _headNode;
}

@end


@implementation LRUNode

@end

