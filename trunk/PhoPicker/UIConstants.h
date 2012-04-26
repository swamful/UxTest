//
//  UIConstants.h
//  PhoPicker
//
//  Created by 백 승필 on 12. 4. 12..
//  Copyright (c) 2012 NHN Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PHOTO_LIST_BY_SEARCH = 0,
    PHOTO_LIST_BY_CURRENT,        
} PhotoListType;

typedef enum {
    PHOPICKER= 10,
    NAVER,
    DAUM
} SEARCHENGINE;

#define listFrameWidth 103
#define listFrameMargin 3

#define bottomToolBarHeight 41
#define navigationTitleBarHeight 35
#define networkStatusBarHeight 20

#define kNetworkErrorAlertMessage @"네트워크 상태가 좋지않아\n현재 접속이 불가능합니다."
#define kDefaultErrorAlertMessage @"에러가 발생하여 \n현재 이용이 불가능합니다."

#define UICOLOR_DCDCDC [UIColor colorWithRed:0xdC/255.0 green:0xdc/255.0 blue:0xdc/255.0 alpha:1.0]
