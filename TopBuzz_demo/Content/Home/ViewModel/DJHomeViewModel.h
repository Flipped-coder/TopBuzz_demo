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
@property (nonatomic, strong) NSString *likeNumber;
@property (nonatomic, strong) NSNumber *imageWidth;
@property (nonatomic, strong) NSNumber *imageHeight;
@property (nonatomic, strong) NSNumber *imageCollectionFormatHeight;
@property (nonatomic, strong) NSNumber *imageBrowserFormatHeight;
@property (nonatomic, strong) NSNumber *imageFullScreenFormatHeight;
@property (nonatomic, strong) NSNumber *textCollectionFormatHeight;
@property (nonatomic, strong) NSNumber *textBrowserFormatHeight;
@property (nonatomic, strong) NSMutableAttributedString *textAttributedString;



@property (nonatomic, strong) NSMutableArray <PictureInfo *> *picInfos;

+ (DJCollectionItemInfo *)getCollectionItemInfoFromSourceData:(SourceDataItemInfo *)sourceData;

@end



@interface DJHomeViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArray;
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArrays;

- (void)loadCollectionItemInfoDataWithType:(RequestType)type Page:(int)page;

- (void)refreshCollectionItemInfoDataWith:(RequestType)type;

@end

NS_ASSUME_NONNULL_END
