//
//  ITVAlphabetTableView.m
//  AlphabetTable
//
//  Created by Bryce Redd on 6/27/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "ITVAlphabetTableView.h"

@interface ITVAlphabetTableView()
@property(nonatomic, strong) NSMutableDictionary* objectsByLetter;
@property(nonatomic, strong) NSArray* alphabet;
@property(nonatomic, strong) NSArray* filteredAlphabet;
@property(nonatomic, strong) NSArray* searchResults;
@property(nonatomic, assign) BOOL isSearching;

- (NSArray*) flatObjects;

@end

@implementation ITVAlphabetTableView

- (void) setup {
    [super setup];
    
    self.alphabet = [NSArray arrayWithObjects:@" ",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    self.searchResults = [NSArray array];
    self.isSearching = NO;
    
    self.objectsByLetter = [NSMutableDictionary dictionary];
    
}

- (void) addObjectsFromArray:(NSArray*)array {
    NSComparator sort = ^(NSObject<ITVAlphabetObject>* a, NSObject<ITVAlphabetObject>* b) {
        return [a.title compare:b.title];
    };
    
    for(NSObject<ITVAlphabetObject>* object in array) {
        NSString* letter = [ITVAlphabetTableView keyOnPath:@"title" forObject:object];
        NSMutableArray* objects = [self.objectsByLetter objectForKey:letter];
        if(!objects) {
            objects = [NSMutableArray array];
            [self.objectsByLetter setObject:objects forKey:letter];
        }
        [objects addObject:object];
    }
    
    [self.objectsByLetter enumerateKeysAndObjectsUsingBlock:^(NSString* letter, NSMutableArray* objects, BOOL *stop) {
        [objects sortUsingComparator:sort];
    }];
    
    [self updateFilteredArray];
}

- (void) removeObjectsFromArray:(NSArray*)array {
    for(NSObject<ITVAlphabetObject>* object in array) {
        NSString* letter = [ITVAlphabetTableView keyOnPath:@"title" forObject:object];
        NSMutableArray* objects = [self.objectsByLetter objectForKey:letter];
        [objects removeObject:object];
        
        if(![objects count]) {
            [self.objectsByLetter removeObjectForKey:letter];
        }
    }
    
    [self updateFilteredArray];
}

- (void) removeAllObjects {
    [self setup];
}

- (NSArray*) indexesOfObjects:(NSArray*)array {
    NSMutableArray* indices = [NSMutableArray array];
    
    
    for(NSObject<ITVAlphabetObject>* object in array) {
    
        if(self.isSearching) {
        
            int index = [self.searchResults indexOfObject:object];
            if(index != NSNotFound) {
                [indices addObject:[NSIndexPath indexPathForRow:index inSection:0]];
            }
            
        } else {
        
            NSString* letter = [ITVAlphabetTableBase keyOnPath:@"title" forObject:object];
            NSMutableArray* types = [self.objectsByLetter objectForKey:letter];
            
            int row = [types indexOfObject:object];
            int section = [self.filteredAlphabet indexOfObject:letter];
            
            if(row == NSNotFound || section == NSNotFound)
                NSLog(@"index could not be found!");
            
            [indices addObject:[NSIndexPath indexPathForRow:row inSection:section]];
        }
    }
    return indices;
}

- (void) clearFilter {
    self.isSearching = NO;
    self.searchResults = [NSArray array];
    [self reloadData];
}

- (void) filterByPredicate:(NSPredicate*)predicate {
    NSArray* flat = [self flatObjects]; 
    
    self.isSearching = YES;
    self.searchResults = [flat filteredArrayUsingPredicate:predicate];
    
    [self reloadData];
}

- (NSArray*) flatObjects {
    NSMutableArray* array = [NSMutableArray array];
    
    [self.objectsByLetter enumerateKeysAndObjectsUsingBlock:^(NSString* letter, NSMutableArray* objects, BOOL *stop) {
        [array addObjectsFromArray:objects];
    }];
    
    return array;
    
}

- (NSObject<ITVAlphabetObject>*) objectForIndexPath:(NSIndexPath*)path {
    if(!self.isSearching) {
        return [[self.objectsByLetter objectForKey:[self.filteredAlphabet objectAtIndex:path.section]] objectAtIndex:path.row];
    } else {
        return [self.searchResults objectAtIndex:path.row];
    }
}

- (void) updateFilteredArray {
    NSArray* lettersInUse = [self.objectsByLetter allKeys];
    
    self.filteredAlphabet = [lettersInUse sortedArrayUsingComparator:^(NSString* a, NSString* b) {
        return [a compare:b];
    }];
}

#pragma mark - tableview datasource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(self.isSearching) return nil;
    NSMutableArray* uppercaseLetter = [NSMutableArray array];
    
    [self.filteredAlphabet enumerateObjectsUsingBlock:^(NSString* letter, NSUInteger index, BOOL* stop) {
        [uppercaseLetter addObject:[letter uppercaseString]];
    }];
    
    return uppercaseLetter;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(self.isSearching) return nil;
    return [[self.filteredAlphabet objectAtIndex:section] uppercaseString];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isSearching) return 1;
    return [self.filteredAlphabet count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isSearching) return [self.searchResults count];
    
    NSString* letter = [self.filteredAlphabet objectAtIndex:section];
    
    return [[self.objectsByLetter objectForKey:letter] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.tableDatasource != self && [self.tableDatasource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.tableDatasource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    static NSString *cellIdentifier = @"VanillaCell";
    
    NSObject<ITVAlphabetObject>* object = [self objectForIndexPath:indexPath];
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setText:object.title];
    
    return cell;
}


@end
