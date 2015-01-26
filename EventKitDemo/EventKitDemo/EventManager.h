//
//  EventManager.h
//  EventKitDemo
//
//  Created by Julian Profas on 24/01/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;
@property (nonatomic, strong) NSString *selectedCalendarIdentifier;
@property (nonatomic, strong) NSMutableArray *arrCustomCalendarIdentifiers;

-(NSArray *)getLocalEventCalendars;
-(void)saveCustomCalendarIdentifier:(NSString *)identifier;

@end
