//
//  DJHomeViewModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeViewModel.h"

@interface DJHomeViewModel ()
@property (nonatomic, strong) DJHomeModel *model;

@end


@implementation DJHomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        DJHomeModel *model = [[DJHomeModel alloc] init];
        [self bindModel:model];
    }
    return self;
}


- (void)loadCollectionItemInfoDataWithType:(RequestType)type Page:(int)page {
    [self.model loadSourceDataItemInfoListWithRequestType:type Page:page];
}




- (void)bindModel:(DJHomeModel *)model {
    self.model = model;
    [model addObserver:self forKeyPath:@"sourceDataItemArray" options:NSKeyValueObservingOptionNew context:nil];
}

// 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sourceDataItemArray"]) {
        // 处理属性变化
        NSArray *sourceDataArray = change[NSKeyValueChangeNewKey];
        NSMutableArray <DJCollectionItemInfo *>*listItemArray = @[].mutableCopy;
        
        for (SourceDataItemInfo *info in sourceDataArray) {
            DJCollectionItemInfo *itemInfo = [DJCollectionItemInfo getCollectionItemInfoFromSourceData:info];
            [listItemArray addObject:itemInfo];
        }
        _collectionItemInfoArray = listItemArray.copy;
        
        [self willChangeValueForKey:@"collectionItemInfoArray"];
        // 手动设置新值
        [self didChangeValueForKey:@"collectionItemInfoArray"];
        
        NSLog(@"");
    }
}


- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@"sourceDataItemArray"];
}

@end




typedef NS_ENUM(NSUInteger, ImageType) {
    ThumbnailType              = 0,  // 缩略图
    BmiddleType                = 1,  // 中尺寸图
    OriginalType               = 2,  // 原图
    ProfileType                = 3,  // 头像
};

@interface DJCollectionItemInfo ()
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) UIImage *bmiddleImage;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) UILabel *likeNumber;
@property (nonatomic, strong) NSNumber *imageWidth;
@property (nonatomic, strong) NSNumber *imageHeight;


@end

@implementation DJCollectionItemInfo

+ (DJCollectionItemInfo *)getCollectionItemInfoFromSourceData:(SourceDataItemInfo *)sourceData{
    DJCollectionItemInfo *itemInfo = [[DJCollectionItemInfo alloc] init];
    [itemInfo loadImageDataWithUrlString:sourceData.profile_image_url imageType:ProfileType];
    [itemInfo loadImageDataWithUrlString:sourceData.thumbnail_pic.urlString imageType:ThumbnailType];
    itemInfo.imageWidth = sourceData.thumbnail_pic.width;
    itemInfo.imageHeight = sourceData.thumbnail_pic.height;
    dispatch_async(dispatch_get_main_queue(), ^{
        itemInfo.text = [[UILabel alloc] init];
        itemInfo.username = [[UILabel alloc] init];
        itemInfo.likeNumber = [[UILabel alloc] init];
        itemInfo.text.text = sourceData.text;
        itemInfo.username.text = sourceData.screen_name;
        itemInfo.likeNumber.text = [sourceData.attitudes_count stringValue];
    });
    
    return itemInfo;
}

- (void)loadImageDataWithUrlString:(NSString *)urlString imageType:(ImageType)type{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"https://weibo.com/" forHTTPHeaderField:@"Referer"];
    [request setHTTPMethod:@"GET"];
    // 创建NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建NSURLSessionDataTask对象
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            // 处理响应数据
            switch (type) {
                case ThumbnailType:
                    self.thumbnailImage = [UIImage imageWithData:data];
                case ProfileType:
                    self.profileImage = [UIImage imageWithData:data];
                case BmiddleType:
                    self.bmiddleImage = [UIImage imageWithData:data];
                case OriginalType:
                    self.originalImage = [UIImage imageWithData:data];
            }
        }
    }];
    // 启动任务
    [dataTask resume];
}


@end


//NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://tvax2.sinaimg.cn/crop.0.0.1080.1080.50/005YEhFZly8hhmc4ltc3kj30u00u040c.jpg?KID=imgbed,tva&Expires=1702398663&ssig=B0hxGnLh%2F4"]];
//[request setValue:@"https://weibo.com/" forHTTPHeaderField:@"Referer"];
//[request setHTTPMethod:@"GET"];
//// 创建NSURLSession对象
//NSURLSession *session = [NSURLSession sharedSession];
//
//// 创建NSURLSessionDataTask对象
//NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//    if (error) {
//        NSLog(@"Error: %@", error);
//    } else {
//        // 处理响应数据
//        UIImage *image = [UIImage imageWithData:data];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageView.image = image;
//        });
//
//    }
//}];
//
//// 启动任务
//[dataTask resume];
