//
//  DJCommentModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCommentModel.h"

@implementation DJCommentModel
@end


#pragma mark - Dictionary_To_model
@implementation SourceCommentItemInfo
/// 将网络原数据解析转为模型
/// - Parameter dictionary: 网络原数据字典
+ (SourceCommentItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary {
    SourceCommentItemInfo *itemInfo = [[SourceCommentItemInfo alloc] init];
    [itemInfo setValue:[dictionary objectForKey:@"created_at"] forKey:@"com_created_at"];
    [itemInfo setValue:[dictionary objectForKey:@"text_raw"] forKey:@"com_text"];
    [itemInfo setValue:[[dictionary objectForKey:@"user"] objectForKey:@"screen_name"] forKey:@"com_screen_name"];
    [itemInfo setValue:[dictionary objectForKey:@"source"] forKey:@"com_location"];
    [itemInfo setValue:[[dictionary objectForKey:@"user"] objectForKey:@"avatar_hd"] forKey:@"com_profile_image_url"];

    return itemInfo;
}


@end
