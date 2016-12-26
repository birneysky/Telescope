//
//  TEChatSessionViewController.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEChatSessionViewController.h"
#import <CoreData/CoreData.h>
#import "TECoreDataHelper.h"
#import "TEMessageFactory.h"
#import "TEChatSession+CoreDataProperties.h"
#import "TECacheUser+CoreDataProperties.h"

#import "TEChatSessionCell.h"
#import "TEChatViewController.h"

#import "TEV2KitChatDemon.h"

@interface TEChatSessionViewController ()

@property (nonatomic,strong) TEMessageFactory* msgFactory;

@property (nonatomic,strong) NSArray<NSString*>* imageNames;

@end

@implementation TEChatSessionViewController

- (void)dealloc
{
    [self.msgFactory stop];
}

#pragma mark - *** Properties ***
- (TEMessageFactory*)msgFactory
{
    if (!_msgFactory) {
        _msgFactory = [[TEMessageFactory alloc] init];
    }
    return _msgFactory;
}

- (NSArray<NSString*>*)imageNames
{
    if (!_imageNames) {
        _imageNames = @[@"te_user_head_img",@"te_user_head_img_1",@"te_user_head_img_2",@"te_user_head_img_3",@"te_user_head_img_4",@"te_user_head_img_5",@"te_user_head_img_6",@"te_user_head_img_7"];
    }
    return _imageNames;
}

#pragma mark - *** Init ***
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    //[self performFetch];
    //[self.msgFactory start];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFetch)
                                                 name:TENewMessageComming
                                               object:nil];
    [self performFetch];
   // self.frc.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TENewMessageComming object:nil];
    //self.frc.delegate = nil;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.frc.delegate = self;
    //NSLog(@"session view controller context managed object count = %lu",[[self.frc.managedObjectContext registeredObjects] count]);
}

#pragma mark - *** Configure ***
- (void)configureFetch
{
    TECoreDataHelper* dataHelper = [TECoreDataHelper defaultHelper];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timeToRecvLastMessage" ascending:NO]];
    [request setFetchBatchSize:20];
    //[request setFetchLimit:20];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:dataHelper.backgroundContext sectionNameKeyPath:nil cacheName:@"TEChatCache"];
    //self.frc.delegate = self;
}


#pragma mark - *** Table View ***
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TEChatSessionCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TEChatSession* session = [self.frc objectAtIndexPath:indexPath];
    TEChatSessionCell* sessionCell = (TEChatSessionCell*)cell;
    
//    TECoreDataHelper* dataHelper = [TECoreDataHelper defaultHelper];
//    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TECacheUser"];
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"uid == %lld",session.senderID];
//    [request setPredicate:predicate];
//    NSError* error;
//    NSArray* arry =  [dataHelper.backgroundContext executeFetchRequest:request error:&error];
//    if (arry.count >= 1) {
//        [sessionCell setUserName:((TECacheUser*)arry.firstObject).nickName];
//    }
//    else{
//        assert(0);
//    }
    [sessionCell setUserName:[NSString stringWithFormat:@"%lld",session.remoteUsrID]];
    NSString* randomImageName = self.imageNames[arc4random() % self.imageNames.count];
    sessionCell.imageView.image = [UIImage imageNamed:randomImageName];
    [sessionCell setMessageOverView:session.overviewOfLastMessage];
    [sessionCell setMessageDate:session.timeToRecvLastMessage];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self performSegueWithIdentifier:@"te_push_chat_session_detail" sender:indexPath];
    [self.tableView endUpdates];
}

#pragma mark - *** Navigation ***

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"te_push_chat_session_detail"]) {
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        TEChatSession* session = [self.frc objectAtIndexPath:indexPath];
        TEChatViewController* tcvc = (TEChatViewController*)segue.destinationViewController;
        tcvc.session = session;
    }
}

@end
