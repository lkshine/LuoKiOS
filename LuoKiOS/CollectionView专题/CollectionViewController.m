//
//  CollectionViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CollectionViewController.h"
#define kSectionMargin 10



@interface CollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView * collectionView;

@end



@implementation CollectionViewController

static NSString * const reuseIdentifier       = @"Cell";
static NSString * const reuseIdentifierHeader = @"MYHeaderCell";
static NSString * const reuseIdentifierFooter = @"MYFooterCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    // AMScrollingNavbar 使用 https://github.com/andreamazz/AMScrollingNavbar/tree/v1.x
    [self setUseSuperview:NO];  //UIViewController的子类使用时要添加该段代码
    [self followScrollView:self.collectionView]; //设置控件滑动事件（有约束版和非约束版，参考git上使用教程）
//    [self.navigationController.navigationBar setTranslucent:NO]; //不允许导航栏透明
    
    // Register cell classes by code
    //    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Register cell classes by Xib
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionReusableHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionReusableFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter];
    
    self.collectionView.allowsMultipleSelection = NO;  //是否支持多选
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 5;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 9;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionCell *cell = (CustomCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.detailLabel.text = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section, (long)indexPath.row];
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

// 点击单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__func__);
    //获取点击的单元格
    CustomCollectionCell *cell = (CustomCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    
}

// 取消选中单元格
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取点击的单元格
    CustomCollectionCell *cell = (CustomCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor magentaColor];
}

#pragma mark -- cell设置(FlowLayout)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    //每行2个Cell
    CGFloat cellWidth = (screenWith - 3*kSectionMargin) * 0.5;
    return CGSizeMake(cellWidth, 170);
}


//【整体】边距设置:整体边距的优先级，始终高于内部边距的优先级
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(kSectionMargin*4, kSectionMargin, kSectionMargin*2, kSectionMargin);//分别为上、左、下、右
}


// 每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return kSectionMargin;
}


// 每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return kSectionMargin*4;
}
/* item之间的间距与sizeForItemAtIndexPath里是相互掣肘的，必须同时满足约束才能正常，但是insetForSctionAtInddexPath的优先级都要高的 */


#pragma mark -- 补充视图（HeaderFooter）
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *supplementaryView;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        CollectionReusableHeaderView *view = (CollectionReusableHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        view.headerLabel.text = [NSString stringWithFormat:@"这是header:%ld",indexPath.section];
        supplementaryView = view;
        
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        CollectionReusableFooterView *view = (CollectionReusableFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseIdentifierFooter forIndexPath:indexPath];
        view.footerLabel.text = [NSString stringWithFormat:@"这是Footer:%ld",(long)indexPath.section];
        supplementaryView = view;
        
    }
    
    return supplementaryView;
}

// 设置Header与Footer的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 69);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth, 50);
}

@end





