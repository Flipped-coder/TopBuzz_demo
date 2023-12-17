//
//  DJCommentNetworking.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/17.
//

#import <Foundation/Foundation.h>
#import "DJCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJCommentNetworking : NSObject
/// 网络请求博客的评论数据
/// - Parameters:
///   - Id: 博客ID
///   - uid: 博主uid
+ (void)loadSourceCommemtDataItemInfoListWithID:(NSString *)Id uid:(NSString *)uid model:(DJCommentModel *)model;

@end

NS_ASSUME_NONNULL_END
