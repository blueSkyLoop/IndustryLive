//
//  MHChooseUrlController.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHChooseUrlController.h"
#import "MHMacros.h"
#import "MHChooseUrlModel.h"

@interface MHChooseUrlController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textF;

@end

@implementation MHChooseUrlController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ///MARK - set url
    NSString *ip = [MHChooseUrlModel requestArray][indexPath.row][@"ip"];
    [MHChooseUrlModel setBaseHttpIP:ip];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.textF.text = ip ;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MHChooseUrlControllerCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [MHChooseUrlModel requestArray][indexPath.row][@"name"];
    cell.detailTextLabel.text = [MHChooseUrlModel requestArray][indexPath.row][@"ip"];
    if ([[MHChooseUrlModel requestArray][indexPath.row][@"ip"] isEqualToString:[MHChooseUrlModel getBaseHttpIP]]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MHChooseUrlModel requestArray].count ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70 ;
}

// 键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
- (IBAction)choose:(id)sender {
//    self.textF.text = baseUrl ;
    [MHChooseUrlModel setBaseHttpIP:self.textF.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择服务器";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.textF.text = [MHChooseUrlModel getBaseHttpIP];
}


@end
