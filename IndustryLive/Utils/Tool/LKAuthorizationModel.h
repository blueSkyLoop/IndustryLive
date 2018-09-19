//
//  LKAuthorizationModel.h
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/27.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>

/*
 获取相关的权限，不只是判断当前的权限状态，如果用户未作出过选择，会弹出系统选择框给用户作出选择，然后根据用户的选择返回权限与否，其它情况只判断有没有权限，即只判断状态来返回权限与否
 如果不是用户作选择时期
 */

@interface LKAuthorizationModel : NSObject

//相册权限
+ (BOOL)photoAlbumAuthorizationShowUnabelMessage:(BOOL)isShow;

//相册权限 block 形式，不阻塞线程
+ (void)photoAlbumAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,PHAuthorizationStatus status))compleBlock;

//相机权限
+ (BOOL)cameraAuthorizationShowUnabelMessage:(BOOL)isShow;

//相机权限 block 形式，不阻塞线程
+ (void)cameraAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,AVAuthorizationStatus status))compleBlock;

//麦克风权限
+ (BOOL)audiAuthorizationShowUnabelMessage:(BOOL)isShow;

//麦克风权限 block 形式，不阻塞线程
+ (void)audiAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,AVAuthorizationStatus status))compleBlock;

//通讯录权限
+ (BOOL)addressBookAuthorizationShowUnabelMessage:(BOOL)isShow;

//通讯录权限 block 形式，不阻塞线程
+ (void)addressBookAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,NSInteger status))compleBlock;

//定位权限
+ (void)locationAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,CLAuthorizationStatus status))compleBlock;



@end
