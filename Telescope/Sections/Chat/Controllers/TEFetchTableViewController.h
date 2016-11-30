//
//  TEFetchTableViewController.h
//  Telescope
//
//  Created by zhangguang on 16/11/30.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TEFetchTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSFetchedResultsController* frc;

- (void)performFetch;

@end
