//
//  DJSingleton.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJSingleton.h"

@implementation DJSingleton

static DJSingleton *sharedManager = nil;


+ (DJSingleton *)sharedManager {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [[DJSingleton alloc] init];
  });
  return sharedManager;
}


+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [super allocWithZone:zone];
    });
    return sharedManager;
}



@end
