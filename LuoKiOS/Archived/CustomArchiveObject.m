//
//  CustomArchiveObject.m
//  LuoKiOS
//
//  Created by lkshine on 16/5/28.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CustomArchiveObject.h"

@implementation CustomArchiveObject

//实现NSCoding协议中的归档方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.name   forKey:@"name"  ];
    [aCoder encodeInt   :self.age    forKey:@"age"   ];
    
}

//实现NSCoding协议中的解档方法
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.name   = [aDecoder decodeObjectForKey:@"name"  ];
        self.age    = [aDecoder decodeIntForKey   :@"age"   ];
    }
    
    return self;
}




@end
