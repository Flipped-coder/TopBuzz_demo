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

/// 请求网络资源数据
/// - Parameters:
///   - type: 资讯类型
///   - page: 请求范围
- (void)loadSourceDataItemInfoListWithRequestType:(RequestType)type Page:(int)page;

@end



#pragma mark - Data_Model
@interface SourceDataItemInfo : NSObject
/**博客内容*/
@property (nonatomic, strong) NSString *created_at;                       //发博时间
@property (nonatomic, strong) NSString *text;                             //微博内容
@property (nonatomic, strong) NSNumber *reposts_count;                    //转发数
@property (nonatomic, strong) NSNumber *comments_count;                   //评论数
@property (nonatomic, strong) NSNumber *attitudes_count;                  //表态数
@property (nonatomic, strong) NSString *region_name;                      //发布地址
@property (nonatomic, strong) NSString *Id;                               // 博客id
@property (nonatomic, strong) NSMutableArray <PictureInfo *> *pic_urls;   //图片数组

/**用户信息*/
@property (nonatomic, strong) NSString *screen_name;       // 用户昵称
@property (nonatomic, strong) NSString *location;          // 用户位置
@property (nonatomic, strong) NSString *profile_image_url; // 用户头像图片url
@property (nonatomic, strong) NSString *gender;            // 用户性别
@property (nonatomic, strong) NSString *uid;               // 用户uid

/// 字典转模型
/// - Parameter dictionary: 网络原数据字典
+ (SourceDataItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary;

@end


#pragma mark - PictureInfo_Model
@interface PictureInfo : NSObject
@property (nonatomic, strong) NSString *thumbnailPicString;     // 缩略图url
@property (nonatomic, strong) NSString *bmiddlePicString;       // 中尺寸图片url
@property (nonatomic, strong) NSString *largePicString;         // 中尺寸图片url
@property (nonatomic, strong) NSString *originalPicString;      // 原图url
@property (nonatomic, strong) NSNumber *width;                  // 图片宽度
@property (nonatomic, strong) NSNumber *height;                 // 图片高度
 
@end




NS_ASSUME_NONNULL_END
