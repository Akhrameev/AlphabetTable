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
@property(nonatomic, strong) NSArray* searchResults;
@property(nonatomic, assign) BOOL isSearching;

@property(nonatomic, strong) id<UITableViewDataSource> tableDatasource;

- (void) setup;
- (NSString*) keyForObject:(NSObject<ITVAlphabetObject>*)object;
- (NSArray*) flatObjects;

@end

@implementation ITVAlphabetTableView

@synthesize objectsByLetter, alphabet, searchResults, isSearching, tableDatasource;

- (id) initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setup];
    } return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if((self = [super initWithFrame:frame style:style])) {
        [self setup];
    } return self;
}

- (void) setValue:(id)value forKey:(NSString *)key {

    // poor mans swizzling here
    
    if([key isEqualToString:@"dataSource"]) { key = @"tableDatasource"; }
    if([key isEqualToString:@"_dataSource"]) { key = @"dataSource"; }
    
    [super setValue:value forKey:key];
}

- (void) setup {
    self.alphabet = [NSArray arrayWithObjects:@" ",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    self.searchResults = [NSArray array];
    self.isSearching = NO;
    
    self.tableDatasource = self.dataSource;
    
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for(NSString* letter in self.alphabet) {
        [dictionary setObject:[NSMutableArray array] forKey:letter];
    }
    
    self.objectsByLetter = dictionary;
    
    [self setValue:self forKey:@"_dataSource"];
}

- (void) addObjectsFromArray:(NSArray*)array {
    NSComparator sort = ^(NSObject<ITVAlphabetObject>* a, NSObject<ITVAlphabetObject>* b) {
        return [a.title compare:b.title];
    };
    
    for(NSObject<ITVAlphabetObject>* object in array) {
        NSString* letter = [self keyForObject:object];
        NSMutableArray* objects = [self.objectsByLetter objectForKey:letter];
        [objects addObject:object];
    }
    
    [self.objectsByLetter enumerateKeysAndObjectsUsingBlock:^(NSString* letter, NSMutableArray* objects, BOOL *stop) {
        [objects sortUsingComparator:sort];
    }];
}

- (void) removeObjectsFromArray:(NSArray*)array {
    for(NSObject<ITVAlphabetObject>* object in array) {
        NSString* letter = [self keyForObject:object];
        NSMutableArray* objects = [self.objectsByLetter objectForKey:letter];
        [objects removeObject:object];
    }
}

- (void) removeAllObjects {
    [self setup];
}

- (NSArray*) indexesOfObjects:(NSArray*)array {
    NSMutableArray* indices = [NSMutableArray array];
    
    for(NSObject<ITVAlphabetObject>* object in array) {
    
        NSString* letter = [self keyForObject:object];
        
        NSMutableArray* types = [self.objectsByLetter objectForKey:letter];
        
        int row = [types indexOfObject:object];
        int section = [self.alphabet indexOfObject:letter];
        
        if(row == NSNotFound || section == NSNotFound)
            NSLog(@"index could not be found!");
        
        [indices addObject:[NSIndexPath indexPathForRow:row inSection:section]];
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

- (NSString*) keyForObject:(NSObject<ITVAlphabetObject>*)object {

    // some titles won't start with a letter or have 
    // a number or a weird character.  in this case we'll
    // dump them into the empty space section
    
    static NSCharacterSet *s = nil;
    
    if(!s) s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    
    NSString* letter = nil;
    if([[object title] length]) {
        letter = [[[object title] substringToIndex:1] lowercaseString];
    } else {
        letter = @" ";
    }
    
    NSRange r = [letter rangeOfCharacterFromSet:s];
    
    if(r.location == NSNotFound) {
        letter = @" ";
    }
    
    return letter;
}

- (NSObject<ITVAlphabetObject>*) objectForIndexPath:(NSIndexPath*)path {
    if(!self.isSearching) {
        return [[self.objectsByLetter objectForKey:[self.alphabet objectAtIndex:path.section]] objectAtIndex:path.row];
    } else {
        return [self.searchResults objectAtIndex:path.row];
    }
}

#pragma mark - tableview datasource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(self.isSearching) return nil;
    NSMutableArray* uppercaseLetter = [NSMutableArray array];
    
    [self.alphabet enumerateObjectsUsingBlock:^(NSString* letter, NSUInteger index, BOOL* stop) {
        [uppercaseLetter addObject:[letter uppercaseString]];
    }];
    
    return uppercaseLetter;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(self.isSearching) return nil;
    return [[self.alphabet objectAtIndex:section] uppercaseString];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isSearching) return 1;
    return self.alphabet.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isSearching) return [self.searchResults count];
    
    NSString* letter = [self.alphabet objectAtIndex:section];
    
    return [[self.objectsByLetter objectForKey:letter] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.tableDatasource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
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