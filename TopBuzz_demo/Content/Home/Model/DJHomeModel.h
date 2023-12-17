//
//  DJHomeModel.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SourceDataItemInfo;
@class PictureInfo;

/// 请求类型
typedef NS_ENUM(NSUInteger, RequestType) {
    HotType                  = 0,  // 热门
    LocalType                = 1,  // 同城
    InternationType          = 2,  // 国际
    FinanceType              = 3,  // 财经
    ScienceType              = 4,  // 科普
};


#pragma mark - HomeModel_Class
@interface DJHomeModel : NSObject
@property (nonatomic, strong) NSArray<SourceDataItemInfo *> *sourceDataItemArray;       // 源数据模型数组

@end



#pragma mark - Data_Model
@interface SourceDataItemInfo : NSObject
/**博客内容*/
@property (nonatomic, strong, readonly) NSString *created_at;                       //发博时间
@property (nonatomic, strong, readonly) NSString *text;                             //微博内容
@property (nonatomic, strong, readonly) NSNumber *reposts_count;                    //转发数
@property (nonatomic, strong, readonly) NSNumber *comments_count;                   //评论数
@property (nonatomic, strong, readonly) NSNumber *attitudes_count;                  //表态数
@property (nonatomic, strong, readonly) NSString *region_name;                      //发布地址
@property (nonatomic, strong, readonly) NSString *Id;                               // 博客id
@property (nonatomic, strong, readonly) NSMutableArray <PictureInfo *> *pic_urls;   //图片数组

/**用户信息*/
@property (nonatomic, strong, readonly) NSString *screen_name;       // 用户昵称
@property (nonatomic, strong, readonly) NSString *location;          // 用户位置
@property (nonatomic, strong, readonly) NSString *profile_image_url; // 用户头像图片url
@property (nonatomic, strong, readonly) NSString *gender;            // 用户性别
@property (nonatomic, strong, readonly) NSString *uid;               // 用户uid

/// 字典转模型
/// - Parameter dictionary: 网络原数据字典
+ (SourceDataItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary;

@end


#pragma mark - PictureInfo_Model
@interface PictureInfo : NSObject
@property (nonatomic, strong, readonly) NSString *thumbnailPicString;     // 缩略图url
@property (nonatomic, strong, readonly) NSString *bmiddlePicString;       // 中尺寸图片url
@property (nonatomic, strong, readonly) NSString *largePicString;         // 中尺寸图片url
@property (nonatomic, strong, readonly) NSString *originalPicString;      // 原图url
@property (nonatomic, strong, readonly) NSNumber *width;                  // 图片宽度
@property (nonatomic, strong, readonly) NSNumber *height;                 // 图片高度
 
@end




NS_ASSUME_NONNULL_END
