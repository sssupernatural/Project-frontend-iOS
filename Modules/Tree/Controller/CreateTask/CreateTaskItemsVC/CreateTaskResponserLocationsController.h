//
//  CreateTaskResponserLocationsController.h
//  Tree
//
//  Created by 施威特 on 2018/4/3.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateInfo.h"
#import "LocationListController.h"
#import "ShowRespLocListController.h"
#import "BaiduMapAPI_Base/BMKBaseComponent.h"
#import "BaiduMapAPI_Map/BMKMapComponent.h"
#import "BaiduMapAPI_Search/BMKSearchComponent.h"
#import "BaiduMapAPI_Location/BMKLocationComponent.h"
#import "BaiduMapAPI_Cloud/BMKCloudSearchComponent.h"

@interface CreateTaskResponserLocationsController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, UISearchBarDelegate, BMKSuggestionSearchDelegate, LocationListDelegate, RespLocListDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    UISearchBar* _searchLocation;
    UITextField* _searchCity;
    BOOL _citySetFlag;
    BOOL _curLocSetFlag;
    BMKSuggestionSearch* _searchSuggestion;
    LocationListController* _locSuggVC;
    ShowRespLocListController* _showRespLocListVC;
    BMKPointAnnotation* _anno;
    
    NSString* _locKey;
    NSString* _locDistrict;
    NSString* _locCity;
    CLLocationCoordinate2D _locPT;
    
    NSMutableArray* _locKeyArray; //NSString*
    NSMutableArray* _locDistrictArray; //NSString*
    NSMutableArray* _locCityArray;     //NSString*
    NSMutableArray* _locPTArray;  //NSValue* -> CLLocationCoordinate2D
}
@property (strong, nonatomic) IBOutlet UIButton *Btn_AddRespLoc;
@property (strong, nonatomic) IBOutlet UIButton *Btn_ConfirmRespLocs;

@property (retain, nonatomic)TaskCreateInfo* CreateInfo;

@end
