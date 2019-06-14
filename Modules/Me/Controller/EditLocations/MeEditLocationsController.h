//
//  MeEditLocationsController.h
//  Tree
//
//  Created by 施威特 on 2018/6/11.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MeLocationListController.h"
#import "MeShowMyLocationsController.h"
#import "BaiduMapAPI_Base/BMKBaseComponent.h"
#import "BaiduMapAPI_Map/BMKMapComponent.h"
#import "BaiduMapAPI_Search/BMKSearchComponent.h"
#import "BaiduMapAPI_Location/BMKLocationComponent.h"
#import "BaiduMapAPI_Cloud/BMKCloudSearchComponent.h"

@interface MeEditLocationsController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, UISearchBarDelegate, BMKSuggestionSearchDelegate, MeLocationListDelegate, MeShowMyLocListDelegate>
{
    AppDelegate* _appDelegate;
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    UISearchBar* _searchLocation;
    UITextField* _searchCity;
    BOOL _citySetFlag;
    BOOL _curLocSetFlag;
    BMKSuggestionSearch* _searchSuggestion;
    MeLocationListController* _locSuggVC;
    MeShowMyLocationsController* _showMyLocListVC;
    BMKPointAnnotation* _anno;
    
    NSString* _locKey;
    NSString* _locDistrict;
    NSString* _locCity;
    CLLocationCoordinate2D _locPT;
    
    NSMutableArray* _locKeyArray; //NSString*
    NSMutableArray* _locDistrictArray; //NSString*
    NSMutableArray* _locCityArray;     //NSString*
    NSMutableArray* _locPTArray;  //NSValue* -> CLLocationCoordinate2D
    
    /*
    NSMutableArray* _locationsStringArray;
    NSMutableArray* _locationsPTarray;
    
    dispatch_semaphore_t _locStrSema;
     */
}

@property (strong, nonatomic) IBOutlet UIButton *Btn_AddMyLoc;
@property (strong, nonatomic) IBOutlet UIButton *Btn_ConfirmMyLocs;


@end
