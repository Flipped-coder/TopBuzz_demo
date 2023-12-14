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

@interface DJCollectionItemInfo : NSObject <NSCopying>
@property (nonatomic, strong) NSNumber *cellHeight;
@property (nonatomic, strong) NSString *profileImageString;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *likeNumber;
@property (nonatomic, strong) NSNumber *imageWidth;
@property (nonatomic, strong) NSNumber *imageHeight;
@property (nonatomic, strong) NSMutableArray <PictureInfo *> *picInfos;

+ (DJCollectionItemInfo *)getCollectionItemInfoFromSourceData:(SourceDataItemInfo *)sourceData;

@end



@interface DJHomeViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArray;

- (void)loadCollectionItemInfoDataWithType:(RequestType)type Page:(int)page;

@end

NS_ASSUME_NONNULL_END
