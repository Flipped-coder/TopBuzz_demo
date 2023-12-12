//
//  DJHomeViewModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeViewModel.h"

@interface DJHomeViewModel ()
@property (nonatomic, strong) DJHomeModel *model;

@end


@implementation DJHomeViewModel

- (void)bindModel:(DJHomeModel *)model {
    self.model = model;
    
    [model addObserver:self forKeyPath:@"" options:NSKeyValueObservingOptionNew context:nil];


}

// 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@""]) {
        // 处理属性变化
        id newValue = change[NSKeyValueChangeNewKey];
        NSLog(@"Property Value Changed: %@", newValue);
    }
}


- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@""];
}

@end
