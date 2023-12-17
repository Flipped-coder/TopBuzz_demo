//
//  DJHomeModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeModel.h"
#import <objc/runtime.h>

#pragma mark - Model_implementation
@implementation DJHomeModel
@end



#pragma mark - Dictionary_To_model
@implementation SourceDataItemInfo
/// 将网络原数据解析转为模型
/// - Parameter dictionary: 网络原数据字典
+ (SourceDataItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary {
    SourceDataItemInfo *itemInfo = [[SourceDataItemInfo alloc] init];
    
    /**博客信息**/
    [itemInfo setValue:[dictionary objectForKey:@"created_at"] forKey:@"created_at"];
    [itemInfo setValue:[dictionary objectForKey:@"text_raw"] forKey:@"text"];
    [itemInfo setValue:[dictionary objectForKey:@"region_name"] forKey:@"region_name"];
    [itemInfo setValue:[dictionary objectForKey:@"reposts_count"] forKey:@"reposts_count"];
    [itemInfo setValue:[dictionary objectForKey:@"comments_count"] forKey:@"comments_count"];
    [itemInfo setValue:[dictionary objectForKey:@"attitudes_count"] forKey:@"attitudes_count"];
    [itemInfo setValue:[[dictionary objectForKey:@"id"] stringValue] forKey:@"Id"];
    [itemInfo setValue:@[].mutableCopy forKey:@"pic_urls"];

    // 第二次数据清洗，如果图片数据不完整或者解析失败则返回 nil 抛弃该数据
    NSDictionary *pictureArray = [dictionary objectForKey:@"pic_infos"];
    for (NSString *key in pictureArray) {
        NSDictionary *picDic = pictureArray[key];
        PictureInfo *info = [[PictureInfo alloc] init];
        [info setValue:[[picDic objectForKey:@"thumbnail"] objectForKey:@"url"] forKey:@"thumbnailPicString"];
        [info setValue:[[picDic objectForKey:@"bmiddle"] objectForKey:@"url"] forKey:@"bmiddlePicString"];
        [info setValue:[[picDic objectForKey:@"large"] objectForKey:@"url"] forKey:@"largePicString"];
        [info setValue:[[picDic objectForKey:@"original"] objectForKey:@"url"] forKey:@"originalPicString"];
        [info setValue:[[picDic objectForKey:@"thumbnail"] objectForKey:@"width"] forKey:@"width"];
        [info setValue:[[picDic objectForKey:@"thumbnail"] objectForKey:@"height"] forKey:@"height"];
        if (info.width == nil || info.height == nil)
            return nil;
        [itemInfo.pic_urls addObject:info];
    }
    if (itemInfo.pic_urls.count == 0)
        return nil;
    
    /**用户信息*/
    [itemInfo setValue:[[dictionary objectForKey:@"user"] objectForKey:@"screen_name"] forKey:@"screen_name"];
    [itemInfo setValue:[[dictionary objectForKey:@"user"] objectForKey:@"location"] forKey:@"location"];
    [itemInfo setValue:[[dictionary objectForKey:@"user"] objectForKey:@"avatar_hd"] forKey:@"profile_image_url"];
    [itemInfo setValue:[[dictionary objectForKey:@"user"] objectForKey:@"gender"] forKey:@"gender"];
    [itemInfo setValue:[[[dictionary objectForKey:@"user"] objectForKey:@"id"] stringValue] forKey:@"uid"];
    
    return itemInfo;
}
@end


@implementation PictureInfo

@end
