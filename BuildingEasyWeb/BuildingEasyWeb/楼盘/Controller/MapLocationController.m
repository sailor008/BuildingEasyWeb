//
//  MapLocationController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MapLocationController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKPinAnnotationView.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface MapLocationController ()<BMKMapViewDelegate>

// 添加地图
@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation MapLocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
//    _mapView.delegate = self;
//    [_mapView setZoomLevel:16.0];
//    _mapView.isSelectedAnnotationViewFront = YES;
//    //显示指南针
//    [_mapView setCompassPosition:CGPointMake(10, 10)];
//    [self.view addSubview: _mapView];
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

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)locationAtPoint:(NSDictionary*)pointInfo
{
    double longitudeVal = [[pointInfo objectForKey:@"longitude"] doubleValue];
    double latitudeVal = [[pointInfo objectForKey:@"latitude"] doubleValue];
    NSLog(@"跳转到baidu地图位置： longitude = %f， latitude = %f", longitudeVal, latitudeVal);
    
    //初始化BMKMapView
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate = self;
    [_mapView setZoomLevel:16.0];
    _mapView.isSelectedAnnotationViewFront = YES;
    //显示指南针
    [_mapView setCompassPosition:CGPointMake(10, 10)];
    [self.view addSubview: _mapView];
    
    //即将跳转到的位置（注意：如果是在在viewDidLoad 初始化BMKMapView，此处在UI主循环显示标注，有时会不成功显示）
    CLLocationCoordinate2D coor;
    coor.longitude = longitudeVal;
    coor.latitude = latitudeVal;
    _mapView.centerCoordinate = coor;
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coor;
    annotation.title = _locationName;
    [_mapView addAnnotation:annotation];

//    dispatch_async(dispatch_get_main_queue(), ^{
//        CLLocationCoordinate2D coor;
//        coor.longitude = longitudeVal;
//        coor.latitude = latitudeVal;
//        _mapView.centerCoordinate = coor;
//        // 添加一个PointAnnotation
//        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//        annotation.coordinate = coor;
//        annotation.title = @"这里";
//        [_mapView addAnnotation:annotation];
//    });
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        NSString* annotationId = [NSString stringWithFormat:@"myAnnotation_%f", annotation.coordinate.latitude];
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: annotationId];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

@end
