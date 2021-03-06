//
//  ViewController.m
//  BalancedFlowLayoutDemo
//
//  Created by Niels de Hoog on 08-10-13.
//  Copyright (c) 2013 Niels de Hoog. All rights reserved.
//

#import "NHBalancedVC.h"
#import "ImageCell.h"
#import "NHLinearPartition.h"
#import "UIImage+Decompression.h"
#import "NHBalancedFlowLayout.h"

#define NUMBER_OF_IMAGES 24

#define HEADER_SIZE 100.0f
#define FOOTER_SIZE 100.0f


static NSString * const reuseIdentifier = @"ImageCell";

@interface NHBalancedVC () <NHBalancedFlowLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NHBalancedFlowLayout *layout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray *images;

@end

@implementation NHBalancedVC

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.layout];
//        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //        [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [_collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

- (NHBalancedFlowLayout *)layout {
    if (!_layout) {
        _layout = [[NHBalancedFlowLayout alloc] init];
        _layout.headerReferenceSize = CGSizeMake(HEADER_SIZE, HEADER_SIZE);
        _layout.footerReferenceSize = CGSizeMake(FOOTER_SIZE, FOOTER_SIZE);
    }
    return _layout;
}

- (NSArray *)images {
    
    if (!_images) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        //        for (int i = 1; i <= NUMBER_OF_IMAGES; i++) {
        for (int i = 1; i <= 17; i++) {
            NSString *imageName = [NSString stringWithFormat:@"star%02d.jpg", i];
            [images addObject:[UIImage imageNamed:imageName]];//photo-%02d.jpg
        }
        _images = [images copy];
    }
    return _images;
}

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        
//        NSMutableArray *images = [[NSMutableArray alloc] init];
//        //        for (int i = 1; i <= NUMBER_OF_IMAGES; i++) {
//        for (int i = 1; i <= 17; i++) {
//            NSString *imageName = [NSString stringWithFormat:@"star%02d.jpg", i];
//            [images addObject:[UIImage imageNamed:imageName]];//photo-%02d.jpg
//        }
//        _images = [images copy];
//    }
//    NSLog(@"lk ======= count = %ld", _images.count);
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layout];
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [self.images objectAtIndex:indexPath.item];
    return [image size];
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = nil;
    
    /**
     * Decompress image on background thread before displaying it to prevent lag
     */
    NSInteger rowIndex = indexPath.row;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage decodedImageWithImage:[self.images objectAtIndex:indexPath.item]];//根据之前类里定义的规则过滤不符合规则的图片
        //        UIImage *image = [self.images objectAtIndex:indexPath.item];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:cell];
            if (currentIndexPathForCell.row == rowIndex) {
                cell.imageView.image = image;
            }
        });
    });
    
    return cell;
}



@end
