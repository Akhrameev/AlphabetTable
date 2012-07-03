//
//  ITVAlphabetCoreDataTableView.h
//  AlphabetTable
//
//  Created by Bryce Redd on 7/3/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ITVAlphabetTableBase.h"

@interface ITVAlphabetCoreDataTableView : ITVAlphabetTableBase <NSFetchedResultsControllerDelegate>

- (void) loadTableWithPredicate:(NSPredicate*)predicate entity:(NSEntityDescription*)entity context:(NSManagedObjectContext*)context titlePath:(NSString*)path;

@end
