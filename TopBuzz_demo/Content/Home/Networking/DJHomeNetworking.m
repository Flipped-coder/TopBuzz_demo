//
//  DJHomeNetworking.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/17.
//

#import "DJHomeNetworking.h"

// 网络资源请求 URL
#define HOT_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=0&group_id=102803&containerid=102803&extparam=discover%7Cnew_feed&max_id=0"
#define LOCAL_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028032222&containerid=102803_2222&extparam=discover%7Cnew_feed&max_id=0"
#define FINANCE_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028036388&containerid=102803_ctg1_6388_-_ctg1_6388&extparam=discover%7Cnew_feed&max_id=0"
#define INTERNATION_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028036288&containerid=102803_ctg1_6288_-_ctg1_6288&extparam=discover%7Cnew_feed&max_id=0"
#define SCIENCE_URL @"https://weibo.com/ajax/feed/hottimeline?since_id=0&refresh=1&group_id=1028035988&containerid=102803_ctg1_5988_-_ctg1_5988&extparam=discover%7Cnew_feed&max_id=0"
@implementation DJHomeNetworking

/// 请求网络资源数据
+ (void)loadSourceDataItemInfoListWithRequestType:(RequestType)type Page:(int)page model:(DJHomeModel *)model {
    // 获得当前请求的URL
    NSString *urlString = [[DJHomeNetworking new] getRequestUrlStringWithRequsetType:type page:page];
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
                model.sourceDataItemArray = listItemArray;
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
