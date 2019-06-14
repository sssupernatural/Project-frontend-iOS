//
//  MeEditLocationsController.m
//  Tree
//
//  Created by 施威特 on 2018/6/11.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import "MeEditLocationsController.h"

@interface MeEditLocationsController ()

@end

@implementation MeEditLocationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationItem.hidesBackButton = YES;
    
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    /*
    if (_appDelegate.AppUserInfo.Locations != nil && _appDelegate.AppUserInfo.Locations.count > 0)
    {
        _locStrSema = dispatch_semaphore_create(0);
    }
    
    [self GetMyLocationsString];
    
    if (_appDelegate.AppUserInfo.Locations != nil && _appDelegate.AppUserInfo.Locations.count > 0)
    {
        dispatch_semaphore_wait(_locStrSema, DISPATCH_TIME_FOREVER);
    }
     */
    
    [self initMyLocList];
    
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = NO;
    _mapView.zoomLevel = 18;
    _mapView.userTrackingMode = BMKUserTrackingModeHeading;
    _anno = [[BMKPointAnnotation alloc] init];
    
    //城市输入框,默认为定位城市，可手动输入
    _searchCity = [[UITextField alloc] initWithFrame:CGRectMake(7, 39, 60, 36)];
    _searchCity.backgroundColor = [UIColor whiteColor];
    _searchCity.layer.masksToBounds = YES;
    _searchCity.layer.cornerRadius = 4;
    _searchCity.textAlignment = NSTextAlignmentCenter;
    _searchCity.font = [UIFont boldSystemFontOfSize:14];
    _searchCity.textColor = [UIColor blackColor];
    [_searchCity.layer setBorderColor:[UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1].CGColor];
    [_searchCity.layer setBorderWidth:1];
    _citySetFlag = FALSE;
    _curLocSetFlag = FALSE;
    
    //地址搜索框
    _searchLocation = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 20, 300, 56)];
    _searchLocation.barStyle = UIBarStyleDefault;
    _searchLocation.placeholder = @"搜索常用位置";
    _searchLocation.tintColor = [UIColor colorWithRed:34.0f/255.0f green:139.0f/255.0f blue:34.0f/255.0f alpha:1];
    _searchLocation.searchBarStyle = UISearchBarStyleDefault;
    _searchLocation.searchFieldBackgroundPositionAdjustment = UIOffsetMake(0, 9);
    UITextField * searchField = [_searchLocation valueForKey:@"_searchField"];
    [searchField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _searchLocation.delegate = self;
    [self removeSearchBackground];
    
    //地址搜索建议控制器
    _locSuggVC = [[MeLocationListController alloc] init];
    _locSuggVC.delegate = self;
    [self setLocSearchSuggestionHidden:YES];
    
    //常用地址编辑控制器
    _showMyLocListVC = [[MeShowMyLocationsController alloc] init];
    _showMyLocListVC.delegate = self;
    [self initShowMyLocList];
    
    //确认按钮
    self.Btn_ConfirmMyLocs.backgroundColor = [UIColor whiteColor];
    [self.Btn_ConfirmMyLocs.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_ConfirmMyLocs.layer setBorderWidth:1];
    [self.Btn_ConfirmMyLocs.layer setMasksToBounds:YES];
    [self.Btn_ConfirmMyLocs addTarget:self action:@selector(confirmMyLocations) forControlEvents:UIControlEventTouchUpInside];
    
    self.Btn_AddMyLoc.backgroundColor = [UIColor whiteColor];
    [self.Btn_AddMyLoc.layer setBorderColor:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor];
    [self.Btn_AddMyLoc.layer setBorderWidth:1];
    [self.Btn_AddMyLoc.layer setMasksToBounds:YES];
    [self.Btn_AddMyLoc addTarget:self action:@selector(addMyLocation) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    _searchSuggestion = [[BMKSuggestionSearch alloc] init];
    _searchSuggestion.delegate = self;
    
    
    [self.view addSubview:_mapView];
    
    [self.view addSubview:_searchLocation];
    [self.view addSubview:_searchCity];
    [self.view addSubview:_Btn_ConfirmMyLocs];
    [self.view addSubview:_Btn_AddMyLoc];
    [self.view addSubview:_locSuggVC.view];
    [self.view addSubview:_showMyLocListVC.view];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initShowMyLocList
{
    _showMyLocListVC.keyList = [[NSMutableArray alloc] init];
    _showMyLocListVC.districtList = [[NSMutableArray alloc] init];
    _showMyLocListVC.cityList = [[NSMutableArray alloc] init];

    if (_appDelegate.AppUserInfo.LocationStrs != nil && _appDelegate.AppUserInfo.LocationStrs.count != 0)
    {
        for (int i = 0; i < _appDelegate.AppUserInfo.LocationStrs.count; i++)
        {
            NSString* tmpString = [NSString stringWithString:(NSString*)[_appDelegate.AppUserInfo.LocationStrs objectAtIndex:i]];
            NSArray* sperate = [tmpString componentsSeparatedByString:@"·"];
            
            [_showMyLocListVC.cityList insertObject:(NSString*)[sperate objectAtIndex:0] atIndex:i];
            [_showMyLocListVC.districtList insertObject:(NSString*)[sperate objectAtIndex:1] atIndex:i];
            [_showMyLocListVC.keyList insertObject:(NSString*)[sperate objectAtIndex:2] atIndex:i];
        }
        
        _showMyLocListVC.locNumber = _appDelegate.AppUserInfo.LocationStrs.count;
        
        _showMyLocListVC.ptList = [NSMutableArray arrayWithArray:_appDelegate.AppUserInfo.Locations];
        
        _showMyLocListVC.showFlag = TRUE;
        
        [self performSelectorOnMainThread:@selector(reloadShowMyLocsList) withObject:nil waitUntilDone:nil];
        
        [self setShowMyLocListHidden:NO];
    } else
    {
        _showMyLocListVC.ptList = [[NSMutableArray alloc] init];
        [self setShowMyLocListHidden:YES];
    }
}

/*
-(void)GetMyLocationsString
{
    NSLog(@"GET MY LOC STRS! COUNT : %ld", _appDelegate.AppUserInfo.Locations.count);
    if (_appDelegate.AppUserInfo.Locations != nil && _appDelegate.AppUserInfo.Locations.count != 0)
    {
        _locationsStringArray = [[NSMutableArray alloc] init];
        _locationsPTarray = [[NSMutableArray alloc] init];
        
         _locationStrsSearch = [[BMKGeoCodeSearch alloc]init];
         _locationStrsSearch.delegate = self;
        
        CLLocationCoordinate2D locPt;
        
        for (int i = 0; i < _appDelegate.AppUserInfo.Locations.count; i++)
        {
            Location* tmpLoc = (Location*)[_appDelegate.AppUserInfo.Locations objectAtIndex:i];
            locPt = (CLLocationCoordinate2D){tmpLoc.Latitude.doubleValue, tmpLoc.Longitude.doubleValue};
            BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
            reverseGeoCodeSearchOption.reverseGeoPoint = locPt;
            BOOL flag = [_locationStrsSearch reverseGeoCode:reverseGeoCodeSearchOption];
            if(!flag)
            {
                NSLog(@"反geo检索发送失败");
            } else
            {
            }
        }
    }
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"STR BACK");
        [_locationsStringArray addObject:[NSString stringWithFormat:@"%@·%@·%@", result.addressDetail.city, result.addressDetail.district, result.address]];
        [_locationsPTarray addObject:[Location LocationWithCLLocationCoordinate2D:result.location]];
        
        if (_appDelegate.AppUserInfo.Locations != nil && _appDelegate.AppUserInfo.Locations.count > 0)
        {
            dispatch_semaphore_signal(_locStrSema);
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
 */

-(void)initMyLocList
{
    _locKeyArray = [[NSMutableArray alloc] init];
    _locDistrictArray = [[NSMutableArray alloc] init];
    _locCityArray = [[NSMutableArray alloc] init];
    _locPTArray = [[NSMutableArray alloc] init];
    
    if (_appDelegate.AppUserInfo.LocationStrs != nil && _appDelegate.AppUserInfo.LocationStrs.count != 0)
    {
        for (int i = 0; i < _appDelegate.AppUserInfo.LocationStrs.count; i++)
        {
            NSString* tmpString = [NSString stringWithString:(NSString*)[_appDelegate.AppUserInfo.LocationStrs objectAtIndex:i]];
            NSArray* sperate = [tmpString componentsSeparatedByString:@"·"];
            [_locCityArray insertObject:(NSString*)[sperate objectAtIndex:0] atIndex:i];
            [_locDistrictArray insertObject:(NSString*)[sperate objectAtIndex:1] atIndex:i];
            [_locKeyArray insertObject:(NSString*)[sperate objectAtIndex:2] atIndex:i];
            
            CLLocationCoordinate2D tmpPT;
            tmpPT.latitude = [((Location*)[_appDelegate.AppUserInfo.Locations objectAtIndex:i]).Latitude doubleValue];
            tmpPT.longitude = [((Location*)[_appDelegate.AppUserInfo.Locations objectAtIndex:i]).Longitude doubleValue];
            NSValue* newPTValue = [NSValue valueWithBytes:&tmpPT objCType:@encode(CLLocationCoordinate2D)];
            [_locPTArray insertObject:newPTValue atIndex:i];
        }
    }
}

-(void)confirmMyLocations
{
    if (_appDelegate.AppUserInfo.Locations == nil)
    {
        _appDelegate.AppUserInfo.Locations = [[NSMutableArray alloc] init];
    } else
    {
        [_appDelegate.AppUserInfo.Locations removeAllObjects];
    }
    
    if (_appDelegate.AppUserInfo.LocationStrs == nil)
    {
        _appDelegate.AppUserInfo.LocationStrs = [[NSMutableArray alloc] init];
    }else
    {
        [_appDelegate.AppUserInfo.LocationStrs removeAllObjects];
    }
    
    for (int i = 0; i < _locKeyArray.count; i++)
    {
        [_appDelegate.AppUserInfo.LocationStrs insertObject:[NSString stringWithFormat:@"%@·%@·%@",(NSString*)[_locCityArray objectAtIndex:i], (NSString*)[_locDistrictArray objectAtIndex:i], (NSString*)[_locKeyArray objectAtIndex:i]] atIndex:i];
        CLLocationCoordinate2D pt;
        [(NSValue*)[_locPTArray objectAtIndex:i] getValue:&pt];
        [_appDelegate.AppUserInfo.Locations insertObject:[Location LocationWithCLLocationCoordinate2D:pt] atIndex:i];
    }
    
    [_appDelegate.AppUserInfo UpdateUserInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addMyLocation
{
    if (!_locKey || !_locDistrict || !_locCity)
    {
        return;
    }
    
    //更新响应地址数据
    [_locKeyArray insertObject:[NSString stringWithString:_locKey] atIndex:_locKeyArray.count];
    [_locDistrictArray insertObject:[NSString stringWithString:_locDistrict] atIndex:_locDistrictArray.count];
    [_locCityArray insertObject:[NSString stringWithString:_locCity] atIndex:_locCityArray.count];
    NSValue* ptValue = [NSValue valueWithBytes:&_locPT objCType:@encode(CLLocationCoordinate2D)];
    [_locPTArray insertObject:ptValue atIndex:_locPTArray.count];
    
    //更新响应地址编辑控制器数据
    [_showMyLocListVC.keyList insertObject:[NSString stringWithString:_locKey] atIndex:_showMyLocListVC.keyList.count];
    [_showMyLocListVC.districtList insertObject:[NSString stringWithString:_locDistrict] atIndex:_showMyLocListVC.districtList.count];
    [_showMyLocListVC.cityList insertObject:[NSString stringWithString:_locCity] atIndex:_showMyLocListVC.cityList.count];
    NSValue* ptValue1 = [NSValue valueWithBytes:&_locPT objCType:@encode(CLLocationCoordinate2D)];
    [_showMyLocListVC.ptList insertObject:ptValue1 atIndex:_showMyLocListVC.ptList.count];
    _showMyLocListVC.locNumber = _showMyLocListVC.keyList.count;
    
    //刷新响应地址编辑控制器视图
    [self performSelectorOnMainThread:@selector(reloadShowMyLocsList) withObject:nil waitUntilDone:nil];
    [self setShowMyLocListHidden:NO];
}

-(void)reloadShowMyLocsList
{
    [_showMyLocListVC.tableView reloadData];
}

//搜索建议列表代理
-(void)ChooseLocationWithKey:(NSString *)locKey andDistrict:(NSString *)locDis andCity:(NSString *)locCity andLoctionPT:(CLLocationCoordinate2D)pt
{
    _locKey = locKey;
    _locDistrict = locDis;
    _locCity = locCity;
    _locPT = pt;
    
    _searchLocation.text = _locKey;
    _mapView.centerCoordinate = pt;
    [_mapView removeAnnotation:_anno];
    _anno.coordinate = pt;
    [_mapView addAnnotation:_anno];
    [self setLocSearchSuggestionHidden:YES];
    
    [_searchLocation resignFirstResponder];
    [_searchCity resignFirstResponder];
}

//响应地址编辑列表代理
-(void)removeMyLoc:(NSInteger)index
{
    [_locKeyArray removeObjectAtIndex:index];
    [_locDistrictArray removeObjectAtIndex:index];
    [_locCityArray removeObjectAtIndex:index];
    [_locPTArray removeObjectAtIndex:index];
    
    [self performSelectorOnMainThread:@selector(reloadShowMyLocsList) withObject:nil waitUntilDone:nil];
    [self setShowMyLocListHidden:NO];
}

-(void)changeShowState
{
    [self performSelectorOnMainThread:@selector(reloadShowMyLocsList) withObject:nil waitUntilDone:nil];
    [self setShowMyLocListHidden:NO];
}

- (void)setLocSearchSuggestionHidden:(BOOL)hidden {
    NSInteger height;
    
    if (_locSuggVC.keyList.count >= 6)
    {
        height = hidden ? 0: 44*6;
    } else
    {
        height = hidden ? 0: 44*_locSuggVC.keyList.count;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_locSuggVC.view setFrame:CGRectMake(80, 76, 280, height)];
    [UIView commitAnimations];
}

- (void)setShowMyLocListHidden:(BOOL)hidden {
    NSInteger height;
    
    if (_showMyLocListVC.keyList.count == 0 || hidden)
    {
        height = 0;
    } else
    {
        if (!_showMyLocListVC.showFlag)
        {
            height = 44;
        } else
        {
            height = (_showMyLocListVC.keyList.count+1)*44;
        }
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_showMyLocListVC.view setFrame:CGRectMake(43, 570-height, 291, height)];
    [UIView commitAnimations];
}

-(void)removeSearchBackground
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([_searchLocation respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1){
            
            [[[[_searchLocation.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [_searchLocation setBackgroundColor:[UIColor clearColor]];
            
        }else {            //iOS7.0
            [_searchLocation setBarTintColor:[UIColor clearColor]];
            [_searchLocation setBackgroundColor:[UIColor clearColor]];
        }
    }else {
        //iOS7.0以下
        [[_searchLocation.subviews objectAtIndex:0] removeFromSuperview];
        
        [_searchLocation setBackgroundColor:[UIColor clearColor]];
    }
}

//地址搜素栏代理
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText != nil && searchText.length != 0)
    {
        BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
        option.cityname = _searchCity.text;
        option.keyword  = searchText;
        BOOL flag = [_searchSuggestion suggestionSearch:option];
        //[option release];
        if(!flag)
        {
            NSLog(@"Sug检索发送失败");
        }
    } else
    {
        [self setLocSearchSuggestionHidden:YES];
    }
}

//搜索地址建议 回调
-(void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_OPEN_NO_ERROR)
    {
        for(int i = 0; i < result.cityList.count; i++)
        {
            _locSuggVC.locNumber = result.keyList.count;
            _locSuggVC.keyList = [NSArray arrayWithArray:result.keyList];
            _locSuggVC.districtList = [NSArray arrayWithArray:result.districtList];
            _locSuggVC.ptList = [NSArray arrayWithArray:result.ptList];
            _locSuggVC.cityList = [NSArray arrayWithArray:result.cityList];
            [self performSelectorOnMainThread:@selector(reloadlLocSuggest) withObject:nil waitUntilDone:nil];
            
            [self setLocSearchSuggestionHidden:NO];
        }
    } else
    {
        NSLog(@"调用百度搜索地址建议出错，错误码:%d.",  error);
    }
}

-(void)reloadlLocSuggest
{
    [_locSuggVC.tableView reloadData];
}

//地图代理
-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    [_searchLocation resignFirstResponder];
    [_searchCity resignFirstResponder];
    [self setLocSearchSuggestionHidden:YES];
}

//定位回调
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (_curLocSetFlag == FALSE)
    {
        [_mapView updateLocationData:userLocation];
        _mapView.centerCoordinate = userLocation.location.coordinate;
        _anno.coordinate = userLocation.location.coordinate;
        [_mapView addAnnotation:_anno];
        _curLocSetFlag = TRUE;
    }
    
    if (_citySetFlag == FALSE)
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation: userLocation.location completionHandler:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                CLPlacemark *placemark = [array objectAtIndex:0];
                if (placemark != nil) {
                    NSString *city = placemark.locality;
                    
                    _searchCity.text = city;
                }
            }
        }];
        
        _citySetFlag = TRUE;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _searchLocation.delegate = self;
    _searchSuggestion.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searchLocation.delegate = nil;
    _searchSuggestion.delegate = nil;
    //_locationStrsSearch.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

