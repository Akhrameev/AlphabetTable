//
//  ITVAlphabetTableBase.m
//  AlphabetTable
//
//  Created by Bryce Redd on 7/3/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "ITVAlphabetTableBase.h"
#import "ITVAlphabetTable.h"


@implementation ITVAlphabetTableBase
@synthesize tableDatasource;

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
    [self setValue:self forKey:@"_dataSource"];
    self.tableDatasource = self.dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


+ (NSString*) keyForObject:(NSObject<ITVAlphabetObject>*)object {

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

@end
