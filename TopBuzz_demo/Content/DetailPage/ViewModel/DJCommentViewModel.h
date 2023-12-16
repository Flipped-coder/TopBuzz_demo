//
//  DJCommentViewModel.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import <Foundation/Foundation.h>
#import "DJCommentModel.h"

@class DJCommentItemInfo;
NS_ASSUME_NONNULL_BEGIN

#pragma mark - CommentViewModel
@interface DJCommentViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <DJCommentItemInfo *> * commentItemInfoArray;  // 视图评论数据数组
@property (nonatomic, strong) NSNumber *commentHeightSum;      // 所有Cell所需的总高度
/// 加载CommentView所需的模型数据
/// - Parameters:
///   - Id: 博客ID
///   - uid: 博主UID
- (void)loadCommentDataWithID:(NSString *)Id uid:(NSString *)uid;

@end


#pragma mark - CommentViewItemInfo
@interface DJCommentItemInfo : NSObject
@property (nonatomic, strong) NSString *com_text;              // 评论内容
@property (nonatomic, strong) NSString *com_created_at;        // 评论时间
@property (nonatomic, strong) NSString *com_screen_name;       // 用户昵称
@property (nonatomic, strong) NSString *com_location;          // 用户位置
@property (nonatomic, strong) NSString *com_profile_image_url; // 用户头像图片url
@property (nonatomic, strong) NSNumber *text_height;           // 文本高度
@property (nonatomic, strong) NSNumber *cell_height;           // 当前视图所需高度
@property (nonatomic, strong) NSAttributedString *textAttributedString;     // // 富文本字符属性
/// 将原数据模型转为View模型
/// - Parameter sourceData: 原数据模型
+ (DJCommentItemInfo *)getCommentItemFromSourceData:(SourceCommentItemInfo *)sourceData;

@end



NS_ASSUME_NONNULL_END
