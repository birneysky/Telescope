//
//  TEPersonaSettingsTableController.m
//  Telescope
//
//  Created by zhangguang on 16/11/16.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEPersonaSettingsTableController.h"
#import "TESettingTableController.h"


@interface TEPersonaSettingsTableController ()

@property (nonatomic,strong) NSArray<NSArray<NSString*>*>* dataSource;

@property (nonatomic,strong) NSArray<NSArray<NSString*>*>* imageNames;

@end

@implementation TEPersonaSettingsTableController
#pragma mark - *** Properties ***
- (NSArray<NSArray<NSString*>*>*) dataSource{
    if (!_dataSource) {
        _dataSource = @[@[@"MyInformation"],@[@"我的朋友",@"我的关注",@"我的粉丝",@"添加朋友"],@[@"我的钱包",@"我的视频",@"我的消息"],@[@"设置"]];
    }
    return _dataSource;
}

- (NSArray<NSArray<NSString*>*>*) imageNames
{
    if (!_imageNames) {
        _imageNames = @[@[@"te_default_head_image"],@[@"te_settings_friends",@"te_settings_follow",@"te_settings_fans",@"te_settings_add_friend"],@[@"te_settings_wallet",@"te_settings_video",@"te_settings_message"],@[@"te_settings_setting"]];
    }
    return _imageNames;
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* identifier = indexPath.section == 0 && indexPath.row == 0 ? @"TESettingsSelfCell" : @"TESettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    // Configure the cell...
    

    
    NSString* imageName = self.imageNames[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    NSString* text = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSMutableAttributedString* attributeText = [[NSMutableAttributedString alloc] initWithString:text];
        NSAttributedString* symbolAttributeText = [[NSAttributedString alloc] initWithString:@" ♂  " attributes:@{NSForegroundColorAttributeName:TERGB(252, 70, 76),NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
        NSAttributedString* starAttributeText = [[NSAttributedString alloc] initWithString:@"★ 3" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],NSBackgroundColorAttributeName:TERGB(254, 199, 40),NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [attributeText appendAttributedString:symbolAttributeText];
        [attributeText appendAttributedString:starAttributeText];
        cell.textLabel.attributedText = [attributeText copy];
        cell.detailTextLabel.text = @"135****8888";
    }
    else{
        cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    }
    
    
    return cell;
}

#pragma mark *** UITableViewDelegate ***
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 88.0f;
    }
    else{
        return 44.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* text = self.dataSource[indexPath.section][indexPath.row];
    if ([text isEqualToString:@"设置"]) {
        [self performSegueWithIdentifier:@"te_push_setting" sender:indexPath];
    }
    
    if ([text isEqualToString:@"我的消息"]) {
        [self performSegueWithIdentifier:@"te_push_messages" sender:indexPath];
    }
    
    if ([text isEqualToString:@"我的粉丝"]) {
        [self performSegueWithIdentifier:@"te_push_fans" sender:indexPath];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"te_push_setting"]) {
        
    }
    
    if ([segue.identifier isEqualToString:@"te_push_messages"]) {
        
    }
    
    
}


@end
