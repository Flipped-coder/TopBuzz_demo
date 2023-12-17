//
//  DJHomeViewModel.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <Foundation/Foundation.h>
#import "DJHomeModel.h"

@class DJCollectionItemInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ViewModel
@interface DJHomeViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArray;        // 单次更新的View数据数组
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArrays;       // 整个View的数据列表
/// 加载View所需的模型数据
/// - Parameters:
///   - type: 请求资源类型
///   - page: 请求范围
- (void)loadCollectionItemInfoDataWithType:(RequestType)type Page:(int)page;
/// 刷新请求页（默认请求最新的第一页）
/// - Parameter type: 请求类型
- (void)refreshCollectionItemInfoDataWith:(RequestType)type;

@end


#pragma mark - ViewItemInfo
/**每次视图展示所需的数据模型**/
@interface DJCollectionItemInfo : NSObject
/**博客内容**/
@property (nonatomic, strong, readonly) NSString *text;         // 内容文字
@property (nonatomic, strong, readonly) NSString *created_at;   // 发布时间
@property (nonatomic, strong, readonly) NSString *region_name;  // 发布位置
@property (nonatomic, strong, readonly) NSString *repostCount;  // 转发数
@property (nonatomic, strong, readonly) NSString *commentCount; // 评论数
@property (nonatomic, strong, readonly) NSString *likeCount;    // 点赞数
@property (nonatomic, strong, readonly) NSString *Id;           // 博客id
@property (nonatomic, strong, readonly) NSMutableArray <PictureInfo *> *picInfos; // 图片信息数组
/**user 信息**/
@property (nonatomic, strong, readonly) NSString *username;           // 用户名
@property (nonatomic, strong, readonly) NSString *profileImageString; // 头像url
@property (nonatomic, strong, readonly) NSString *uid;                // 用户uid
/**视图尺寸信息**/
@property (nonatomic, strong, readonly) NSNumber *imageWidth;   // 图片原宽度
@property (nonatomic, strong, readonly) NSNumber *imageHeight;  // 图片原高度
@property (nonatomic, strong, readonly) NSNumber *imageCollectionFormatHeight;   // 图片自适应主页高度
@property (nonatomic, strong, readonly) NSNumber *imageBrowserFormatHeight;      // 图片浏览器高度
@property (nonatomic, strong, readonly) NSNumber *imageFullScreenFormatHeight;   // 图片全屏浏览高度
@property (nonatomic, strong, readonly) NSNumber *textCollectionFormatHeight;    // 文字自适应后高度
@property (nonatomic, strong, readonly) NSNumber *textBrowserFormatHeight;       // 文字详情页自适应高度
@property (nonatomic, strong, readonly) NSMutableAttributedString *textAttributedString;  // 富文本字符属性
@property (nonatomic, strong, readonly) NSNumber *cellHeight;   // 视图所需总高度

/// 将原数据模型转为View模型
/// - Parameter sourceData: 原数据模型
+ (DJCollectionItemInfo *)getCollectionItemInfoFromSourceData:(SourceDataItemInfo *)sourceData;

@end

NS_ASSUME_NONNULL_END
