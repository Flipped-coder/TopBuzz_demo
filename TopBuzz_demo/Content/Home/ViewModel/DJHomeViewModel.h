//
//  DJHomeViewModel.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DJHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJCollectionItemInfo : NSObject
@property (nonatomic, strong) NSNumber *cellHeight;
@property (nonatomic, strong) NSString *profileImageString;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *region_name;
@property (nonatomic, strong) NSNumber *imageWidth;
@property (nonatomic, strong) NSNumber *imageHeight;
@property (nonatomic, strong) NSNumber *imageCollectionFormatHeight;
@property (nonatomic, strong) NSNumber *imageBrowserFormatHeight;
@property (nonatomic, strong) NSNumber *imageFullScreenFormatHeight;
@property (nonatomic, strong) NSNumber *textCollectionFormatHeight;
@property (nonatomic, strong) NSNumber *textBrowserFormatHeight;
@property (nonatomic, strong) NSMutableAttributedString *textAttributedString;

@property (nonatomic, strong) NSString *repostCount;
@property (nonatomic, strong) NSString *commentCount;
@property (nonatomic, strong) NSString *likeCount;

@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) NSMutableArray <PictureInfo *> *picInfos;

+ (DJCollectionItemInfo *)getCollectionItemInfoFromSourceData:(SourceDataItemInfo *)sourceData;

+ (NSString *)dateFormatter:(NSString * )sourceDate;

@end

@interface DJCommentItemInfo : NSObject
@property (nonatomic, strong) NSString *com_created_at;        //评论时间
@property (nonatomic, strong) NSString *com_text;              //评论内容
@property (nonatomic, strong) NSString *com_screen_name;       //用户昵称
@property (nonatomic, strong) NSString *com_location;          //用户位置
@property (nonatomic, strong) NSString *com_profile_image_url; //用户头像图片url
@property (nonatomic, strong) NSNumber *text_height;
@property (nonatomic, strong) NSNumber *cell_height;

+ (DJCommentItemInfo *)getCommentItemFromSourceData:(SourceCommentItemInfo *)sourceData;

@end



@interface DJHomeViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArray;
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArrays;
@property (nonatomic, strong) NSMutableArray <DJCommentItemInfo *> * commentItemInfoArray;

- (void)loadCollectionItemInfoDataWithType:(RequestType)type Page:(int)page;

- (void)refreshCollectionItemInfoDataWith:(RequestType)type;

- (void)loadCommentDataWithID:(NSString *)Id uid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
