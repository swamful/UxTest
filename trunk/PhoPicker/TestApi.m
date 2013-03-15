//
//  TestApi.m
//  NaverSearch
//
//  Created by 백 승필 on 12. 8. 9..
//  Copyright (c) 2012 NHN. All rights reserved.
//

#import "TestApi.h"

@implementation TestApi

- (NSDictionary*) getData {
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
//    dispatch_queue_t dqueue = dispatch_queue_create("imageDown", NULL);
    for (int i =0; i <12; i++) {
//        dispatch_async(dqueue, ^{
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpeg", i]];

                [dictonary setObject:image forKey:[NSString stringWithFormat:@"%d", i]];
//            });
            
//        }); 
    }
//    dispatch_release(dqueue);
    return dictonary;
}

@end
