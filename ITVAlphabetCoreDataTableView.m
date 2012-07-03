//
//  ITVAlphabetCoreDataTableView.m
//  AlphabetTable
//
//  Created by Bryce Redd on 7/3/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "ITVAlphabetCoreDataTableView.h"

@interface ITVAlphabetCoreDataTableView()
@property(nonatomic, strong) NSFetchedResultsController* controller;
@end

@implementation ITVAlphabetCoreDataTableView

@synthesize controller;

- (void) loadTableWithPredicate:(NSPredicate*)predicate entity:(NSEntityDescription*)entity context:(NSManagedObjectContext*)context titlePath:(NSString*)path {

    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:path ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    request.entity = entity;
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    request.fetchBatchSize = 20;
    
    self.controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"_firstLetterOfTitle" cacheName:@"a cache"];
    self.controller.delegate = self;
    
    NSError* error;
    [self.controller performFetch:&error];
    [self reloadData];
    
    if(error) { 
        NSLog(@"there was an error: %@", error); 
    }
    
}

- (NSObject<ITVAlphabetObject>*) objectForIndexPath:(NSIndexPath*)path {
    return [self.controller objectAtIndexPath:path];
}

#pragma mark - tableview datasource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.controller sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[[self.controller sections] objectAtIndex:section] name] uppercaseString];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.controller sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[self.controller sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.tableDatasource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [self.tableDatasource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    static NSString *cellIdentifier = @"VanillaCell";
    
    NSObject<ITVAlphabetObject>* object = [self.controller objectAtIndexPath:indexPath];
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
 
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.textLabel setText:object.title];
    
    return cell;
}

#pragma mark - updates

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}
 
 
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
 
    UITableView *tableView = self;
 
    switch(type) {
 
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
 
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
 
        case NSFetchedResultsChangeUpdate:
            [tableView cellForRowAtIndexPath:indexPath];
            break;
 
        case NSFetchedResultsChangeMove:
           [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
           [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
           break;
    }
}
 
 
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
 
    switch(type) {
 
        case NSFetchedResultsChangeInsert:
            [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
 
        case NSFetchedResultsChangeDelete:
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
 
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}

@end

@interface NSManagedObject(ITVAlphabetTable)
- (NSString*) _firstLetterOfTitle;
@end

@implementation NSManagedObject(ITVAlphabetTable)
- (NSString*) _firstLetterOfTitle {
    return [ITVAlphabetTableBase keyForObject:(NSObject<ITVAlphabetObject>*)self];
}
@end
