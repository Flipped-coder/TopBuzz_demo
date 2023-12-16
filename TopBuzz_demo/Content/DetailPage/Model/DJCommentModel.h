//
//  DJCommentModel.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SourceCommentItemInfo;

@interface DJCommentModel : NSObject
@property (nonatomic, strong) NSArray<SourceCommentItemInfo *> *sourceCommentItemArray;


- (void)loadSourceCommemtDataItemInfoListWithID:(NSString *)Id uid:(NSString *)uid;


@end



@interface SourceCommentItemInfo : NSObject
@property (nonatomic, strong) NSString *com_created_at;        //评论时间
@property (nonatomic, strong) NSString *com_text;              //评论内容
@property (nonatomic, strong) NSString *com_screen_name;       //用户昵称
@property (nonatomic, strong) NSString *com_location;          //用户位置
@property (nonatomic, strong) NSString *com_profile_image_url; //用户头像图片url

+ (SourceCommentItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary;

@end




NS_ASSUME_NONNULL_END
