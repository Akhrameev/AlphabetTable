//
//  ITVWord.h
//  AlphabetTable
//
//  Created by Bryce Redd on 6/27/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITVAlphabetTableView.h"

@interface ITVWord : NSObject <ITVAlphabetObject>
@property(nonatomic, strong) NSString* title;
@end
