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

@interface TEChatSessionViewController ()

@property (nonatomic,strong) TEMessageFactory* msgFactory;

@end

@implementation TEChatSessionViewController

#pragma mark - *** Properties ***
- (TEMessageFactory*)msgFactory
{
    if (!_msgFactory) {
        _msgFactory = [[TEMessageFactory alloc] init];
    }
    return _msgFactory;
}


#pragma mark - *** Init ***
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    [self.msgFactory start];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performFetch)
                                                 name:@"SomethingChanged"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SomethingChanged" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"session view controller context managed object count = %lu",[[self.frc.managedObjectContext registeredObjects] count]);
}

#pragma mark - *** Configure ***
- (void)configureFetch
{
    TECoreDataHelper* dataHelper = [TECoreDataHelper defaultHelper];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"TEChatSession"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"timeToRecvLastMessage" ascending:NO]];
    [request setFetchBatchSize:20];
    //[request setFetchLimit:20];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:dataHelper.defaultContext sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}


#pragma mark - *** Table View ***
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Session Cell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MessageSession* session = [self.frc objectAtIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",session.remoteUserID];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",session.sendTime];
}

#pragma mark - *** ***

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    ChatViewController* chatVC = segue.destinationViewController;
//    if ([segue.identifier isEqualToString:@"show details"]) {
//        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
//        MessageSession* session = [self.frc objectAtIndexPath:indexPath];
//        //NSOrderedSet* set = session.messages;
//        chatVC.session = session;
//    }
}

@end
