//
//  CreateTaskLocationController.h
//  Tree
//
//  Created by 施威特 on 2018/3/27.
//  Copyright © 2018年 施威特. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskCreateInfo.h"
#import "LocationListController.h"
#import "BaiduMapAPI_Base/BMKBaseComponent.h"
#import "BaiduMapAPI_Map/BMKMapComponent.h"
#import "BaiduMapAPI_Search/BMKSearchComponent.h"
#import "BaiduMapAPI_Location/BMKLocationComponent.h"
#import "BaiduMapAPI_Cloud/BMKCloudSearchComponent.h"

@interface CreateTaskLocationController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, UISearchBarDelegate, BMKSuggestionSearchDelegate, LocationListDelegate>
{
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    UISearchBar* _searchLocation;
    UITextField* _searchCity;
    BOOL _citySetFlag;
    BOOL _curLocSetFlag;
    BMKSuggestionSearch* _searchSuggestion;
    LocationListController* _locSuggVC;
    BMKPointAnnotation* _anno;
    
    NSString* _locKey;
    NSString* _locDistrict;
    NSString* _locCity;
    CLLocationCoordinate2D _locPT;
    
}

@property (retain, nonatomic)TaskCreateInfo* CreateInfo;
@property (strong, nonatomic) IBOutlet UIButton *Btn_ConfirmLocation;


@end
