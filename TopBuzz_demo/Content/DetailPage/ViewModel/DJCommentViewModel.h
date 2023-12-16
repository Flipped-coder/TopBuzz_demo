//
//  DJCommentViewModel.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import <Foundation/Foundation.h>
#import "DJCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJCommentItemInfo : NSObject
@property (nonatomic, strong) NSString *com_created_at;        //评论时间
@property (nonatomic, strong) NSString *com_text;              //评论内容
@property (nonatomic, strong) NSString *com_screen_name;       //用户昵称
@property (nonatomic, strong) NSString *com_location;          //用户位置
@property (nonatomic, strong) NSString *com_profile_image_url; //用户头像图片url
@property (nonatomic, strong) NSNumber *text_height;
@property (nonatomic, strong) NSNumber *cell_height;
@property (nonatomic, strong) NSAttributedString *textAttributedString;

+ (DJCommentItemInfo *)getCommentItemFromSourceData:(SourceCommentItemInfo *)sourceData;

@end



@interface DJCommentViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <DJCommentItemInfo *> * commentItemInfoArray;
@property (nonatomic, strong) NSNumber *commentHeightSum;

- (void)loadCommentDataWithID:(NSString *)Id uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
