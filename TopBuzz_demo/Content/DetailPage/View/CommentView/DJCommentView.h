//
//  DJCommentView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import <UIKit/UIKit.h>
#import "DJHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJCommentView : UITableView

- (void)loadCommentData:(NSArray <DJCommentItemInfo *> *)itemInfo;

@end

NS_ASSUME_NONNULL_END