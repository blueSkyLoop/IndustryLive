//
//  LKAuthorizationModel.m
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/27.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import "LKAuthorizationModel.h"

#import <ReactiveObjC.h>

static LKAuthorizationModel *authorizaModel = nil;

@interface LKAuthorizationModel()<CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager *manager;

@end

@implementation LKAuthorizationModel

//相册权限
+ (BOOL)photoAlbumAuthorizationShowUnabelMessage:(BOOL)isShow{
    __block BOOL isEnable = NO;
    PHAuthorizationStatus ationStatus = [PHPhotoLibrary authorizationStatus];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    if(ationStatus == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            isEnable = [self photoLimitWithStatus:status];
            dispatch_semaphore_signal(sema);
        }];
    }else {
        dispatch_semaphore_signal(sema);
        isEnable = [self photoLimitWithStatus:ationStatus];
        if(!isEnable && isShow){
            [self showphotoAlbumUnableMessage];
        }
    }
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return isEnable;
}
//相册权限
+ (void)photoAlbumAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,PHAuthorizationStatus status))compleBlock{
    __block BOOL isEnable = NO;
    PHAuthorizationStatus ationStatus = [PHPhotoLibrary authorizationStatus];
    if(ationStatus == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            isEnable = [self photoLimitWithStatus:status];
            if(compleBlock){
                compleBlock(isEnable,status);
            }
        }];
    }else {
        isEnable = [self photoLimitWithStatus:ationStatus];
        if(!isEnable && isShow){
            [self showphotoAlbumUnableMessage];
        }
        if(compleBlock){
            compleBlock(isEnable,ationStatus);
        }
    }
    
}
+ (BOOL)photoLimitWithStatus:(PHAuthorizationStatus)status{
    if(status == PHAuthorizationStatusAuthorized){
        return YES;
    }
    return NO;
}

+ (void)showphotoAlbumUnableMessage{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *message = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册",[infoDictionary objectForKey:@"CFBundleDisplayName"]?:[infoDictionary objectForKey:@"CFBundleName"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [[self currentTopController] presentViewController:alert animated:YES completion:nil];
}

//相机权限
+ (BOOL)cameraAuthorizationShowUnabelMessage:(BOOL)isShow{
    __block BOOL isEnable = NO;
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    if(AVstatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
            isEnable = granted;
            dispatch_semaphore_signal(sema);
        }];
    }else {
        dispatch_semaphore_signal(sema);
        isEnable = [self cameraAndAudioLimitWithStatus:AVstatus];
        if(!isEnable && isShow){
            [self showCameraUnableMessage];
        }
    }
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return isEnable;
}

//相机权限 block 形式，不阻塞线程
+ (void)cameraAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,AVAuthorizationStatus status))compleBlock{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(AVstatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
            if(compleBlock){
                compleBlock(granted,[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]);
            }
        }];
    }else {
        BOOL isEnable = [self cameraAndAudioLimitWithStatus:AVstatus];
        if(!isEnable && isShow){
            [self showCameraUnableMessage];
        }
        if(compleBlock){
            compleBlock(isEnable,AVstatus);
        }
    }
}

//麦克风权限
+ (BOOL)audiAuthorizationShowUnabelMessage:(BOOL)isShow{
    __block BOOL isEnable = NO;
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    if(AVstatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {//麦克风权限
            isEnable = granted;
            dispatch_semaphore_signal(sema);
        }];
    }else {
        dispatch_semaphore_signal(sema);
        isEnable = [self cameraAndAudioLimitWithStatus:AVstatus];
        if(!isEnable && isShow){
            [self showAudiUnableMessage];
        }
    }
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return isEnable;
}
//麦克风权限 block 形式，不阻塞线程
+ (void)audiAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,AVAuthorizationStatus status))compleBlock{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(AVstatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {//麦克风权限
            if(compleBlock){
                compleBlock(granted,[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]);
            }
        }];
    }else {
        BOOL isEnable = [self cameraAndAudioLimitWithStatus:AVstatus];
        if(!isEnable && isShow){
            [self showAudiUnableMessage];
        }
        if(compleBlock){
            compleBlock(isEnable,AVstatus);
        }
    }
}

+ (BOOL)cameraAndAudioLimitWithStatus:(AVAuthorizationStatus)status{
    if(status == AVAuthorizationStatusAuthorized){
        return YES;
    }
    return NO;
}

+ (void)showCameraUnableMessage{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *message = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-相机\"选项中，允许%@访问你的摄像头",[infoDictionary objectForKey:@"CFBundleDisplayName"]?:[infoDictionary objectForKey:@"CFBundleName"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    UIViewController *controller = [UIApplication sharedApplication].delegate.window.rootViewController;
    [controller.presentedViewController presentViewController:alert animated:YES completion:nil];
}


+ (void)showAudiUnableMessage{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *message = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-麦克风\"选项中，允许%@访问你的麦克风",[infoDictionary objectForKey:@"CFBundleDisplayName"]?:[infoDictionary objectForKey:@"CFBundleName"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    UIViewController *controller = [UIApplication sharedApplication].delegate.window.rootViewController;
    [controller.presentedViewController presentViewController:alert animated:YES completion:nil];
}

//通讯录权限
+ (BOOL)addressBookAuthorizationShowUnabelMessage:(BOOL)isShow{
    __block BOOL isEnable = NO;
    if([UIDevice currentDevice].systemVersion.floatValue >= 9.0){
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        if(status == CNAuthorizationStatusNotDetermined){
            
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                isEnable = granted;
                dispatch_semaphore_signal(sema);
            }];
            
        }else{
            dispatch_semaphore_signal(sema);
            isEnable = [self contactLimitWithStatus:status];
            if(!isEnable && isShow){
                [self showAddressBookUnableMessage];
            }
        }
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return isEnable;
    }
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    if(authStatus == kABAuthorizationStatusNotDetermined){
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            isEnable = granted;
            dispatch_semaphore_signal(sema);
        });
        
    }else{
        dispatch_semaphore_signal(sema);
        isEnable = [self addressLimitWithStatus:authStatus];
        if(!isEnable && isShow){
            [self showAddressBookUnableMessage];
        }
    }
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    CFRelease(addressBook);
    return isEnable;
}

//通讯录权限 block 形式，不阻塞线程
+ (void)addressBookAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,NSInteger status))compleBlock{
    __block BOOL isEnable = NO;
    if([UIDevice currentDevice].systemVersion.floatValue >= 9.0){
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if(status == CNAuthorizationStatusNotDetermined){
            
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                isEnable = granted;
                if(compleBlock){
                    compleBlock(isEnable,[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]);
                }
            }];
            
        }else{
            isEnable = [self contactLimitWithStatus:status];
            if(!isEnable && isShow){
                [self showAddressBookUnableMessage];
            }
            if(compleBlock){
                compleBlock(isEnable,status);
            }
        }
        return;
    }
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if(authStatus == kABAuthorizationStatusNotDetermined){
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            isEnable = granted;
            if(compleBlock){
                compleBlock(isEnable,ABAddressBookGetAuthorizationStatus());
            }
        });
        
    }else{
        isEnable = [self addressLimitWithStatus:authStatus];
        if(!isEnable && isShow){
            [self showAddressBookUnableMessage];
        }
        if(compleBlock){
            compleBlock(isEnable,authStatus);
        }
    }
    CFRelease(addressBook);
}

+ (BOOL)contactLimitWithStatus:(CNAuthorizationStatus)status{
    if(status == CNAuthorizationStatusAuthorized){
        return YES;
    }
    return NO;
}
+ (BOOL)addressLimitWithStatus:(ABAuthorizationStatus)status{
    if(status == kABAuthorizationStatusAuthorized){
        return YES;
    }
    return NO;
}

+ (void)showAddressBookUnableMessage{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *message = [NSString stringWithFormat:@"请在iPhone的\"设置-隐私-通讯录\"选项中，允许%@访问你的通讯录",[infoDictionary objectForKey:@"CFBundleDisplayName"]?:[infoDictionary objectForKey:@"CFBundleName"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [[self currentTopController] presentViewController:alert animated:YES completion:nil];
}

//定位权限
+ (void)locationAuthorizationShowUnabelMessage:(BOOL)isShow comple:(void (^)(BOOL isEnable,CLAuthorizationStatus status))compleBlock{
    if (![CLLocationManager locationServicesEnabled]) {
        if(isShow){
            [self showLocationUnableMessage];
        }
        if(compleBlock){
            compleBlock(NO,-1);
        }
        return;
    }
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    if(CLstatus == kCLAuthorizationStatusNotDetermined){
        if(!authorizaModel){
            authorizaModel = [LKAuthorizationModel new];
            CLLocationManager *manager = [[CLLocationManager alloc] init];
            authorizaModel.manager = manager;
        }
        authorizaModel.manager.delegate = authorizaModel;
        
        if([authorizaModel.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [authorizaModel.manager requestWhenInUseAuthorization];
        }
        if([authorizaModel.manager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [authorizaModel.manager requestAlwaysAuthorization];
        }
        @weakify(authorizaModel);
        [[authorizaModel rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate) ] subscribeNext:^(RACTuple * _Nullable x) {
            CLAuthorizationStatus astatus = [[x second] intValue];
            if(astatus != kCLAuthorizationStatusNotDetermined){
                @strongify(authorizaModel);
                authorizaModel.manager.delegate = nil;
                if(compleBlock){
                    compleBlock([[authorizaModel class] locationLimitWithStatus:astatus],astatus);
                }
            }
        }];
        
    }else{
        BOOL isEnable = [self locationLimitWithStatus:CLstatus];
        if(!isEnable && isShow){
            [self showLocationUnableMessage];
        }
        if(compleBlock){
            compleBlock(isEnable,CLstatus);
        }
    }
}

+ (BOOL)locationLimitWithStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        return YES;
    }
    return NO;
}

+ (void)showLocationUnableMessage{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *message = [NSString stringWithFormat:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许%@使用定位服务",[infoDictionary objectForKey:@"CFBundleDisplayName"]?:[infoDictionary objectForKey:@"CFBundleName"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开定位开关" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [[self currentTopController] presentViewController:alert animated:YES completion:nil];
}

+ (UIViewController *)currentTopController{
    UIViewController *controller = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([controller isKindOfClass:[UITabBarController class]] || [controller isKindOfClass:[UINavigationController class]]){
        return controller;
    }
    if(controller.presentedViewController){
        return controller.presentedViewController;
    }
    return controller;
}



@end
