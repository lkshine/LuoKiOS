//
//  LinearPartition.h
//  BalancedFlowLayout
//
//  Created by Niels de Hoog on 08-10-13.
//  Copyright (c) 2013 Niels de Hoog. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Partitions a sequence of non-negative integers into the required number of partitions.
 * Based on implementation in Python by Óscar López: http://stackoverflow.com/a/7942946
 * Example: [LinearPartition linearPartitionForSequence:@[9,2,6,3,8,5,8,1,7,3,4] numberOfPartitions:3] => @[@[9,2,6,3],@[8,5,8],@[1,7,3,4]]
 */
@interface NHLinearPartition : NSObject

#pragma mark LK:一行有几张图传入一个数组，一共有几列传入一个整数，虽然是瀑布流，但是单行同高的设计
+ (NSArray *)linearPartitionForSequence:(NSArray *)sequence numberOfPartitions:(NSInteger)numberOfPartitions;

@end
