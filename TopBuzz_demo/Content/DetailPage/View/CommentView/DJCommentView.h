//
//  DJCommentView.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import <UIKit/UIKit.h>
#import "DJCommentViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DJCommentViewDelegate <NSObject>
@required
- (void)pushWebViewWithURL:(NSURL *)url;

@end

@interface DJCommentView : UITableView
@property (nonatomic, weak) id <DJCommentViewDelegate> dj_delegate;

- (void)loadCommentData:(NSArray <DJCommentItemInfo *> *)itemInfo;

@end

NS_ASSUME_NONNULL_END
