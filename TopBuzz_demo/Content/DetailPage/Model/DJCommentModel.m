//
//  DJCommentModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCommentModel.h"
#define COMMENT_URL @"https://weibo.com/ajax/statuses/buildComments?is_reload=1&is_show_bulletin=2&is_mix=0&count=20&type=feed&fetch_level=0&locale=zh-CN$count=100"

@implementation DJCommentModel

- (void)loadSourceCommemtDataItemInfoListWithID:(NSString *)Id uid:(NSString *)uid {
    NSString *urlString = [[[[COMMENT_URL stringByAppendingString:@"&id="] stringByAppendingString:Id] stringByAppendingString:@"&uid="] stringByAppendingString:uid];

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf; // 重新强引用，避免在 Block 执行期间被释放

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
                if (dataArray.count == 0)
                    return;
                for (NSDictionary *dic in dataArray) {
                    SourceCommentItemInfo *itemInfo = [SourceCommentItemInfo getSourceModelFromDictionary:dic];
                    if (itemInfo) {
                        [listItemArray addObject:itemInfo];
                    }
                }
                strongSelf.sourceCommentItemArray = listItemArray;
            }
        }
    }];

    [dataTask resume];
}

@end


@implementation SourceCommentItemInfo

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
