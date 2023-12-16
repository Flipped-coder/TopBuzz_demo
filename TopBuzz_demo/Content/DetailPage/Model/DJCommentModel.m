//
//  DJCommentModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCommentModel.h"
#define COMMENT_URL @"https://weibo.com/ajax/statuses/buildComments?is_reload=1&is_show_bulletin=2&is_mix=0&count=20&type=feed&fetch_level=0&locale=zh-CN$count=100"    // 评论URL

@implementation DJCommentModel

/// 网络请求博客的评论数据
/// - Parameters:
///   - Id: 博客ID
///   - uid: 博主uid
- (void)loadSourceCommemtDataItemInfoListWithID:(NSString *)Id uid:(NSString *)uid {
    NSString *urlString = [[[[COMMENT_URL stringByAppendingString:@"&id="] stringByAppendingString:Id] stringByAppendingString:@"&uid="] stringByAppendingString:uid];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 弱引用 self 防止与Block形成循环引用
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
                
                __strong typeof(weakSelf) strongSelf = weakSelf; // 重新强引用，避免在 Block 执行期间被释放
                NSMutableArray <SourceCommentItemInfo *>*listItemArray = @[].mutableCopy;
                NSArray *dataArray = [responseObject objectForKey:@"data"];
                // 如果没有评论数据则直接返回
                if (dataArray.count == 0)
                    return;
                // 遍历网络数据字典转模型
                for (NSDictionary *dic in dataArray) {
                    // 字典转模型
                    SourceCommentItemInfo *itemInfo = [SourceCommentItemInfo getSourceModelFromDictionary:dic];
                    [listItemArray addObject:itemInfo];
                }
                // 赋值更新模型数组（ViewModel 通过KVO监听该属性的setter方法）后续操作由 ViewModel 进行处理
                strongSelf.sourceCommentItemArray = listItemArray;
            }
        }
    }];

    [dataTask resume];
}

@end


#pragma mark - Dictionary_To_model
@implementation SourceCommentItemInfo
/// 将网络原数据解析转为模型
/// - Parameter dictionary: 网络原数据字典
+ (SourceCommentItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary {
    SourceCommentItemInfo *itemInfo = [[SourceCommentItemInfo alloc] init];
    itemInfo.com_created_at = [dictionary objectForKey:@"created_at"];
    itemInfo.com_text = [dictionary objectForKey:@"text_raw"];
    itemInfo.com_screen_name = [[dictionary objectForKey:@"user"] objectForKey:@"screen_name"];
    itemInfo.com_location = [dictionary objectForKey:@"source"];
    itemInfo.com_profile_image_url = [[dictionary objectForKey:@"user"] objectForKey:@"avatar_hd"];
    return itemInfo;
}


@end
