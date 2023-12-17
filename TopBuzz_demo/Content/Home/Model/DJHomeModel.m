//
//  DJHomeModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeModel.h"
#import <objc/runtime.h>


// 网络资源请求 URL
#define HOT_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=0&group_id=102803&containerid=102803&extparam=discover%7Cnew_feed&max_id=0"
#define LOCAL_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028032222&containerid=102803_2222&extparam=discover%7Cnew_feed&max_id=0"
#define FINANCE_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028036388&containerid=102803_ctg1_6388_-_ctg1_6388&extparam=discover%7Cnew_feed&max_id=0"
#define INTERNATION_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028036288&containerid=102803_ctg1_6288_-_ctg1_6288&extparam=discover%7Cnew_feed&max_id=0"
#define SCIENCE_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028035988&containerid=102803_ctg1_5988_-_ctg1_5988&extparam=discover%7Cnew_feed&max_id=0"



#pragma mark - Model_implementation
@implementation DJHomeModel
/// 请求网络资源数据
/// - Parameters:
///   - type: 资讯类型
///   - page: 请求范围
- (void)loadSourceDataItemInfoListWithRequestType:(RequestType)type Page:(int)page {
    // 获得当前请求的URL
    NSString *urlString = [self getRequestUrlStringWithRequsetType:type page:page];
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 弱引用self，防止与block发生循环引用
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSError *jsonError;
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (jsonError) {
                NSLog(@"JSON Error: %@", jsonError);
            } else {
                
                
                // 重新强引用，避免在 Block 执行期间被释放
                __strong typeof(weakSelf) strongSelf = weakSelf;
                NSMutableArray <SourceDataItemInfo *>*listItemArray = @[].mutableCopy;
                // 获取网络原数据博客数组
                NSArray *dataArray = [responseObject objectForKey:@"statuses"];
                // 遍历数组，将每个博客原数据转为model
                for (NSDictionary *dic in dataArray) {
                    // 对于不需要的数据进行初次清洗（由于业务需求只展示有图片的博客，因此没有图片的直接扔掉）
                    if ([(NSNumber *)[dic objectForKey:@"pic_num"] compare:@0] != NSOrderedSame) {
                        // 博客字典转模型
                        SourceDataItemInfo *itemInfo = [SourceDataItemInfo getSourceModelFromDictionary:dic];
                        if (itemInfo) {
                            [listItemArray addObject:itemInfo];
                        }
                    }
                }
                // 赋值更新模型数组（ViewModel 通过KVO监听该属性的setter方法）后续操作由 ViewModel 进行处理
                strongSelf.sourceDataItemArray = listItemArray;
            }
            
        }
    }];
    [dataTask resume];
}

/// 通过请求咨询类型的到URL
/// - Parameters:
///   - type: 咨询类型
///   - page: 请求范围
- (NSString *)getRequestUrlStringWithRequsetType:(RequestType)type page:(int)page{
    switch (type) {
        case HotType:
            return [[HOT_URL stringByAppendingString:@"&page="] stringByAppendingString:[NSString stringWithFormat:@"%d", page]];
        case LocalType:
            return [[LOCAL_URL stringByAppendingString:@"&page="] stringByAppendingString:[NSString stringWithFormat:@"%d", page]];
        case InternationType:
            return [[INTERNATION_URL stringByAppendingString:@"&page="] stringByAppendingString:[NSString stringWithFormat:@"%d", page]];
        case FinanceType:
            return [[FINANCE_URL stringByAppendingString:@"&page="] stringByAppendingString:[NSString stringWithFormat:@"%d", page]];
        case ScienceType:
            return [[SCIENCE_URL stringByAppendingString:@"&page="] stringByAppendingString:[NSString stringWithFormat:@"%d", page]];
    }
}

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
