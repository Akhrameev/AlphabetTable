//
//  ITVAlphabetTableView.h
//  AlphabetTable
//
//  Created by Bryce Redd on 6/27/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITVAlphabetTableBase.h"

@protocol ITVAlphabetObject;

@interface ITVAlphabetTableView : ITVAlphabetTableBase


// dynamically add/remove alphabet objects from an array
// these methods do not call reloaddata on your table view
- (void) addObjectsFromArray:(NSArray*)array;
- (void) removeObjectsFromArray:(NSArray*)array;
- (void) removeAllObjects;


// methods for individual row updates
- (NSArray*) indexesOfObjects:(NSArray*)array;
- (NSObject<ITVAlphabetObject>*) objectForIndexPath:(NSIndexPath*)path;


// filter the table by using a predicate, best used
// for easy searching, these will auto-refresh the table
- (void) clearFilter;
- (void) filterByPredicate:(NSPredicate*)predicate;

@end
