//
//  DJHomeModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeModel.h"
#import <objc/runtime.h>

#define HOT_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=0&group_id=102803&containerid=102803&extparam=discover%7Cnew_feed&max_id=0"
#define LOCAL_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028032222&containerid=102803_2222&extparam=discover%7Cnew_feed&max_id=0"
#define FINANCE_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028036388&containerid=102803_ctg1_6388_-_ctg1_6388&extparam=discover%7Cnew_feed&max_id=0"
#define INTERNATION_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028036288&containerid=102803_ctg1_6288_-_ctg1_6288&extparam=discover%7Cnew_feed&max_id=0"
#define SCIENCE_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028035988&containerid=102803_ctg1_5988_-_ctg1_5988&extparam=discover%7Cnew_feed&max_id=0"


@implementation DJHomeModel

- (void)loadSourceDataItemInfoListWithRequestType:(RequestType)type Page:(int)page {
    NSString *urlString = [self getRequestUrlStringWithRequsetType:type page:page];

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
                NSMutableArray <SourceDataItemInfo *>*listItemArray = @[].mutableCopy;
                NSArray *dataArray = [responseObject objectForKey:@"statuses"];
                
                for (NSDictionary *dic in dataArray) {
                    if ([(NSNumber *)[dic objectForKey:@"pic_num"] compare:@0] != NSOrderedSame) {
                        SourceDataItemInfo *itemInfo = [SourceDataItemInfo getSourceModelFromDictionary:dic];
                        if (itemInfo) {
                            [listItemArray addObject:itemInfo];
                        }
                    }
                }
                [self willChangeValueForKey:@"sourceDataItemArray"];
                strongSelf.sourceDataItemArray = listItemArray;
                [self didChangeValueForKey:@"sourceDataItemArray"];
            }
        }
    }];

    [dataTask resume];
    

}



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




@implementation SourceDataItemInfo

+ (SourceDataItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary {
    SourceDataItemInfo *itemInfo = [[SourceDataItemInfo alloc] init];
    itemInfo.created_at = [dictionary objectForKey:@"created_at"];
    itemInfo.text = [dictionary objectForKey:@"text_raw"];
    
    
    itemInfo.pic_urls = @[].mutableCopy;
    
    NSDictionary *pictureArray = [dictionary objectForKey:@"pic_infos"];
    for (NSString *key in pictureArray) {
        NSDictionary *picDic = pictureArray[key];
        PictureInfo *info = [[PictureInfo alloc] init];
        info.thumbnailPicString = [[picDic objectForKey:@"thumbnail"] objectForKey:@"url"];
        info.bmiddlePicString = [[picDic objectForKey:@"bmiddle"] objectForKey:@"url"];
        info.largePicString = [[picDic objectForKey:@"large"] objectForKey:@"url"];
        info.originalPicString = [[picDic objectForKey:@"original"] objectForKey:@"url"];
        info.width = [[picDic objectForKey:@"thumbnail"] objectForKey:@"width"];
        info.height = [[picDic objectForKey:@"thumbnail"] objectForKey:@"height"];
        if (info.width == NULL || info.height == NULL)
            return NULL;
        [itemInfo.pic_urls addObject:info];
    }
    if (itemInfo.pic_urls.count == 0)
        return NULL;
    

    
    itemInfo.reposts_count = [dictionary objectForKey:@"reposts_count"];
    itemInfo.comments_count = [dictionary objectForKey:@"comments_count"];
    itemInfo.attitudes_count = [dictionary objectForKey:@"attitudes_count"];
    /**用户信息*/
    itemInfo.screen_name = [[dictionary objectForKey:@"user"] objectForKey:@"screen_name"];
    itemInfo.location = [[dictionary objectForKey:@"user"] objectForKey:@"location"];
    itemInfo.profile_image_url = [[dictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
    itemInfo.gender = [[dictionary objectForKey:@"user"] objectForKey:@"gender"];
    
    itemInfo.com_screen_name = [[dictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
    itemInfo.com_profile_image_url = [[dictionary objectForKey:@"user"] objectForKey:@"screen_name"];
    itemInfo.com_text = [dictionary objectForKey:@"created_at"];
    itemInfo.com_created_at = [dictionary objectForKey:@"source"];
    
    return itemInfo;
}


@end

@implementation PictureInfo

@end
