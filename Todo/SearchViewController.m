//
//  SearchViewController.m
//  Todo
//
//  Created by Filippo on 26/11/20.
//  Copyright © 2020 Filippo. All rights reserved.
//

#import "SearchViewController.h"
#import "ToDoTableViewTableViewController.h"
#import "Category+CoreDataClass.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

/*
 All'interno del viewdidload facciamo il setup dei componenti principali della vista
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cardSetup];
    [self dueDatePickerSetup];
    [self creationDateSetup];
    [self categoryPickerSetup];
    [self getNSManagedObjectContext];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 All'interno del metodo viewwillappear allochiamo il filtro,
 recuperiamo le categorie da coredata e azzeriamo i campi di ricerca
 */

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    self.filter = [[MDFilter alloc] init];
    self.filter.state =  (int)(self.stateSegmentedControl.selectedSegmentIndex-1);
    [self fetchDataFromCoreData];
    self.categoryLabel.text = @"";
    self.creationDateLabel.text = @"";
    self.dueDateLabel.text = @"";
}

/*
 Recuperiamo da coredata le categorie e se non presenti (es. utente le elimina tutte per errore)
 ne aggiungiamo tre di default
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
 Aggiungiamo le categorie a coredata
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
 Recuperiamo il context
 */

- (void)getNSManagedObjectContext {
    _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _context = _appDelegate.persistentContainer.viewContext;
    
}

/*
 Setup della vista principale
 */

- (void) cardSetup {
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = true;
    self.cardView.layer.borderWidth = 0;
    self.cardView.layer.cornerRadius = 10; // if you like rounded corners
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f); //%%% this shadow will hang slightly down and to the right
    self.cardView.layer.shadowRadius = 2; //%%% I prefer thinner, subtler shadows, but you can play with this
    self.cardView.layer.shadowOpacity = 1.0; //%%% same thing with this, subtle is better for me
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
}

/*
 Setup dei picker per la data di creazione, di scadenza e per la categoria
 */

- (void) dueDatePickerSetup {
    self.dueDatePicker = [[UIDatePicker alloc]init];
    self.dueDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.dueDatePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    self.dueDatePicker.backgroundColor = self.cardView.backgroundColor;
    [self.dueDateLabel setInputView:self.dueDatePicker];
    UIToolbar *dueDateToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *dueDateDoneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedDueDate)];
    UIBarButtonItem *dueDateSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [dueDateToolBar setItems:[NSArray arrayWithObjects:dueDateSpace,dueDateDoneButton, nil]];
    //dueDateSpace.backgroundColor = self.cardView.backgroundColor;
    [self.dueDateLabel setInputAccessoryView:dueDateToolBar];
}

-(void) creationDateSetup {
    self.creationDatePicker = [[UIDatePicker alloc]init];
    self.creationDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.creationDatePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    self.creationDatePicker.backgroundColor = self.cardView.backgroundColor;
    [self.creationDateLabel setInputView:self.creationDatePicker];
    UIToolbar *creationDateToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *creationDateDoneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedCreationDate)];
    UIBarButtonItem *creationDateSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [creationDateToolBar setItems:[NSArray arrayWithObjects:creationDateSpace,creationDateDoneButton, nil]];
    //dueDateSpace.backgroundColor = self.cardView.backgroundColor;
    [self.creationDateLabel setInputAccessoryView:creationDateToolBar];
}

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

-(void)showSelectedDueDate
{   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    self.dueDateLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_dueDatePicker.date]];
    [self.dueDateLabel resignFirstResponder];
    if(self.dueDateLabel.text.length != 0)
        self.filter.dueDate = self.dueDateLabel.text;
}

-(void)showSelectedCreationDate
{   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    self.creationDateLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:_creationDatePicker.date]];
    [self.creationDateLabel resignFirstResponder];
    if(self.creationDateLabel.text.length != 0)
        self.filter.creationDate = self.creationDateLabel.text;
}

-(void) showSelectedCategory {
    [self.categoryLabel resignFirstResponder];
    if(self.categoryLabel.text.length != 0)
        self.filter.category = self.categoryLabel.text;
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



 #pragma mark - Navigation
 /*
  Determiniamo il comportamento del pulsante di ricerca
  */
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"searchSegue"]) {
         if([segue.destinationViewController isKindOfClass:[ToDoTableViewTableViewController class]]){
             NSLog(@"Filtro ecco %@", self.filter.description);
             ToDoTableViewTableViewController *destViewController = segue.destinationViewController;
             destViewController.filter = self.filter;
         }
     }
 }

/*
 Determiniamo il comportamento del segmentedcontroller per lo stato dei todo
 */

- (IBAction)selectState:(id)sender {
    switch (self.stateSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.filter.state = -1;
            break;
        case 1:
            self.filter.state = 0;
            break;
        case 2:
            self.filter.state = 1;
            break;
    }

}
@end
