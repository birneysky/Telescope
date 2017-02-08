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
#import "TEChatSession+CoreDataProperties.h"
#import "TEBubbleCell.h"
#import "TEBubbleAudioCell.h"


#import "LWImageBrowserModel.h"
#import "LWImageBrowser.h"
#import "MJRefresh.h"


#import <V2Kit/V2Kit.h>


@interface TEChatTableViewController () <TEBubbleCellDelegate,TEBubbleAudioPlayDelegate,AudioPlaybackDelegate>

@property (nonatomic,strong) NSFetchRequest* fetchRequest;


/**
 是否自动滑动到底部，当收到新消息时
 */
@property (nonatomic,assign) BOOL autoScrollToBottomWhenNewMessaeComming;


/**
 正在播放音频的索引字典，key 文件id， value，为列表中对应的索引
 */
@property (nonatomic,strong) NSMutableDictionary<NSString*,NSNumber*>* audioPlayingDict;

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

- (NSMutableDictionary<NSString*,NSNumber*>*)audioPlayingDict
{
    if (!_audioPlayingDict) {
        _audioPlayingDict = [[NSMutableDictionary alloc] init];
    }
    return _audioPlayingDict;
}

#pragma mark - *** Initializer ***
- (void)dealloc
{
    NSLog(@"♻️♻️♻️♻️ TEChatTableViewController dealloc");
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    
    self.frc.delegate = nil;
    self.frc = nil;
    
    [self.timer invalidate];
    self.timer = nil;
    
    [V2Kit defaultKit].playbackDelegate = nil;
    
//    for (int i =0 ; i < self.frc.fetchedObjects.count; i++) {
//        TEMessage* messageItem = [self.frc objectAtIndexPath:[NSIndexPath indexPathFo§rRow:i inSection:0]];
//        [self.frc.managedObjectContext refreshObject:messageItem mergeChanges:NO];
//    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configureFetch];
//    [self performFetch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.frc.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.frc.delegate = nil;
}


- (void)setSession:(TEChatSession *)session
{
    _session = session;
    [self configureFetch];
    [self performFetch];
    [V2Kit defaultKit].playbackDelegate = self;
}

#pragma mark - *** Helper ***
- (void)configureFetch
{
    TECoreDataHelper* helper = [TECoreDataHelper defaultHelper];

    NSPredicate* predicate  = [NSPredicate predicateWithFormat:@"sessionID = %lld",self.session.sID];
    
    self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
    self.fetchRequest.predicate = predicate;
    NSInteger offset = self.session.totalNumOfMessage - 20 < 0 ? 0 : self.session.totalNumOfMessage - 20;
    [self.fetchRequest setFetchOffset:offset];
    [self.fetchRequest setFetchLimit:20];
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:helper.backgroundContext sectionNameKeyPath:nil cacheName:nil];/* cacheName TEChatMessage*/
    self.frc.delegate = self;
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerSelecotor:) userInfo:nil repeats:YES];
    self.autoScrollToBottomWhenNewMessaeComming = YES;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
}
#pragma mark - *** KVO ***

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"] && self.autoScrollToBottomWhenNewMessaeComming) {
        //NSLog(@"change %@",change);
        //NSLog(@"contentSize %@, contentinset %@,",NSStringFromCGSize(self.tableView.contentSize) ,NSStringFromUIEdgeInsets(self.tableView.contentInset));
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:0.25f];
//        [UIView setAnimationCurve:7];
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 44, self.tableView.contentSize.width, 44) animated:NO];
//        [UIView commitAnimations];
    }
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TEBubbleCell *cell;
    TEMessage* message = [self.frc objectAtIndexPath:indexPath];
    if (TEChatMessageTypeAudio == message.type) {
        TEBubbleAudioCell* audioCell = [tableView dequeueReusableCellWithIdentifier:@"TEAudioMessageCell" forIndexPath:indexPath];
        audioCell.playDelegate = self;
        cell = audioCell;
    }
    else{
        TEBubbleCell* messageCell = [tableView dequeueReusableCellWithIdentifier:@"TEMessageCell" forIndexPath:indexPath];
        messageCell.delegate = self;
        cell = messageCell;
    }


    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.frc.sections.lastObject numberOfObjects]) {
        return;
    }
    
    TEBubbleCell *bulleCell = (TEBubbleCell*)cell;
    TEMessage* message = [self.frc objectAtIndexPath:indexPath];
    NSLog(@"TEmessage index row %ld",(long)indexPath.row);
    //[message layoutModel];
    //cell.textLabel.text  = message.content;
    //[bulleCell setLayoutModel:message.layoutModel];
    [bulleCell setMessage:message];
    NSDateFormatter*  dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* dateString = [dateFormatter stringFromDate:message.sendTime];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dateString];
   //NSLog(@"new indexpath row %ld, count %ld",indexPath.row, self.frc.fetchedObjects.count);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:self.frc.fetchedObjects.count - 1 inSection:0];
    //NSLog(@"new indexpath row %ld, count %ld",indexPath.row, self.frc.fetchedObjects.count);
    //[self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.frc.sections.lastObject numberOfObjects]) {
        return 0;
    }
    TEMessage* message = [self.frc objectAtIndexPath:indexPath];
    CGFloat height  = message.layout.cellHeight;
    if(height < 44){
        return 44 + 16;
    }
    return height;
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
   // [self.frc.managedObjectContext processPendingChanges];
}

#pragma mark - *** Timer ***
- (void)timerSelecotor:(NSTimer*)timer
{
    //self.fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sendTime" ascending:YES]];
    
//    NSArray<NSIndexPath*>* visibles = self.tableView.indexPathsForVisibleRows;
//    NSLog(@"😁😁😁😁😁😁😁😁😁😁😁😁😁😁😁 %ld  ",self.frc.fetchedObjects.count);
//    NSInteger visibleFirstIndex = visibles.firstObject.row;
//
//        __weak TEChatTableViewController* weakSelf = self;
//        [weakSelf.frc.managedObjectContext performBlock:^{
//            if(weakSelf.frc.fetchedObjects.count > 50){
//                TEMessage* message = [weakSelf.frc objectAtIndexPath:[NSIndexPath indexPathForRow:visibleFirstIndex inSection:0]];
//                weakSelf.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"sessionID = %lld and sendTime > %@",weakSelf.session.sID,message.sendTime];
//                [weakSelf.fetchRequest setFetchBatchSize:weakSelf.frc.fetchedObjects.count - visibleFirstIndex+1];
//                [weakSelf.fetchRequest setFetchLimit:weakSelf.frc.fetchedObjects.count - visibleFirstIndex+1];
//                
//                
//                NSError* error;
//                if (![weakSelf.frc performFetch:&error]) {
//                    DebugLog(@"Failed to perform fetch : %@",error);
//                }
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [weakSelf.tableView reloadData];
//                });
//               // [weakSelf.frc.managedObjectContext refreshAllObjects];
//                
//            }
//        }];
    
    
    
    
     
        
        //[self performFetch];
   
    
    
}


#pragma mark - *** UIScrollViewDelegate ***

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.autoScrollToBottomWhenNewMessaeComming = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    NSArray<NSIndexPath *> * cellArray = [self.tableView indexPathsForVisibleRows];
    NSIndexPath* lastIndexPath =  cellArray.lastObject;
    NSIndexPath* firstIndexPath = cellArray.firstObject;
    
    NSLog(@"firstPath row:%ld,lastPath row:%ld",firstIndexPath.row,lastIndexPath.row);
    NSInteger rowCount = [self.tableView  numberOfRowsInSection:0];
    if ( rowCount - lastIndexPath.row < 5) {
        self.autoScrollToBottomWhenNewMessaeComming = YES;
    }
    else{
        self.autoScrollToBottomWhenNewMessaeComming = NO;
    }
}

#pragma mark - *** TEBubbleCellDelegate ***
- (void)didSelectImageOfRect:(CGRect)rect inView:(UIView *)view cell:(UITableViewCell*)cell
{
    CGRect rectInSuperView = [self.tableView.superview convertRect:rect fromView:view];
    NSLog(@"rectInSuperView %@",NSStringFromCGRect(rectInSuperView));
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    TEMessage* message  = [self.frc objectAtIndexPath:indexPath];
    TEChatMessage* chatMessage = message.chatMessage;
    TEMsgImageSubItem* imageItem = (TEMsgImageSubItem*)chatMessage.msgItemList.firstObject;
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:rectInSuperView];
//    imageView.backgroundColor = [UIColor blueColor];
//    [self.tableView.superview addSubview:imageView];
    
    
//    for (NSInteger i = 0; i < self.photosArray.count; i ++) {
//        HAHouseImage* imageItem = self.photosArray[i];
//        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        CGRect rect = [self.view convertRect:cell.frame fromView:collectionView];
    NSString* fullImageName = [NSString stringWithFormat:@"%@%@",imageItem.fileName,imageItem.fileExt];
    NSString* fullPath = [imageItem.path stringByAppendingPathComponent:fullImageName];
    LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:fullPath]
                                                                                     HDURL:[NSURL URLWithString:fullPath]
                                                                        imageViewSuperView:cell.contentView
                                                                       positionAtSuperView:rectInSuperView
                                                                                     index:indexPath.row];
     //   [imageItemArray addObject:imageModel];
    //}
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:@[imageModel]
                                                                           currentIndex:indexPath.row];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
    
}

- (void)didSelectLinkOfURL:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


#pragma mark - *** TEBubbleAudioPlayDelegate ***
- (void)didSelectAudioCell:(UITableViewCell*)cell fileName:(NSString*)fileName
{
    [[V2Kit defaultKit] playAudio:fileName];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    //self.audioPlayingRowIndex = indexPath.row;
    NSString* name = [fileName lastPathComponent].stringByDeletingPathExtension;
    
    self.audioPlayingDict[name] = @(indexPath.row);
}

#pragma mark - *** Refresh ***
- (void)loadNewData
{
    //TEMessage* message = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"sessionID == %lld",self.session.sID];
    NSInteger fetchCount = self.frc.fetchedObjects.count;
    NSInteger offset = self.session.totalNumOfMessage - fetchCount - 10;
    if (offset < 0) {
        offset = 0;
    }
    [self.fetchRequest setFetchOffset:offset];
    [self.fetchRequest setFetchLimit:self.session.totalNumOfMessage - offset];
     __weak TEFetchTableViewController* weakSelf = self;
    [self.frc.managedObjectContext performBlock:^{
        NSError* error;
        if(![weakSelf.frc performFetch:&error]){
             DebugLog(@"Failed to perform fetch : %@",error);
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        });
    }];
}



#pragma mark - *** AudioPlaybackDelegate ***
- (void)didStartPlayFile:(NSString*)name errorCode:(NSInteger)code
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (0 == code) {
            NSString* fileName = [name lastPathComponent].stringByDeletingPathExtension;
            NSInteger index = [self.audioPlayingDict[fileName] integerValue];
            
            TEBubbleAudioCell* audioCell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [audioCell startAnimating];
        }
        else{
            ///错误提示
        }
    });
}


- (void)didStopPlayFile:(NSString*)name errorCode:(NSInteger)code
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (0 == code) {
            NSString* fileName = [name lastPathComponent].stringByDeletingPathExtension;
            NSInteger index = [self.audioPlayingDict[fileName] integerValue];
            [self.audioPlayingDict removeObjectForKey:fileName];
            TEBubbleAudioCell* audioCell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [audioCell  stopAnimating];
        }
        else{
            ///
        }
    });
}

@end
