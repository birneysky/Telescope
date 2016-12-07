//
//  TEChatTableViewController.m
//  Telescope
//
//  Created by zhangguang on 16/12/1.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEChatTableViewController.h"
#import "TECoreDataHelper.h"
#import "TEMessage+CoreDataProperties.h"
#import "TEBubbleCell.h"

@interface TEChatTableViewController ()

@property (nonatomic,strong) NSFetchRequest* fetchRequest;



@end

@implementation TEChatTableViewController

#pragma mark - *** Properties ***
- (NSFetchRequest*)fetchRequest
{
    if (!_fetchRequest) {
        _fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TEMessage"];
    }
    return _fetchRequest;
}

#pragma mark - *** Initializer ***
- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ TEChatTableViewController dealloc");
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    [self.timer invalidate];
    self.timer = nil;
    
//    for (int i =0 ; i < self.frc.fetchedObjects.count; i++) {
//        TEMessage* messageItem = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        [self.frc.managedObjectContext refreshObject:messageItem mergeChanges:NO];
//    }
    self.frc = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configureFetch];
//    [self performFetch];
}


- (void)setSession:(TEChatSession *)session
{
    _session = session;
    [self configureFetch];
    [self performFetch];
}

#pragma mark - *** Helper ***
- (void)configureFetch
{
    TECoreDataHelper* helper = [TECoreDataHelper defaultHelper];

    NSPredicate* predicate  = [NSPredicate predicateWithFormat:@"session = %@",self.session];
    self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
    self.fetchRequest.predicate = predicate;
    [self.fetchRequest setFetchBatchSize:50];
    [self.fetchRequest setFetchLimit:50];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:helper.backgroundContext sectionNameKeyPath:nil cacheName:nil];/* cacheName TEChatMessage*/
    self.frc.delegate = self;
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerSelecotor:) userInfo:nil repeats:YES];
}
#pragma mark - *** KVO ***

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"change %@",change);
        NSLog(@"contentSize %@, contentinset %@,",NSStringFromCGSize(self.tableView.contentSize) ,NSStringFromUIEdgeInsets(self.tableView.contentInset));
        //[self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 44, self.tableView.contentSize.width, 44) animated:NO];
    }
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TEBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TEMessageCell" forIndexPath:indexPath];
    
    // Configure the cell...
    TEMessage* message = [self.frc objectAtIndexPath:indexPath];
    //[message layoutModel];
    //cell.textLabel.text  = message.content;
    [cell setLayoutModel:message.layoutModel];
    NSDateFormatter*  dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* dateString = [dateFormatter stringFromDate:message.sendTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dateString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"new indexpath row %ld, count %ld",indexPath.row, self.frc.fetchedObjects.count);  
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:self.frc.fetchedObjects.count - 1 inSection:0];
    NSLog(@"new indexpath row %ld, count %ld",indexPath.row, self.frc.fetchedObjects.count);
    //[self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TEMessage* message = [self.frc objectAtIndexPath:indexPath];
    
    return message.layoutModel.height;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma makr - ***Target Action***
- (IBAction)tt:(id)sender {
    [self.frc.managedObjectContext processPendingChanges];
}

#pragma mark - *** Timer ***
- (void)timerSelecotor:(NSTimer*)timer
{
    //self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
    
    //NSArray<NSIndexPath*>* visibles = self.tableView.indexPathsForVisibleRows;
    NSLog(@"😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁 %ld  ",self.frc.fetchedObjects.count);
    //NSInteger visibleFirstIndex = visibles.firstObject.row;

        __weak TEChatTableViewController* weakSelf = self;
        [weakSelf.frc.managedObjectContext performBlock:^{
            if(weakSelf.frc.fetchedObjects.count > 50){
                TEMessage* message = [weakSelf.frc objectAtIndexPath:[NSIndexPath indexPathForRow:24 inSection:0]];
                weakSelf.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"session = %@ and sendTime > %@",weakSelf.session,message.sendTime];
                [weakSelf.fetchRequest setFetchBatchSize:weakSelf.frc.fetchedObjects.count - 25];
                [weakSelf.fetchRequest setFetchLimit:weakSelf.frc.fetchedObjects.count - 25];
                
                
                NSError* error;
                if (![weakSelf.frc performFetch:&error]) {
                    DebugLog(@"Failed to perform fetch : %@",error);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
                //[weakSelf.frc.managedObjectContext refreshAllObjects];
                
        }
        }];
        
        //[self performFetch];
   
    
    
}
    
@end
