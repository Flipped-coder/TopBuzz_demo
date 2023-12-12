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

@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) UILabel *text;
@property (nonatomic, strong, readonly) UILabel *username;
@property (nonatomic, strong, readonly) UIImage *profileImage;
@property (nonatomic, strong, readonly) UILabel *likeNumber;

@end



@interface DJHomeViewModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray <DJCollectionItemInfo *> * collectionItemInfoArray;


- (void)bindModel:(DJHomeModel *)model;

@end

NS_ASSUME_NONNULL_END
