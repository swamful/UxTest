//
//  AppUtility.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 25..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtility : NSObject {
    
}

+ (void)showIndicator:(UIView *)aview;
+ (void)hideIndicator;
+ (void)setIndicatorStyleGray;
+ (void)setIndicatorStyleWhiteLarge;
+ (void)setIndicatorStyleWhite;
@end
