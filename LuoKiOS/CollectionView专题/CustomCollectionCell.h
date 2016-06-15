//
//  CustomCollectionCell.h
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView    * backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView    * contentImageView;
@property (weak, nonatomic) IBOutlet UILabel        * detailLabel;

@end
