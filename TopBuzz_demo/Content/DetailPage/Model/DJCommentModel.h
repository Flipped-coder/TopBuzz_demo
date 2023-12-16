//
//  DJCommentModel.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SourceCommentItemInfo;

#pragma mark - CommemtModel_Class
@interface DJCommentModel : NSObject
@property (nonatomic, strong) NSArray<SourceCommentItemInfo *> *sourceCommentItemArray;     // 评论模型数组

/// 网络请求博客的评论数据
/// - Parameters:
///   - Id: 博客ID
///   - uid: 博主uid
- (void)loadSourceCommemtDataItemInfoListWithID:(NSString *)Id uid:(NSString *)uid;

@end


#pragma mark - CommemtData_Model

@interface SourceCommentItemInfo : NSObject
@property (nonatomic, strong) NSString *com_created_at;        // 评论时间
@property (nonatomic, strong) NSString *com_text;              // 评论内容
@property (nonatomic, strong) NSString *com_screen_name;       // 用户昵称
@property (nonatomic, strong) NSString *com_location;          // 用户位置
@property (nonatomic, strong) NSString *com_profile_image_url; // 用户头像图片url


/// 将网络数据字典转为模型
/// - Parameter dictionary: 网络原数据
+ (SourceCommentItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary;

@end




NS_ASSUME_NONNULL_END
