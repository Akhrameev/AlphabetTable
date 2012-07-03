//
//  CoreDataWord.h
//  AlphabetTable
//
//  Created by Bryce Redd on 7/3/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ITVAlphabetTableView.h"


@interface CoreDataWord : NSManagedObject <ITVAlphabetObject>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, strong) NSString * title;

@end
