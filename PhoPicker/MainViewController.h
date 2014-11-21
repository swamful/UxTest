//
//  MainViewController.h
//  PhoPicker
//
//  Created by 승필 백 on 12. 4. 17..
//

#import <UIKit/UIKit.h>
#import "CameraContextMenuView.h"
#import "UIConstants.h"
@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CameraContextMenuViewDelegate> {
    UITableView *_mainListTableView;
    NSMutableArray *_categoryList;

    
    UIView *_searchView;
    UIView *_buttonListView;
    UISearchBar *_searchBar;
    
    SEARCHENGINE searchEngine;
}

@end
