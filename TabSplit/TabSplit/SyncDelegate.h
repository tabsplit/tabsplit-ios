//
//  SyncDelegate.h
//  TabSplit
//
//  Created by Herbert Poul on 10/15/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncDelegate <NSObject>;

- (void)loginResult:(BOOL) successful;
- (void)currenciesSynced;
- (void)contactsSynced;

@end
