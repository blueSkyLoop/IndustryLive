//
//  LiveBaseViewController.m
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "LiveBaseViewController.h"

@interface LiveBaseViewController ()

@end

@implementation LiveBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self live_setUpUI];
    
    [self live_bindViewModel];
}
//子类重写
- (void)live_setUpUI{}
//子类重写
- (void)live_bindViewModel{}

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
