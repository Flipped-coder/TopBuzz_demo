//
//  DJDetailViewController.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/14.
//

#import "DJDetailViewController.h"

@interface DJDetailViewController ()
@property (nonatomic, strong) DJCollectionItemInfo *itemInfo;

@end

@implementation DJDetailViewController

- (instancetype)initWithItemInfo:(DJCollectionItemInfo *)itemInfo {
    self = [self init];
    if (self) {
        _itemInfo = itemInfo;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}






@end
