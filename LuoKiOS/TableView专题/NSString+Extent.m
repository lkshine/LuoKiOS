//
//  NSString+Extent.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NSString+Extent.h"

@implementation NSString (Extent)

-(CGFloat) heightWithText:(NSString *) text font:(UIFont *) font width:(CGFloat) width{
    NSDictionary * attributes = @{NSFontAttributeName : font};
    
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                            options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil].size;
    
    return contentSize.height ;
}


@end
