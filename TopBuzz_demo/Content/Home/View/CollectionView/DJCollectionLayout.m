//
//  DJCollectionLayout.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJCollectionLayout.h"
#import "DJScreen.h"
#import "DJHomeViewModel.h"


@implementation DJCollectionLayout {
    CGFloat colHight[2];
    CGFloat lastCell_Y;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _attributeAttay = @[].mutableCopy;

        //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
        colHight[0] = self.sectionInset.top;
        colHight[1] = self.sectionInset.bottom;
    }
    return self;
}

//数组的相关设置在这个方法中
//布局前的准备会调用这个方法
- (void)prepareLayout{
    [super prepareLayout];
}


- (void)appendCollectionItemInfoArray:(NSArray <DJCollectionItemInfo *> *)array {
    //计算每一个item的宽度
    float WIDTH = (SCREEN_WIDTH - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing)/2;
    //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
    int baseCount = (int)_attributeAttay.count;
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = baseCount; i < array.count + baseCount; i++) {
        //设置每个item的位置等相关属性
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        //创建一个布局属性类，通过indexPath来创建
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        //高度
        CGFloat hight = [array[i - baseCount].cellHeight floatValue];
        
        //哪一列高度小 则放到那一列下面
        //标记最短的列
        int width = 0;
        if (colHight[0] <= colHight[1]) {
            //将新的item高度加入到短的一列
            colHight[0] = colHight[0] + hight + self.minimumLineSpacing;
            width = 0;
        }else{
            colHight[1] = colHight[1] + hight + self.minimumLineSpacing;
            width = 1;
        }
        
        //设置item的位置
        attris.frame = CGRectMake(self.sectionInset.left + (self.minimumInteritemSpacing + WIDTH) * width, colHight[width] - hight - self.minimumLineSpacing, WIDTH, hight);
        [arr addObject:attris];
        
        lastCell_Y = MAX(colHight[0], colHight[1]);
    }
    [_attributeAttay addObjectsFromArray:arr];
    NSLog(@"_attributeAttay addObjects  Count = %lu ", (unsigned long)_attributeAttay.count);

    //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
    if (colHight[0] > colHight[1]) {
        self.itemSize = CGSizeMake(WIDTH, (colHight[0] - self.sectionInset.top) * 2 / _attributeAttay.count - self.minimumLineSpacing);
    }else{
          self.itemSize = CGSizeMake(WIDTH, (colHight[1] - self.sectionInset.top) * 2 / _attributeAttay.count - self.minimumLineSpacing);
    }
}

- (void)refreshCollectionLayout {
    [_attributeAttay removeAllObjects];
    colHight[0] = self.sectionInset.top;
    colHight[1] = self.sectionInset.bottom;
    NSLog(@"");
}



//这个方法中返回我们的布局数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeAttay.copy;
}


@end
