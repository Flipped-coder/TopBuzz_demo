//
//  DJHomeModel.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SourceDataItemInfo;
typedef void(^DataListItemInfoBlock)(NSArray<SourceDataItemInfo *> *dataArray);//返回一个SourceDataItemInfo类型的数组

/// 请求类型
typedef NS_ENUM(NSUInteger, RequestType) {
    HotType                  = 0,  // 热门
    LocalType                = 1,  // 同城
    InternationType          = 2,  // 国际
    FinanceType              = 3,  // 财经
    ScienceType              = 4,  // 科普
};


@interface DJHomeModel : NSObject


/// 请求网络数据资源
/// - Parameters:
///   - finishBlock: 回调Block，返回模型数组
///   - type: 请求资源类型
///   - page: 请求页码
- (void)loadSourceDataItemInfoList:(DataListItemInfoBlock)finishBlock RequestType:(RequestType)type Page:(int)page;

@end


/// 源数据模型
@interface SourceDataItemInfo : NSObject
@property(nonatomic,copy,readwrite)NSString *created_at;        //发博时间
@property(nonatomic,copy,readwrite)NSString *text;              //微博内容
@property(nonatomic,copy,readwrite)NSString *thumbnail_pic;     //缩略图url
@property(nonatomic,copy,readwrite)NSString *bmiddle_pic;       //中尺寸图片url
@property(nonatomic,copy,readwrite)NSString *original_pic;      //原图url
@property(nonatomic,copy,readwrite)NSNumber *reposts_count;     //转发数
@property(nonatomic,copy,readwrite)NSNumber *comments_count;    //评论数
@property(nonatomic,copy,readwrite)NSNumber *attitudes_count;   //表态数
@property(nonatomic,copy,readwrite)NSArray *pic_urls;           //图片数组

/**用户信息*/
@property(nonatomic,copy,readwrite)NSString *screen_name;       //用户昵称
@property(nonatomic,copy,readwrite)NSString *location;          //用户位置
@property(nonatomic,copy,readwrite)NSString *profile_image_url; //用户头像图片url
@property(nonatomic,copy,readwrite)NSString *gender;            //用户性别


/**评论信息*/
@property(nonatomic,copy,readwrite)NSString *com_screen_name;        //用户昵称
@property(nonatomic,copy,readwrite)NSString *com_profile_image_url;  //用户头像图片url
@property(nonatomic,copy,readwrite)NSString *com_text;               //评论内容
@property(nonatomic,copy,readwrite)NSString *com_created_at;         //评论时间


/// 字典转模型
/// - Parameter dictionary: 字典原数据
+ (SourceDataItemInfo *)getSourceModelFromDictionary:(NSDictionary *)dictionary;

@end




NS_ASSUME_NONNULL_END
