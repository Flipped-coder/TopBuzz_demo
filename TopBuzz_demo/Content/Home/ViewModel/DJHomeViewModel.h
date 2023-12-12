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

+ (DJCollectionItemInfo *)getCollectionItemInfoFromSourceData:(SourceDataItemInfo *)sourceData;

@end



@interface DJHomeViewModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArray;

- (void)loadCollectionItemInfoDataWithType:(RequestType)type Page:(int)page;

@end

NS_ASSUME_NONNULL_END
