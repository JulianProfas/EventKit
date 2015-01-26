//
//  CalendarsViewController.m
//  EventKitDemo
//
//  Created by Gabriel Theodoropoulos on 11/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "CalendarsViewController.h"
#import "AppDelegate.h"


@interface CalendarsViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *arrCalendars;

-(void)loadEventCalendars;
-(void)createCalendar;

@end

@implementation CalendarsViewController

-(void)createCalendar {
    UITextField *textField = (UITextField *)[[self.tblCalendars cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:10];
    [textField resignFirstResponder];
    
    if (textField.text.length == 0) {
        return;
    }
    
    EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.appDelegate.eventManager.eventStore];
    calendar.title = textField.text;
    calendar.source = EKSourceTypeLocal;
    
    NSError *error;
    [self.appDelegate.eventManager.eventStore saveCalendar:calendar commit:YES error:&error];
    
    if (error == nil) {
        [self.tblCalendars setEditing:NO animated:YES];
        
        [self.appDelegate.eventManager saveCustomCalendarIdentifier:calendar.calendarIdentifier];
        
        [self loadEventCalendars];
    } else {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)loadEventCalendars {
    self.arrCalendars = [self.appDelegate.eventManager getLocalEventCalendars];
    
    [self.tblCalendars reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Make self the delegate and datasource of the table view.
    self.tblCalendars.delegate = self;
    self.tblCalendars.dataSource = self;
    
    // Instantiate the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loadEventCalendars];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.tblCalendars.isEditing) {
        return self.arrCalendars.count;
    } else {
        return self.arrCalendars.count + 1;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellCalendar"];
    
    if (self.tblCalendars.isEditing) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellEdit"];
            
            UITextField *textField = (UITextField *)[cell viewWithTag:10];
            textField.delegate = self;
        }
    }
    
    if (!self.tblCalendars.isEditing || (self.tblCalendars.isEditing && indexPath.row != 0)) {
        NSInteger row = self.tblCalendars.isEditing ? indexPath.row - 1 : indexPath.row;
        
        EKCalendar *currentCalendar = [self.arrCalendars objectAtIndex:row];
        
        if (!self.tblCalendars.isEditing) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            
            if (self.appDelegate.eventManager.selectedCalendarIdentifier.length > 0) {
                if ([currentCalendar.calendarIdentifier isEqualToString:self.appDelegate.eventManager.selectedCalendarIdentifier]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            } else {
                if (indexPath.row == 0) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
    }
    
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    
    self.appDelegate.eventManager.selectedCalendarIdentifier = [[self.arrCalendars objectAtIndex:indexPath.row] calendarIdentifier];
    
    [self.tblCalendars reloadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self createCalendar];
    } else {
        
    }
}


#pragma mark - IBAction method implementation

- (IBAction)editCalendars:(id)sender {
    [self.tblCalendars setEditing:!self.tblCalendars.isEditing animated:YES];
    
    [self.tblCalendars reloadData];
}


#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self createCalendar];
    
    return YES;
}


#pragma mark - UIAlertViewDelegate method implementation

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
