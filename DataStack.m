//
//  DataStack.m
//  EveryTodoItAgain
//
//  Created by Steve on 2015-09-16.
//  Copyright © 2015 Steve. All rights reserved.
//

#import "DataStack.h"

@interface DataStack ()

@property (nonatomic, strong) NSManagedObjectModel *mom;
@property (nonatomic, strong) NSPersistentStoreCoordinator *psc;

@end

@implementation DataStack

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // get managed object model description url
        
        NSURL *momdURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        
        
        // init managed object model
        self.mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momdURL];
        
        
        // init persistent store coordinator
        self.psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.mom];
        
        
        // get data store url
        
        NSString *storePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"datastore.sqlite"];
        
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        // add a NSSQLiteStoreType PS to the PSC
        
        NSError *storeError = nil;
        
        if (![self.psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&storeError]) {
            
            NSLog(@"Couldn't create persistant store %@", storeError);
        }
        
        // make a MOC
        
        self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        
        // set the MOCs PSC
        
        self.context.persistentStoreCoordinator = self.psc;
        
        
    }
    return self;
}

@end
