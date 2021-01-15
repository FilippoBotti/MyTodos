//
//  AddNewTodoViewController.m
//  Todo
//
//  Created by Filippo on 26/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import "AddNewTodoViewController.h"
#import "AppDelegate.h"
#import "ToDo+CoreDataClass.h"
#import <UserNotifications/UserNotifications.h>  
#import "Category+CoreDataClass.h"
@interface AddNewTodoViewController () 

@end

@implementation AddNewTodoViewController

/*
 All'interno del metodo viewdidload definiamo le operazioni iniziali di setup del controller
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self cardSetup];
    [self datePickerSetup];
    [self categoryPickerSetup];
    self.cardView.delegate = self;
    [self getNSManagedObjectContext];
    
}

/*
 Richiamiamo il metodo per recuperare i dati da coredata per quanto riguarda le categorie
 */

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self fetchDataFromCoreData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Recuperiamo i dati da coredata e se non è presente alcuna categoria (es. primo avvio app)
 ne aggiungiamo tre di default.
 */

- (void) fetchDataFromCoreData {
    NSFetchRequest *requestCategory = [[NSFetchRequest alloc]initWithEntityName:@"Category"];
    NSError *error = nil;
    if (_context != nil ){
        _category = [[_context executeFetchRequest:requestCategory error:&error] mutableCopy];
        if(error != nil) {
            NSLog(@"Error %@", error);
        }
        else {
            
        }
        NSLog(@"name is %@", [_category valueForKey: @"name"]);
    }
    if(_category.count == 0) {
        [self addCategoryWithName:@"Sport"];
        [self addCategoryWithName:@"Home"];
        [self addCategoryWithName:@"Work"];
    }
}

/*
 Metodo per aggiungere una categoria a coredata
 */

-(void) addCategoryWithName:(NSString *) name{
    Category *entityObj = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:_context];
    entityObj.name = name;
    // Save the object to persistent store
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Can't Save! %@", error);
    }
    else {
        [self fetchDataFromCoreData];
    }
}

/*
 Setup della view contenente il tutto per renderla simile ad una card
 */

-(void) cardSetup
{
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = true;
    self.cardView.layer.borderWidth = 0;
    self.cardView.layer.cornerRadius = 10; // if you like rounded corners
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f); //%%% this shadow will hang slightly down and to the right
    self.cardView.layer.shadowRadius = 2; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.cardView.layer.shadowOpacity = 1.0; //%%% same thing with this, subtle is better for me
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
    self.cardView.directionalLockEnabled = YES;
    
}

/*
 Blocchiamo lo scroll orizzontale per la scroll view contenete i componenti
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}

/*
 Definiamo il datepicker impostando le date selezionabili e il suo comportamento
 */

-(void) datePickerSetup {
    self.dueDatePicker = [[UIDatePicker alloc]init];
    self.dueDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.dueDatePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    self.dueDatePicker.backgroundColor = self.cardView.backgroundColor;
    [self.dueDateLabel setInputView:self.dueDatePicker];
    UIToolbar *dueDateToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *dueDateDoneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *dueDateSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [dueDateToolBar setItems:[NSArray arrayWithObjects:dueDateSpace,dueDateDoneButton, nil]];
//dueDateSpace.backgroundColor = self.cardView.backgroundColor;
    [self.dueDateLabel setInputAccessoryView:dueDateToolBar];

}

/*
 Definiamo il categorypicker
 */

-(void) categoryPickerSetup{
    self.categoryPicker = [[UIPickerView alloc] init];
    self.categoryPicker.backgroundColor = self.cardView.backgroundColor;
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    self.categoryPicker.showsSelectionIndicator = YES;
    [self.categoryLabel setInputView:self.categoryPicker];
    UIToolbar *categoryToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [categoryToolBar setTintColor:self.cardView.backgroundColor];
    UIBarButtonItem *categoryDoneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedCategory)];
    UIBarButtonItem *categorySpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [categoryToolBar setItems:[NSArray arrayWithObjects:categorySpace,categoryDoneButton, nil]];
    [self.categoryLabel setInputAccessoryView:categoryToolBar];

}

/*
 Recuperiamo il context per coredata
 */

- (void)getNSManagedObjectContext {
    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _context = _appDelegate.persistentContainer.viewContext;
}

/*
 Impostiamo una notifica per il todo un giorno prima della data di scadenza (se presente)
 Per quanto iguarda l'ora di notifica, al fine di evitare di mostrarle tutte allo stesso orario,
 viene selezionata l'ora di creazione del todo
 */

-(void) notificationSetupWithText: (NSString *)text{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *previousDate = [theCalendar dateByAddingComponents:dayComponent toDate:_triggerNotificationDate options:0];
    
    NSLog(@"nextDate: %@ ...", previousDate);
    NSLog(@"TriggerDate: %@", _triggerNotificationDate);
    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (!(settings.authorizationStatus != UNAuthorizationStatusAuthorized)) {
            UNMutableNotificationContent *content = [UNMutableNotificationContent new];
            content.title = @"Hai un impegno domani!";
            content.body = text;
            content.sound = [UNNotificationSound defaultSound];
            NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                             components:NSCalendarUnitYear +
                                             NSCalendarUnitMonth + NSCalendarUnitDay +
                                             NSCalendarUnitHour + NSCalendarUnitMinute +
                                             NSCalendarUnitSecond fromDate:previousDate];
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate
                                                repeats:NO];
            NSString *identifier = text;
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                 content:content trigger:trigger];
            
            [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Something went wrong: %@",error);
                }
            }];
            
            NSLog(@"Added notification with identifier %@ and triggerdate %@", identifier, trigger);
        }
    }];
    
}

/*
 Definiamo il comportamento del pulsante di salvataggio verificando i campi presenti all'interno
 delle textbox e dopo aver salvato azzerandoli
 */


- (IBAction)saveToDo:(id)sender {
    
    if(self.toDoLabel.text.length != 0 && self.categoryLabel.text.length != 0) {
        NSLog(@"%@ e %@", self.toDoLabel.text, self.categoryLabel.text);
        ToDo *entityObj = [NSEntityDescription insertNewObjectForEntityForName:@"ToDo" inManagedObjectContext:_context];
        NSLocale* currentLocale = [NSLocale currentLocale];
        NSDate *currentTime = [[NSDate alloc]init];
        [currentTime descriptionWithLocale:currentLocale];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/YYYY"];
        entityObj.name = self.toDoLabel.text;
        entityObj.category = self.categoryLabel.text;
        entityObj.creationDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:currentTime]];
        entityObj.state = NO;
        //Verifico i campi opzionali
        if (self.dueDateLabel.text.length != 0) {
            entityObj.dueDate = self.dueDateLabel.text;
        }
        
        if (self.noteLabel.text.length != 0) {
            entityObj.note = self.noteLabel.text;
        }
        // Save the object to persistent store
        NSError *error = nil;
        if (![_context save:&error]) {
            NSLog(@"Can't Save! %@", error);
        }
        else {
            NSLog(@"Todo correctly saved %@", entityObj);
            if (entityObj.dueDate.length != 0){
                NSString *notificationID = [NSString stringWithFormat:@"%@ %@", entityObj.name, entityObj.dueDate];
                [self notificationSetupWithText:notificationID];
            }
            self.toDoLabel.text = @"";
            self.categoryLabel.text = @"";
            self.dueDateLabel.text = @"";
            self.noteLabel.text = @"";
            
        }
    }
}

/*
 Impostiamo i metodi per la selezione della data e della categoria
 dai rispettivi datepicker
 */

-(void)showSelectedDate
{   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    self.dueDateLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_dueDatePicker.date]];
    [self.dueDateLabel resignFirstResponder];
    _triggerNotificationDate = self.dueDatePicker.date;
}

-(void) showSelectedCategory {
    [self.categoryLabel resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _category.count;
}


-(NSAttributedString *) pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Category *cat = [_category objectAtIndex:row];
    NSAttributedString *attString =
    [[NSAttributedString alloc] initWithString:cat.name attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attString;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    Category *cat = [_category objectAtIndex:row];
    self.categoryLabel.text = cat.name;
}

-(void)ShowSelectedCategory
{   [self.categoryLabel resignFirstResponder];
}

@end
