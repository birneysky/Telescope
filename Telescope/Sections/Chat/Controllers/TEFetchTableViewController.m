//
//  TEFetchTableViewController.m
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TEFetchTableViewController.h"
#import <CoreData/CoreData.h>

@interface TEFetchTableViewController () 

@end

@implementation TEFetchTableViewController

- (void)dealloc
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.separatorColor = [UIColor redColor];
    
    //self.tableView.separatorEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.frc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.frc.sections objectAtIndex:section] numberOfObjects];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.frc sectionForSectionIndexTitle:title atIndex:index];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.frc sections] objectAtIndex:section] name];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.frc sectionIndexTitles];
}

#pragma mark - *** Fetching ***

- (void) performFetch
{
    __weak TEFetchTableViewController* weakSelf = self;
    if (self.frc) {
        [self.frc.managedObjectContext performBlock:^{
            NSError* error = nil;
            if (![weakSelf.frc performFetch:&error]) {
                DebugLog(@"Failed to perform fetch : %@",error);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            //NSLog(@"context managed object count = %lx",[[weakSelf.frc.managedObjectContext registeredObjects] count]);
        }];
    }
}

#pragma mark - *** DELEGATE: NSFetchedResultsController ***

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
    });
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView endUpdates];
    });
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
            });
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
                
            });
        }
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
//                    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:self.frc.fetchedObjects.count - 1 -1 inSection:0];
//                    NSLog(@"new indexpath row %ld, count %ld",indexPath.row, self.frc.fetchedObjects.count);
//                    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
//                    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:newIndexPath];
//                    CGRect rect = [cell convertRect:cell.frame fromView:self.tableView];

                });

            }
            break;
        case NSFetchedResultsChangeDelete:
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
            break;
        case NSFetchedResultsChangeUpdate:
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (!newIndexPath) {
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                              withRowAnimation:UITableViewRowAnimationNone];
                    }
                    else{
                        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                              withRowAnimation:UITableViewRowAnimationNone];
                        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                              withRowAnimation:UITableViewRowAnimationNone];
                    }
                });
            }
            break;
        case NSFetchedResultsChangeMove:
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                });
            }
            break;
        default:
            break;
    }
}

@end
