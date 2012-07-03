//
//  ITVAlphabetTableBase.h
//  AlphabetTable
//
//  Created by Bryce Redd on 7/3/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ITVAlphabetObject <NSObject>
- (NSString*) title;
@end

@interface ITVAlphabetTableBase : UITableView <UITableViewDataSource>
- (NSObject<ITVAlphabetObject>*) objectForIndexPath:(NSIndexPath*)path;


// protected methods -- don't call these!
@property(nonatomic, strong) id<UITableViewDataSource> tableDatasource;
- (void) setup;
+ (NSString*) keyForObject:(NSObject<ITVAlphabetObject>*)object;

@end
