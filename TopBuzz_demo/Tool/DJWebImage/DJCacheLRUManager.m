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
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self writeToDiskLRU];
        });
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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self writeToDiskLRU];
    });
}

- (void)writeToDiskLRU {
    NSError *error;
    NSURL *docsURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                            inDomain:NSUserDomainMask
                                                   appropriateForURL:nil
                                                              create:YES
                                                               error:&error];
    NSString *databasePath = [docsURL URLByAppendingPathComponent:@"DiskCacheLRU"].path;
    
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self requiringSecureCoding:NO error:&error];
//    [data writeToFile:databasePath options:NSDataWritingAtomic error:&error];
    [NSKeyedArchiver archiveRootObject:self toFile:databasePath];
}

+ (CacheLRU *)readFromDiskLRU {
    NSError *error;
    NSURL *docsURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                            inDomain:NSUserDomainMask
                                                   appropriateForURL:nil
                                                              create:YES
                                                               error:&error];
    NSString *databasePath = [docsURL URLByAppendingPathComponent:@"DiskCacheLRU"].path;
    
    CacheLRU *lru = [NSKeyedUnarchiver unarchiveObjectWithFile:databasePath];
    return lru;
    
}




- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.hashMap forKey:@"hashMap"];
    [encoder encodeObject:self.headNode forKey:@"headNode"];
    [encoder encodeObject:self.tailNode forKey:@"tailNode"];
    [encoder encodeObject:self.capacity forKey:@"capacity"];
    [encoder encodeObject:self.size forKey:@"size"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.hashMap = [decoder decodeObjectForKey:@"hashMap"];
        self.headNode = [decoder decodeObjectForKey:@"headNode"];
        self.tailNode = [decoder decodeObjectForKey:@"tailNode"];
        self.capacity = [decoder decodeObjectForKey:@"capacity"];
        self.size = [decoder decodeObjectForKey:@"size"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end


@implementation LRUNode

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.urlString forKey:@"urlString"];
    [encoder encodeObject:self.LastNode forKey:@"LastNode"];
    [encoder encodeObject:self.NextNode forKey:@"NextNode"];

}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.urlString = [decoder decodeObjectForKey:@"urlString"];
        self.LastNode = [decoder decodeObjectForKey:@"LastNode"];
        self.NextNode = [decoder decodeObjectForKey:@"NextNode"];
    }
    return self;
}

@end

