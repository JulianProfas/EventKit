//
//  EventManager.m
//  EventKitDemo
//
//  Created by Julian Profas on 24/01/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.eventStore = [[EKEventStore alloc] init];
    
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil) {
            self.eventsAccessGranted = [userDefaults valueForKey:@"eventkit_events_access_granted"];
            self.selectedCalendarIdentifier = [userDefaults objectForKey:@"eventkit_selected_calendar"];
        } else {
            self.eventsAccessGranted = NO;
            self.selectedCalendarIdentifier = @"";
        }
    }
    return self;
}

-(void)saveCustomCalendarIdentifier:(NSString *)identifier {
    [self.arrCustomCalendarIdentifiers addObject:identifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.arrCustomCalendarIdentifiers forKey:@"eventkit_cal_identifiers"];
}

-(void)setEventsAccessGranted:(BOOL)eventsAccessGranted{
    _eventsAccessGranted = eventsAccessGranted;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:eventsAccessGranted] forKey:@"eventkit_events_access_granted"];
}

-(NSArray *)getLocalEventCalendars{
    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<allCalendars.count; i++) {
        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
        if (currentCalendar.type == EKCalendarTypeLocal) {
            [localCalendars addObject:currentCalendar];
        }
    }
    return (NSArray *)localCalendars;
}

-(void)setSelectedCalendarIdentifier:(NSString *)selectedCalendarIdentifier {
    _selectedCalendarIdentifier = selectedCalendarIdentifier;
    
    [[NSUserDefaults standardUserDefaults] setObject:selectedCalendarIdentifier forKey:@"eventkit_selected_calendar"];
}

@end
