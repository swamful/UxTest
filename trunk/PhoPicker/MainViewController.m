//
//  MainViewController.m
//  PhoPicker
//
//  Created by 승필 백 on 12. 4. 17..
//  Copyright 2012 NHN Corp. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoListViewController.h"
#import "ToolBarView.h"
#import "TitleView.h"

@interface MainViewController() 
- (void) makeToolBar;
- (void) makeTitleView;
- (void) makeSearchView;
@end
@implementation MainViewController

- (void)dealloc
{
    [_searchView release];
    [_categoryList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    searchEngine = PHOPICKER;
    _mainListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationTitleBarHeight, self.view.frame.size.width, self.view.frame.size.height - bottomToolBarHeight - navigationTitleBarHeight - networkStatusBarHeight) style:UITableViewStylePlain];
    _mainListTableView.delegate = self;
    _mainListTableView.dataSource = self;
    
    [self.view addSubview:_mainListTableView];
    [_mainListTableView release];
    
    _categoryList = [[NSMutableArray alloc] initWithObjects:@"최근 올라온 사진", nil];
    
    [self makeSearchView];
    [self makeToolBar];
    [self makeTitleView];

}

- (void) makeSearchView {
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.delegate = self;
    [_searchView addSubview:_searchBar];
    [_searchBar release];
    
    _buttonListView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 30)];
    _buttonListView.backgroundColor = [UIColor darkGrayColor];
    [_searchView addSubview:_buttonListView];
    [_buttonListView release];
    _buttonListView.hidden = YES;
    
    UIButton *phoPickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoPickerBtn.frame = CGRectMake(0, 0, 108, 30);
    [phoPickerBtn setTitle:@"phoPicker" forState:UIControlStateNormal];
    [phoPickerBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [phoPickerBtn setBackgroundImage:[UIImage imageNamed:@"tab_off.png"] forState:UIControlStateNormal];
    [phoPickerBtn setBackgroundImage:[UIImage imageNamed:@"tab_on.png"] forState:UIControlStateSelected];
    [phoPickerBtn addTarget:self action:@selector(setSearchEngine:) forControlEvents:UIControlEventTouchUpInside];

    phoPickerBtn.tag = PHOPICKER;
    [_buttonListView addSubview:phoPickerBtn];
    
    UIButton *naverSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    naverSearchBtn.frame = CGRectMake(109, 0, 108, 30);
    [naverSearchBtn setTitle:@"NAVER" forState:UIControlStateNormal];
    [naverSearchBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [naverSearchBtn addTarget:self action:@selector(setSearchEngine:) forControlEvents:UIControlEventTouchUpInside];
    [naverSearchBtn setBackgroundImage:[UIImage imageNamed:@"tab_off.png"] forState:UIControlStateNormal];
    [naverSearchBtn setBackgroundImage:[UIImage imageNamed:@"tab_on.png"] forState:UIControlStateSelected];
    naverSearchBtn.tag = NAVER;
    [_buttonListView addSubview:naverSearchBtn];

    UIButton *daumSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    daumSearchBtn.frame = CGRectMake(218, 0, 108, 30);
    [daumSearchBtn setTitle:@"daum" forState:UIControlStateNormal];
    [daumSearchBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [daumSearchBtn addTarget:self action:@selector(setSearchEngine:) forControlEvents:UIControlEventTouchUpInside];
    [daumSearchBtn setBackgroundImage:[UIImage imageNamed:@"tab_off.png"] forState:UIControlStateNormal];
    [daumSearchBtn setBackgroundImage:[UIImage imageNamed:@"tab_on.png"] forState:UIControlStateSelected];
    daumSearchBtn.tag = DAUM;
    [_buttonListView addSubview:daumSearchBtn];
    
    UIView *view = (UIButton *) [_buttonListView viewWithTag:searchEngine];
    [(UIButton *)view setSelected:YES];
}

- (void) setSearchEngine:(id) control {
    UIView *view = (UIButton *) [_buttonListView viewWithTag:searchEngine];
    [(UIButton *)view setSelected:NO];
    searchEngine = [control tag];
    [(UIButton *)control setSelected:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    if ([[_searchBar text] length] == 0) {
        [_mainListTableView setContentInset:UIEdgeInsetsMake(-40, 0, 0, 0)];    
    } else {
        [_searchBar setShowsCancelButton:NO];
    }
}
- (void) makeTitleView {
    self.navigationController.navigationBarHidden = YES;
    TitleView *titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navigationTitleBarHeight)];
    [titleView setTitle:@"Pho Picker"];
    [self.view addSubview:titleView];
    [titleView release];
}

- (void) makeToolBar {
    ToolBarView *toolbar = [[ToolBarView alloc] initWithFrame:CGRectMake(0, _mainListTableView.frame.size.height + navigationTitleBarHeight, self.view.frame.size.width, bottomToolBarHeight)];
    toolbar.backgroundColor = [UIColor redColor];
    [self.view addSubview:toolbar];
    [toolbar release];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
     _buttonListView.hidden = NO;
    
    UITableViewCell *cell = [_mainListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGRect frame = cell.frame;
    frame.size.height = 70;
    cell.frame = frame;
    
    NSArray *list = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_mainListTableView reloadRowsAtIndexPaths:list withRowAnimation:UITableViewRowAnimationNone];
    
    [_searchBar setShowsCancelButton:YES animated:YES];
    for (UIView *subView in _searchBar.subviews) {
        if ([subView isKindOfClass:UIButton.class]) {
            [(UIButton*)subView setTitle:@"검색" forState:UIControlStateNormal];
            [[(UIButton*)subView titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
        }
    }
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
   
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    if ([searchBar.text length] == 0) {
        return;
    }
    PhotoListViewController *plvController = [[PhotoListViewController alloc] initWithType:PHOTO_LIST_BY_SEARCH];
    plvController.searchText = searchBar.text;
    plvController.searchEngine = searchEngine;
    [self.navigationController pushViewController:plvController animated:YES];
    [plvController release];
}

- (void) viewWillDisappear:(BOOL)animated {
    [_searchBar resignFirstResponder];
}

- (void) viewDidDisappear:(BOOL)animated {
    _buttonListView.hidden = YES;
    UITableViewCell *cell = [_mainListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGRect frame = cell.frame;
    frame.size.height = 40;
    cell.frame = frame;
    NSArray *list = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_mainListTableView reloadRowsAtIndexPaths:list withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.view = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_categoryList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.row == 0) {
        [cell addSubview:_searchView];
    } else {
        cell.textLabel.text = [_categoryList objectAtIndex:(indexPath.row - 1)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && _buttonListView.hidden == NO) {
        return 70;
    }
    return 40;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_mainListTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];    
}

#pragma ToolBarView action
- (void) takePicture {
    CameraContextMenuView *camContextMenu = [[CameraContextMenuView alloc] init];
    camContextMenu.delegate = self;
    [camContextMenu show];
    [camContextMenu release];
}


#pragma UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoListViewController *plvController = [[PhotoListViewController alloc] initWithType:indexPath.row];
    if (indexPath.row == 0) {
        plvController.searchText = _searchBar.text;
    }
    [self.navigationController pushViewController:plvController animated:YES];
    [plvController release];
}


@end
