//
//  DJCommentNetworking.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/17.
//

#import "DJCommentNetworking.h"

#define COMMENT_URL @"https://weibo.com/ajax/statuses/buildComments?is_reload=1&is_show_bulletin=2&is_mix=0&count=20&type=feed&fetch_level=0&locale=zh-CN$count=100"    // 评论URL

@implementation DJCommentNetworking

+ (void)loadSourceCommemtDataItemInfoListWithID:(NSString *)Id uid:(NSString *)uid model:(DJCommentModel *)model {
    NSString *urlString = [[[[COMMENT_URL stringByAppendingString:@"&id="] stringByAppendingString:Id] stringByAppendingString:@"&uid="] stringByAppendingString:uid];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSError *jsonError;
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (jsonError) {
                NSLog(@"JSON Error: %@", jsonError);
            } else {
                
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
                model.sourceCommentItemArray = listItemArray;
            }
        }
    }];

    [dataTask resume];
    
    
}


@end
